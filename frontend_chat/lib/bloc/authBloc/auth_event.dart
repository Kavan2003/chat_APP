part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthLoginEvent extends AuthEvent {
  final String? username;
  final String? email;
  final String password;

  AuthLoginEvent({this.username, this.email, required this.password});
}

final class AuthRegisterEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String yearOfStudy;
  final String branch;
  final List<String> skills;
  final String description;
  final String resume;

  AuthRegisterEvent(
      {required this.username,
      required this.email,
      required this.password,
      required this.yearOfStudy,
      required this.branch,
      required this.skills,
      required this.description,
      required this.resume});
}
