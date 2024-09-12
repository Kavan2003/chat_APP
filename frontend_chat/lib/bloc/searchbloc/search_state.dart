part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}

final class SearchResults extends SearchState {
  final SearchResponse users;
  SearchResults(this.users);
}

final class SearchhHistoryResults extends SearchState {
  final SearchHistoryData history;
  SearchhHistoryResults(this.history);
}
