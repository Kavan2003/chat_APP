import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/models/Chatlist_models.dart';
import 'package:frontend_chat/repositories/api_response.dart';
import 'package:frontend_chat/utils/constants.dart';
import 'package:frontend_chat/utils/global.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
part 'chatlist_event.dart';
part 'chatlist_state.dart';

class ChatlistBloc extends Bloc<ChatlistEvent, ChatlistState> {
  ChatlistBloc() : super(ChatlistInitial()) {
    globalSocket!.on('newMessage', (data) {
      print("new message on chatbloclist");
      if (data is String) {
        data = json.decode(data);
      }
      final senderId = data['Owner'];
      // emit(NewMessageNotification(senderId));
      print("senderif from chatlistbloc $senderId");
      add(NewMessageNotification(senderId));
    });

    on<FetchChatList>((event, emit) async {
//http://localhost:8000/api/chat/listchats
      emit(ChatlistLoading());
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
            ? emit(ChatlistLoaded(chatListResponse.data!, newMessageCounts))
            : emit(ChatlistError(chatListResponse.message));
      } catch (error) {
        print('Api Fetch Error on chatlist ${error}');
        emit(ChatlistError('Api Fetch Error on chatlist${error.toString()}'));
      }
    });

    on<NewMessageNotification>((event, emit) {
      print('New message from ${event.senderId}');
      if (newMessageCounts.containsKey(event.senderId)) {
        newMessageCounts[event.senderId] =
            newMessageCounts[event.senderId]! + 1;
      } else {
        newMessageCounts[event.senderId] = 1;
      }
      print("newMessageCounts$newMessageCounts");

      if (state is ChatlistLoaded) {
        final currentState = (state as ChatlistLoaded).chatList;
        emit(
            ChatlistLoading()); // Emit an intermediate state to force UI update
        emit(ChatlistLoaded(currentState, newMessageCounts));
      } else if (state is ChatlistLoading) {
        // Handle the case where the state is ChatlistLoading
        print('State is ChatlistLoading, waiting for it to load');
      } else if (state is ChatlistError) {
        // Handle the case where the state is ChatlistError
        print('State is ChatlistError, current state: $state');
      } else {
        // Handle other states if necessary
        print('State is not ChatlistLoaded, current state: $state');
      }
    });
  }
}
// "Cleta.Glover67-> cba "Ismael_Cruickshank ->abc

/*

after a break may be at 4 or so?
chat rebuild add Project and room chat.
Callender , Profile edit , notifiacation a bell icon  on top of screen showing all callender events (mainly)
auth -> register  , forgot pass 

AI monitoring of content for Job and sell items.
Done mostly
 */