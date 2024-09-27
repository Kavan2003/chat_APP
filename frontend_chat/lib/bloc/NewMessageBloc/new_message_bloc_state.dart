part of 'new_message_bloc_bloc.dart';

@immutable
sealed class NewMessageBlocState {}

final class NewMessageBlocInitial extends NewMessageBlocState {}

final class NewMessageBlocLoading extends NewMessageBlocState {}

final class NewMessageBlocError extends NewMessageBlocState {
  final String message;

  NewMessageBlocError(this.message);
}

final class NewMessageBlocListLoaded extends NewMessageBlocState {
  final ChatMessage chat;

  NewMessageBlocListLoaded(this.chat);
}
