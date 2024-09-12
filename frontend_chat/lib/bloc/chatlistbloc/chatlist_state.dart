part of 'chatlist_bloc.dart';

@immutable
sealed class ChatlistState {}

final class ChatlistInitial extends ChatlistState {}

final class ChatlistLoading extends ChatlistState {}

final class ChatlistLoaded extends ChatlistState {
  final ChatListResponse chatList;

  ChatlistLoaded(this.chatList);
}

final class ChatlistError extends ChatlistState {
  final String message;

  ChatlistError(this.message);
}
