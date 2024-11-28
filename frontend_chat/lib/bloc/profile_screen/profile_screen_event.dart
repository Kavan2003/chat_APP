part of 'profile_screen_bloc.dart';

@immutable
sealed class ProfileScreenEvent {}

final class FetchUserProfile extends ProfileScreenEvent {
  FetchUserProfile();
}

final class UpdateUserProfile extends ProfileScreenEvent {
  final UserModel user;
  UpdateUserProfile(this.user);
}

final class ChangeUserPassword extends ProfileScreenEvent {
  final String oldPassword;
  final String newPassword;
  ChangeUserPassword(this.oldPassword, this.newPassword);
}

final class AddUserAvatar extends ProfileScreenEvent {
  final String avatarPath;
  AddUserAvatar(this.avatarPath);
}
