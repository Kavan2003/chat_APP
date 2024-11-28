part of 'chats_bloc.dart';

@immutable
sealed class ChatsState {}

final class ChatsInitial extends ChatsState {}

final class ChatsLoading extends ChatsState {}

final class ChatsError extends ChatsState {
  final String message;

  ChatsError(this.message);
}

final class ChatsListLoaded extends ChatsState {
  final ChatListResponse chatList;
  final Map<String, int> newMessageCounts;

  ChatsListLoaded(this.chatList, this.newMessageCounts);
}

final class NewMessageNotificationState extends ChatsState {}

final class ChatMessages extends ChatsState {
  final List<ChatMessage> messages;

  ChatMessages(this.messages);
}

final class Status extends ChatsState {
  final RequestStatusModel status;

  Status(this.status);
}
