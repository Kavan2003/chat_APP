part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}

class ChatMessageSent extends ChatState {
  final List<ChatMessage> messages;

  ChatMessageSent(this.messages);
}

class ChatMessageReceivedState extends ChatState {
  final List<ChatMessage> messages;

  ChatMessageReceivedState(this.messages);
}
