part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

final class SearchUser extends SearchEvent {
  final String query;

  SearchUser(this.query);
}

final class SearchEmpty extends SearchEvent {}
