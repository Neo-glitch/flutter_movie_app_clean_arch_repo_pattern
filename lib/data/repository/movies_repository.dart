// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_movie_app_clean_arch_repo_pattern/data/database/dao/movies_dao.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/database/database_mapper.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/network/client/api_client.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/network/entity/movie_entity.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/network/network_mapper.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/domain/model/movie.dart';

class MoviesRepository {
  final ApiClient apiClient;
  final NetworkMapper networkMapper;
  final MoviesDao moviesDao;
  final DatabaseMapper databaseMapper;

  MoviesRepository({
    required this.apiClient,
    required this.networkMapper,
    required this.moviesDao,
    required this.databaseMapper,
  });

  Future<List<Movie>> getUpcomingMovies({
    required int limit,
    required int page,
  }) async {
    // try to load the movies from database and if not empty , make request
    // to api to get data and save in db for future calls to db
    final dbEntities =
        await moviesDao.selectAll(limit: limit, offset: (page * limit) - limit);

    if (dbEntities.isNotEmpty) {
      return databaseMapper.toMovies(dbEntities);
    }

    // rather than communicating with apiClient, could just have a datasource to comm with client
    final upcomingMovies =
        await apiClient.getUpcomingMovies(page: page, limit: limit);
    final movies = networkMapper.toMovies(upcomingMovies.results);

    // save movies to db
    moviesDao.insertAll(databaseMapper.toMovieDbEntities(movies));

    return movies;
  }

  /// deletes all movies in db, since current data in db is outdated and we
  /// want to get new data
  Future<void> deleteAll() async {
    moviesDao.deleteAll();
  }

  /// decides when to get new data from api by checking if data in db is not
  /// in sync with remote api
  Future<bool> checkNewData() async {
    final entities = await moviesDao.selectAll(limit: 1);

    if (entities.isEmpty) {
      // no data in db, so fetch from api
      return true;
    }

    final entity = entities.first;
    final movies = await apiClient.getUpcomingMovies(page: 1, limit: 1);

    if (entity.movieId == movies.results.first.id) {
      // db in sync with remote api
      return false;
    } else {
      // db not in sync with remote api
      return true;
    }
  }
}
