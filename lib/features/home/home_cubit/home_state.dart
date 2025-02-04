part of 'home_cubit.dart';

class HomeState {}

final class HomeInitial extends HomeState {}

final class TopHeadlinesLoading extends HomeState {}

final class TopHeadlinesLoaded extends HomeState {
  final List<Article>? articles;
  TopHeadlinesLoaded(this.articles);
}

final class TopHeadlinesError extends HomeState {
  final String message;
  TopHeadlinesError(this.message);
}


final class RecommendedNewsLoading extends HomeState {}

final class RecommendedNewsLoaded extends HomeState {
  final List<Article>? articles;
  RecommendedNewsLoaded(this.articles);
}

final class RecommendedNewsError extends HomeState {
  final String message;
  RecommendedNewsError(this.message);
}
