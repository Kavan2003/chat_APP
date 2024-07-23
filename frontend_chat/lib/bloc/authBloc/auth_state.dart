part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthSuccessState extends AuthState {
  final UserModel user;

  AuthSuccessState(this.user);
}

final class AuthFailedState extends AuthState {
  final String message;
  final String status;

  AuthFailedState(this.message, this.status);
}
