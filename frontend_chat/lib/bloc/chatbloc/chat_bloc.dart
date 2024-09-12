import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:frontend_chat/repositories/api_response.dart';
import 'package:frontend_chat/utils/constants.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import '../../models/chat_models.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late IO.Socket socket;
  List<ChatMessage> messages = [];

  ChatBloc() : super(ChatInitial()) {
    socket = IO.io(websocket, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.on('connect', (_) {
      add(ChatConnected());
    });

    socket.on('newMessage', (data) {
      print(data);
      if (data is String) {
        data = json.decode(data);
      }
      add(ChatMessageReceived(ChatMessage.fromJson(data)));
    });
    // http://localhost:8000/api/chat/getmessages
    // http req
    // get messages

    on<ChatEvent>((event, emit) async {
      if (event is ChatConnect) {
        try {
          print('Connecting to socket');
          socket.connect();
          final prefs = await SharedPreferences.getInstance();
          final id = prefs.getString('id') ?? '';
          // registerUser
          socket.emit('registerUser', id);
          socket.emit('registerUserAck');
          fetchMessage(id, event.id);
        } catch (e) {
          print(e);
          emit(ChatError(e.toString()));
        }
      } else if (event is ChatSendMessage) {
        try {
          print(
              'Sending message:${event.message} with senderId: ${event.senderId} and receiverId: ${event.receiverId}');
          socket.emit('privateMessage',
              [event.senderId, event.receiverId, event.message]);
          messages.add(ChatMessage(
            senderId: event.senderId,
            receiverId: event.receiverId,
            message: event.message,
          ));
          emit(ChatMessageSent(messages));
        } catch (e) {
          print(e);
          emit(ChatError(e.toString()));
        }
      } else if (event is ChatMessageReceived) {
        try {
          messages.add(event.message);
          emit(ChatMessageReceivedState(messages));
        } catch (e) {
          print(e);
          emit(ChatError(e.toString()));
        }
      }
    });
  }
}

fetchMessage(senderid, reciverid) async {
  final url = Uri.parse('${apiroute}chat/getmessages');
  final prefs = await SharedPreferences.getInstance();
  final accesstoken = prefs.getString('accessToken') ?? '';

  final response = await http.post(
    url,
    body: {
      'senderId': senderid,
      'receiverId': reciverid,
    },
    headers: {
      'Authorization': 'Bearer $accesstoken',
    },
  );
  print(response.body);
  // final chatListResponse = ApiResponse<List<ChatMessage>>.fromJson(
  // response.body, (json) => ChatMessage.fromJson(json));
}
