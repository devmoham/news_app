import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
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
  int page = 1;
  
  // Add this list to store all recommendation articles
  List<Article> allRecommendationArticles = [];

  // Initialize cubit: check connectivity and fetch data
  void init() {
    _checkConnectivityAndFetch();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.mobile)) {
        _fetchData();
      } else {
        emit(NoInternet());
      }
    });
  }

  // Check connectivity and fetch data if connected
  Future<void> _checkConnectivityAndFetch() async {
    final results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile)) {
      _fetchData();
    } else {
      emit(NoInternet());
    }
  }

  // Fetch top headlines and recommendations
  void _fetchData() {
    getTobHeadlines();
    // Only fetch recommendations if the list is empty
    if (allRecommendationArticles.isEmpty) {
      getRecommendationItems();
    }
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
    // Don't affect recommendations when changing top headlines category
    // The recommendations should stay independent
  }

  Future<void> getTobHeadlines() async {
    emit(TopHeadlinesLoading());
    try {
      final body = TopHeadlinesBody(
          category: selectedCategory == 'general' ? null : selectedCategory,
          page: 1,
          pageSize: 7);
      final result = await homeServices.getTopHeadlines(body);
      emit(TopHeadlinesLoaded(result.articles));
    } catch (e) {
      emit(TopHeadlinesError(e.toString()));
    }
  }

  Future<void> getRecommendationItems({bool fromLoading = false}) async {
    if (fromLoading) {
      emit(RecommendedNewsFromPaginationLoading());
    } else {
      emit(RecommendedNewsLoading());
      // Reset the list and page when loading fresh data
      allRecommendationArticles.clear();
      page = 1;
    }
    
    try {
      final body =
          TopHeadlinesBody(category: 'health', page: page, pageSize: 10);
      final result = await homeServices.getTopHeadlines(body);

      final articles = result.articles ?? [];
      
      // Only increment page if we got articles and it's not a duplicate fetch
      if (articles.isNotEmpty) {
        // Filter out duplicate articles to prevent repetition
        final newArticles = articles.where((newArticle) {
          return !allRecommendationArticles.any((existingArticle) => 
            existingArticle.title == newArticle.title || 
            existingArticle.url == newArticle.url
          );
        }).toList();
        
        if (newArticles.isNotEmpty) {
          page++;
          
          final favArticles = await _getFavorites();

          // Process articles to mark favorites
          for (int i = 0; i < newArticles.length; i++) {
            var article = newArticles[i];
            final isFound =
                favArticles.any((element) => element.title == article.title);
            if (isFound) {
              article = article.copyWith(isFavorite: true);
              newArticles[i] = article;
            }
          }
          
          // Add new articles to the existing list
          allRecommendationArticles.addAll(newArticles);
        }
      }
      
      // Emit the complete list of articles
      emit(RecommendedNewsLoaded(List.from(allRecommendationArticles)));
      
    } on DioException catch (e) {
      if (fromLoading) {
        emit(RecommendedNewsFromPaginationFailed(e.response!.data['message']));
        Future.delayed(const Duration(seconds: 1));
        emit(RecommendedNewsInitial());
      } else {
        emit(RecommendedNewsError(e.toString()));
      }
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

  // Add method to refresh recommendations (pull to refresh)
  Future<void> refreshRecommendations() async {
    allRecommendationArticles.clear();
    page = 1;
    await getRecommendationItems();
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