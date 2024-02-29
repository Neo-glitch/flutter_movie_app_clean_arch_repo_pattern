// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_movie_app_clean_arch_repo_pattern/domain/model/movie.dart';
import 'package:logger/logger.dart';

import 'package:flutter_movie_app_clean_arch_repo_pattern/data/repository/movies_repository.dart';

/// This class is used to manage the state of the movieLists screen
/// could have done this in a stateNotifier class
class MoviesListModel {
  final Logger log;
  final MoviesRepository moviesRepo;
  MoviesListModel({
    required this.log,
    required this.moviesRepo,
  });

  Future<List<Movie>> fetchPage(int page) async {
    try {
      return await moviesRepo.getUpcomingMovies(limit: 10, page: page);
    } catch (e) {
      log.e("Error when fetching page $page", error: e);
      rethrow;
    }
  }

  Future<void> deletePersistedMovies() async {
    try {
      await moviesRepo.deleteAll();
    } catch (e) {
      log.e("Error when deleting movies", error: e);
      rethrow;
    }
  }

  Future<bool> hasNewData() async {
    try {
      return await moviesRepo.checkNewData();
    } catch (e) {
      log.e('Error when checking for new data', error: e);
      return true;
    }
  }
}
