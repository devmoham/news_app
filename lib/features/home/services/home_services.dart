import 'package:dio/dio.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/home/models/top_headlines_body.dart';

class HomeServices {
  final aDio = Dio();
  Future<NewsApiResponse> getTopHeadlines(TopHeadlinesBody body) async {
    try {
      aDio.options.baseUrl = AppConstants.baseUrl;
      final headers = {"Authorization": "Bearer ${AppConstants.apiKey}"};
      final result = await aDio.get(AppConstants.topHeadlines,
          queryParameters: body.toMap(), options: Options(headers: headers));
      if (result.statusCode == 200) {
        return NewsApiResponse.fromJson(result.data);
      } else {
        throw Exception(result.statusMessage);
      }
    } catch (e) {
      rethrow;
    }
  }
}
