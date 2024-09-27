import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:frontend_chat/models/chat_models.dart';
import 'package:frontend_chat/utils/global.dart';
import 'package:meta/meta.dart';

part 'new_message_bloc_event.dart';
part 'new_message_bloc_state.dart';

class NewMessageBloc extends Bloc<NewMessageBlocEvent, NewMessageBlocState> {
  NewMessageBloc() : super(NewMessageBlocInitial()) {
    on<NewMessageBlocEvent>((event, emit) {
      print("new message bloc start");
      globalSocket!.on('newMessage', (data) {
        print("new message on chatbloclist");
        if (data is String) {
          data = json.decode(data);
        }
        print("new message data $data");
        try {
          final message = ChatMessage.fromJson(data);
          emit(NewMessageBlocListLoaded(message));
        } catch (e) {
          print(e.toString());
          emit(NewMessageBlocError(e.toString()));
        }
      });
    });
  }
}
