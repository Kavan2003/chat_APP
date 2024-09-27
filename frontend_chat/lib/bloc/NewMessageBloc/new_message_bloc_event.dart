part of 'new_message_bloc_bloc.dart';

@immutable
sealed class NewMessageBlocEvent {}

final class NewMessageRecive extends NewMessageBlocEvent {}
