part of 'profile_screen_bloc.dart';

@immutable
sealed class ProfileScreenState {}

final class ProfileScreenInitial extends ProfileScreenState {}

final class ProfileScreenLoading extends ProfileScreenState {}

final class ProfileScreenSuccess extends ProfileScreenState {
  final UserModel user;
  ProfileScreenSuccess(this.user);
}

final class ProfileScreenError extends ProfileScreenState {
  final String message;
  ProfileScreenError(this.message);
}
