import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:frontend_chat/repositories/api_response.dart';
import 'package:frontend_chat/utils/constants.dart';
import 'package:frontend_chat/utils/global.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import '../../models/chat_models.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // late IO.Socket socket;
  List<ChatMessage> messages = [];

  ChatBloc() : super(ChatInitial()) {
    globalSocket = IO.io(websocket, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    globalSocket!.on('connect', (_) {
      add(ChatConnected());
    });

    globalSocket!.on('sentMessage', (data) => _handleIncomingMessage(data));
    globalSocket!.on('newMessage', (data) => _handleIncomingMessage(data));

    on<ChatConnect>(_onChatConnect);
    on<ChatSendMessage>(_onChatSendMessage);
    on<ChatMessageReceived>(_onChatMessageReceived);
  }

  void _handleIncomingMessage(dynamic data) {
    if (data is String) {
      data = json.decode(data);
    }
    final message = ChatMessage.fromJson(data);
    messages.add(message);
    add(ChatMessageReceived(message));

    // Update new message count
    final senderId = message.senderId;
    if (newMessageCounts.containsKey(senderId)) {
      newMessageCounts[senderId] = newMessageCounts[senderId]! + 1;
    } else {
      newMessageCounts[senderId] = 1;
    }
  }

  Future<void> _onChatConnect(
      ChatConnect event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('id') ?? '';

      final response = await fetchMessage(id, event.id);
      final chatListResponse = ApiResponse<ChatHistory>.fromJson(
          response, (json) => ChatHistory.fromJson(json));
      if (chatListResponse.data == null) {
        emit(ChatError(chatListResponse.message));
        return;
      }
      messages = chatListResponse.data!.messages;
      emit(ChatMessageReceivedState(messages));
    } catch (e) {
      print(e);
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChatSendMessage(
      ChatSendMessage event, Emitter<ChatState> emit) async {
    try {
      print(
          'Sending message:${event.message} with senderId: ${event.senderId} and receiverId: ${event.receiverId}');
      globalSocket!.emit(
          'privateMessage', [event.senderId, event.receiverId, event.message]);
      final message = ChatMessage(
          senderId: event.senderId,
          receiverId: event.receiverId,
          message: event.message,
          fileLink: null,
          id: '',
          groupId: null);
      messages.add(message);
      emit(ChatMessageSent(messages));
    } catch (e) {
      print(e);
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChatMessageReceived(
      ChatMessageReceived event, Emitter<ChatState> emit) async {
    try {
      messages.add(event.message);
      emit(ChatMessageReceivedState(
          List.from(messages))); // Ensure a new list is emitted
    } catch (e) {
      print(e);
      emit(ChatError(e.toString()));
    }
  }

  Future<String> fetchMessage(String senderId, String receiverId) async {
    final url = Uri.parse('${apiroute}chat/getmessages');
    final prefs = await SharedPreferences.getInstance();
    final accesstoken = prefs.getString('accessToken') ?? '';

    final response = await http.post(
      url,
      body: {
        'senderId': senderId,
        'receiverId': receiverId,
      },
      headers: {
        'Authorization': 'Bearer $accesstoken',
      },
    );
    print(response.body);
    return response.body;
  }
}
