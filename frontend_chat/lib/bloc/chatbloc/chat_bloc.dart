import 'package:bloc/bloc.dart';
import 'package:frontend_chat/utils/constants.dart';
import 'package:meta/meta.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
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
      add(ChatMessageReceived(ChatMessage.fromJson(data)));
    });

    on<ChatEvent>((event, emit) async {
      if (event is ChatConnect) {
        try {
          socket.connect();
        } catch (e) {
          print(e);
          emit(ChatError(e.toString()));
        }
      } else if (event is ChatSendMessage) {
        try {
          socket.emit('privateMessage', {
            'senderId': event.senderId,
            'receiverId': event.receiverId,
            'message': event.message,
          });
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
