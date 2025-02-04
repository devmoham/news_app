import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/utils/app_constants.dart';

part 'favorite_actions_state.dart';

class FavoriteActionsCubit extends Cubit<FavoriteActionsState> {
  FavoriteActionsCubit._internal() : super(FavoriteActionsInitial());

  static final FavoriteActionsCubit _instance =
      FavoriteActionsCubit._internal();

  factory FavoriteActionsCubit() => _instance;

  final localDatabaseHive = LocalDatabaseHive();

  Future<void> setFavorite(Article article) async {
    emit(DoingFavorite(article.title ?? ''));
    try {
      final favArticles = await _getFavorites();
      final isFound =
          favArticles.any((element) => element.title == article.title);
      if (isFound) {
        final index =
            favArticles.indexWhere((element) => element.title == article.title);
        favArticles.remove(favArticles[index]);

        await localDatabaseHive.saveData<List<Article>>(
          AppConstants.favoritesKey,
          favArticles,
        );
        emit(FavoriteRemoved(article.title ?? ''));
      } else {
        favArticles.add(article);

        await localDatabaseHive.saveData<List<Article>>(
          AppConstants.favoritesKey,
          favArticles,
        );
        emit(FavoriteAdded(article.title ?? ''));
      }
     
    } catch (e) {
      emit(DoingFavoriteError(e.toString(), article.title ?? ''));
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
}
