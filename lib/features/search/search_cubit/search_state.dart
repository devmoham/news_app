part of 'search_cubit.dart';

class SearchState {}

final class SearchInitial extends SearchState {}

final class Searching extends SearchState {}

final class SearchLoaded extends SearchState {
  final List<Article>? articles;
  SearchLoaded({required this.articles});
}

final class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
