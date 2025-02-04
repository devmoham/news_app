import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/utils/app_constants.dart';

class FavoritesServices {
  final localDatabaseHive = LocalDatabaseHive();

  Future<List<Article>> getFavoritesHive() async {
    final favorites = await localDatabaseHive.getData<List<dynamic>?>(
      AppConstants.favoritesKey,
    );

    if (favorites == null) {
      return [];
    }
    return favorites.map((e) => e as Article).toList();
  }
}
