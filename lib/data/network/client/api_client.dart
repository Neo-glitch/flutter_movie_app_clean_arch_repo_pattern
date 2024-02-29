import 'package:dio/dio.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/network/entity/movie_entity.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/domain/exception/network_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({
    required String baseUrl,
    required String apiKey,
    required String apiHost,
  }) : _dio = Dio()
          ..options.baseUrl = baseUrl
          ..options.headers = {
            "X-RapidAPI-Key": apiKey,
            "X-RapidAPI-Host": apiHost
          }
          ..interceptors.add(
            LogInterceptor(
              requestBody: true,
              responseBody: true,
            ),
          );

  /// this is meant to be in datasource class
  /// gets upcoming movies from api
  /// [page] is page to load
  /// [limit] is the poge size
  Future<UpcomingMovies> getUpcomingMovies({
    required int page,
    int? limit,
  }) async {
    final response = await _dio.get(
      "titles/x/upcoming",
      queryParameters: {"page": page, "limit": limit},
    );

    if (response.statusCode != null && response.statusCode! >= 400) {
      throw NetworkException(
          statusCode: response.statusCode!, message: response.statusMessage);
    } else if (response.statusCode! != null && response.statusCode! == 200) {
      return UpcomingMovies.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception("Unknow Error");
    }
  }
}
