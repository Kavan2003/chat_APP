part of 'chats_bloc.dart';

@immutable
sealed class ChatsEvent {}

final class FetchChatsList extends ChatsEvent {}

final class RefreshChatsList extends ChatsEvent {}

final class NewMessageNotification extends ChatsEvent {
  final String senderId;

  NewMessageNotification(this.senderId);
}

final class ChatConnected extends ChatsEvent {
  final String id;

  ChatConnected(this.id);
}

final class Messages extends ChatsEvent {
  final List<ChatMessage> messages;
  Messages(this.messages);
}

final class ChatSendMessage extends ChatsEvent {
  final String senderId;
  final String receiverId;
  final String message;

  ChatSendMessage(this.senderId, this.receiverId, this.message);
}
