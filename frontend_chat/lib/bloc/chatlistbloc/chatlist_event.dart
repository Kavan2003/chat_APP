part of 'chatlist_bloc.dart';

@immutable
sealed class ChatlistEvent {}

final class FetchChatList extends ChatlistEvent {}

final class RefreshChatList extends ChatlistEvent {}
