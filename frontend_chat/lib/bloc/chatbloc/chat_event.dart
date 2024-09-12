part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatConnect extends ChatEvent {
  final String id;
  // final String receiverId;

  ChatConnect({
    required this.id,
  });
}

class ChatConnected extends ChatEvent {}

class ChatSendMessage extends ChatEvent {
  final String senderId;
  final String receiverId;
  final String message;

  ChatSendMessage({
    required this.senderId,
    required this.receiverId,
    required this.message,
  });
}

class ChatMessageReceived extends ChatEvent {
  final ChatMessage message;

  ChatMessageReceived(this.message);
}
