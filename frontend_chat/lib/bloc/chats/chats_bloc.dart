import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:frontend_chat/models/Chatlist_models.dart';
import 'package:frontend_chat/models/chat_models.dart';
import 'package:frontend_chat/models/request_status_model.dart';
import 'package:frontend_chat/repositories/api_response.dart';
import 'package:frontend_chat/utils/constants.dart';
import 'package:frontend_chat/utils/global.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  List<ChatMessage> messages = [];
  ChatsBloc() : super(ChatsInitial()) {
    print("new message bloc start");
    globalSocket!.on(
      "sentMessage",
      (data) {
        if (data is String) {
          data = json.decode(data);
        }
        final message = ChatMessage.fromJson(data);
        messages.add(message);
        add(Messages(messages));
        for (var i = 0; i < messages.length; i++) {
          print(messages[i].message);
        }
      },
    );
    globalSocket!.on('newMessage', (data) {
      if (data is String) {
        data = json.decode(data);
      }
      final message = ChatMessage.fromJson(data);
      if (state is ChatMessages) {
        messages.add(message);
        add(Messages(messages));
      } else {
        print("new message $message");
        if (newMessageCounts.containsKey(message.senderId)) {
          newMessageCounts[message.senderId] =
              newMessageCounts[message.senderId]! + 1;
        } else {
          newMessageCounts[message.senderId] = 1;
        }
        print("new message counts $newMessageCounts");
        add(RefreshChatsList());
      }
    });
    globalSocket!.on("chatRequest", (data) {
      if (data is String) {
        data = json.decode(data..toString());
      }
      print(data);
      add(ChatConnected(data['fromUserId']));
    });
    globalSocket!.on("declineChatRequest", (data) {
      if (data is String) {
        data = json.decode(data);
      }
      print("declineChatRequest" + data.toString());
      add(ChatConnected(data['toUserId']));
    });
    globalSocket!.on("chatRequestAccepted", (data) {
      if (data is String) {
        data = json.decode(data);
      }
      print("chatRequestAccepted" + data.toString());
      add(ChatConnected(data['toUserId']));
    });

    on<FetchChatsList>((event, emit) async {
      emit(ChatsLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final accesstoken = prefs.getString('accessToken') ?? '';

        final url = Uri.parse('${apiroute}chat/listchats');

        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $accesstoken',
            'ngrok-skip-browser-warning': 'ngrok-skip-browser-warning'
          },
        );
        print(response.body);

        final chatListResponse = ApiResponse<ChatListResponse>.fromJson(
            response.body, (json) => ChatListResponse.fromJson(json));
        chatListResponse.status == "true"
            ? {
                globalchatList = chatListResponse.data!,
                emit(ChatsListLoaded(chatListResponse.data!, newMessageCounts))
              }
            : emit(ChatsError(chatListResponse.message));
      } catch (error) {
        print('Api Fetch Error on chatlist $error');
        emit(ChatsError('Api Fetch Error on chatlist${error.toString()}'));
      }
    });

    on<RefreshChatsList>(
      (event, emit) {
        print("new message counts $newMessageCounts");
        emit(ChatsLoading());
        emit(ChatsListLoaded(globalchatList!, newMessageCounts));
      },
    );

    on<Messages>(
      (event, emit) {
        emit(ChatsLoading());
        emit(ChatMessages(event.messages));
      },
    );

    on<SendRequest>(
      (event, emit) {
        globalSocket!.emit("sendChatRequest", {
          "fromUserId": event.senderId,
          "toUserId": event.receiverId,
        });

        emit(Status(RequestStatusModel(canAccept: false, status: "pending")));
      },
    );

    on<AcceptRequest>(
      (event, emit) {
        globalSocket!.emit("acceptChatRequest", {
          "fromUserId": event.senderId,
          "toUserId": event.receiverId,
        });

        add(ChatConnected(event.receiverId));
      },
    );
    on<RejectRequest>(
      (event, emit) {
        globalSocket!.emit("declineChatRequest", {
          "fromUserId": event.senderId,
          "toUserId": event.receiverId,
        });

        emit(Status(RequestStatusModel(canAccept: false, status: "decline")));
      },
    );

    on<ChatConnected>(
      (event, emit) async {
        print("Chat connected with id: ${event.id}");
        emit(ChatsLoading());
        try {
          final prefs = await SharedPreferences.getInstance();
          final id = prefs.getString('id') ?? '';
          final accesstoken = prefs.getString('accessToken') ?? '';

          // Check status
          final statusUrl =
              Uri.parse('${apiroute}chat/statusrequest?id=${event.id}');
          final statusResponse = await http.get(
            statusUrl,
            headers: {
              'ngrok-skip-browser-warning': 'ngrok-skip-browser-warning',
              'Authorization': 'Bearer $accesstoken',
            },
          );

          print(statusResponse.body);
          final decodresponse = ApiResponse<RequestStatusModel>.fromJson(
              statusResponse.body, (json) => RequestStatusModel.fromJson(json));

          if (decodresponse.data?.status != "accepted") {
            emit(Status(decodresponse.data!));
            return;
          }

          final response = await fetchMessage(id, event.id);
          final chatListResponse = ApiResponse<ChatHistory>.fromJson(
              response, (json) => ChatHistory.fromJson(json));
          if (chatListResponse.data == null) {
            emit(ChatsError(chatListResponse.message));
            return;
          }
          messages = chatListResponse.data!.messages;
          emit(ChatMessages(messages));
        } catch (e) {
          print(e);
          emit(ChatsError(e.toString()));
        }
      },
    );

    on<ChatSendMessage>(
      (event, emit) {
        globalSocket!.emit('privateMessage',
            [event.senderId, event.receiverId, event.message]);
      },
    );
  }

  Future<String> fetchMessage(String senderId, String receiverId) async {
    final url = Uri.parse('${apiroute}chat/getmessages');
    final prefs = await SharedPreferences.getInstance();
    final accesstoken = prefs.getString('accessToken') ?? '';

    final response = await http.post(
      url,
      body: jsonEncode({
        'ownerId': senderId,
        'SrnderId': receiverId,
      }),
      headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'ngrok-skip-browser-warning',
        'Authorization': 'Bearer $accesstoken',
      },
    );
    print(response.body);
    return response.body;
  }
}
