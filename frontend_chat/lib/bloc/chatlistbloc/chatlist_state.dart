part of 'chatlist_bloc.dart';

@immutable
sealed class ChatlistState {}

final class ChatlistInitial extends ChatlistState {}

final class ChatlistLoading extends ChatlistState {}

final class ChatlistLoaded extends ChatlistState {
  final ChatListResponse chatList;
  final Map<String, int> newMessageCounts;

  ChatlistLoaded(this.chatList, this.newMessageCounts);
}

final class ChatlistError extends ChatlistState {
  final String message;

  ChatlistError(this.message);
}

class NewMessageNotificationState extends ChatlistState {
  final String senderId;
  final int count;

  NewMessageNotificationState(this.senderId, this.count);
}
