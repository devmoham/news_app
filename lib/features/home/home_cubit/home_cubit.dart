import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/home/models/top_headlines_body.dart';
import 'package:news_app/features/home/services/home_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final homeServices = HomeServices();
  final localDatabaseHive = LocalDatabaseHive();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;


  // Initialize cubit: check connectivity and fetch data
  void init() {
    _checkConnectivityAndFetch();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.wifi) || results.contains(ConnectivityResult.mobile)) {
        _fetchData();
      } else {
        emit(NoInternet());
      }
    });
  }

  // Check connectivity and fetch data if connected
  Future<void> _checkConnectivityAndFetch() async {
    final results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.wifi) || results.contains(ConnectivityResult.mobile)) {
      _fetchData();
    } else {
      emit(NoInternet());
    }
  }

  // Fetch top headlines and recommendations
  void _fetchData() {
    getTobHeadlines();
    getRecommendationItems();
  }






  String selectedCategory = 'general';
  final List<String> categories = [
    'general',
    'business',
    'sports',
    'entertainment',
    'health',
    'technology',
    'science'
  ];

  void selectCategory(String category) {
    selectedCategory = category;
    getTobHeadlines(); // Fetch news based on new category
  }

  Future<void> getTobHeadlines() async {
    emit(TopHeadlinesLoading());
    try {
      final body = TopHeadlinesBody(
          category: selectedCategory == 'all' ? null : selectedCategory,
          page: 1,
          pageSize: 7);
      final result = await homeServices.getTopHeadlines(body);
      emit(TopHeadlinesLoaded(result.articles));
    } catch (e) {
      emit(TopHeadlinesError(e.toString()));
    }
  }

  Future<void> getRecommendationItems() async {
    emit(RecommendedNewsLoading());
    try {
      final body =
          TopHeadlinesBody(category: 'business', page: 1, pageSize: 15);
      final result = await homeServices.getTopHeadlines(body);
      final articles = result.articles ?? [];
      final favArticles = await _getFavorites();

      for (int i = 0; i < articles.length; i++) {
        var article = articles[i];
        final isFound =
            favArticles.any((element) => element.title == article.title);
        if (isFound) {
          article = article.copyWith(isFavorite: true);
          articles[i] = article;
        }
      }
      emit(RecommendedNewsLoaded(articles));
    } catch (e) {
      emit(RecommendedNewsError(e.toString()));
    }
  }

  Future<List<Article>> _getFavorites() async {
    final favorites = await localDatabaseHive.getData<List<dynamic>?>(
      AppConstants.favoritesKey,
    );

    if (favorites == null) {
      return [];
    }

    return favorites.map((e) => e as Article).toList();
  }



  // Retry fetching data
  void retry() {
    _checkConnectivityAndFetch();
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }



}
