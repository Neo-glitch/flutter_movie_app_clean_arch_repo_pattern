import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/database/dao/movies_dao.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/database/database_mapper.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/network/client/api_client.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/network/network_mapper.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/repository/movies_repository.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/domain/model/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final logPovider = Provider(
  (ref) => Logger(
      printer: PrettyPrinter(), level: kDebugMode ? Level.trace : Level.off),
);

final configProvider = FutureProvider<Config>(
  (ref) async {
    final log = ref.watch(logPovider);
    String raw;

    try {
      raw = await rootBundle.loadString("assets/config/config.json");

      final config = json.decode(raw) as Map<String, dynamic>;

      return Config(
        apiKey: config["apiKey"] as String,
        apiHost: config["apiHost"] as String,
      );
    } catch (e) {
      log.e(
        'Error while loading project configuration, please make sure '
        'that the file located at /assets/config/config.json '
        'exists and that it contains the correct configutation.',
        error: e,
      );

      // throw this exception if error occurs
      rethrow;
    }
  },
);

final apiClientProvider = Provider(
  (ref) {
    final config = ref.watch(configProvider).value;

    if (config == null) {
      throw Exception("Config is not available");
      // return;
    }
    final client = ApiClient(
        baseUrl: "https://moviesdatabase.p.rapidapi.com/",
        apiKey: config.apiKey,
        apiHost: config.apiHost);

    return client;
  },
);

final networkMapperProvider =
    Provider((ref) => NetworkMapper(log: ref.watch(logPovider)));

final moviesDaoProvider = Provider((ref) => MoviesDao());

final databaseMapperProvider =
    Provider((ref) => DatabaseMapper(ref.watch(logPovider)));

final movieRepoProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final networkMapper = ref.watch(networkMapperProvider);
  final moviesDao = ref.watch(moviesDaoProvider);
  final databaseMapper = ref.watch(databaseMapperProvider);

  return MoviesRepository(
      apiClient: apiClient,
      networkMapper: networkMapper,
      moviesDao: moviesDao,
      databaseMapper: databaseMapper);
});
