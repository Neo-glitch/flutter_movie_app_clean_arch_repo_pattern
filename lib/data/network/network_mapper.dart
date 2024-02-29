// ignore_for_file: public_member_api_docs, sort_constructors_first
// handles mapping from entity to model obj

import 'package:logger/logger.dart';

import 'package:flutter_movie_app_clean_arch_repo_pattern/data/network/entity/movie_entity.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/domain/exception/mapper_exception.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/domain/model/movie.dart';

class NetworkMapper {
  final Logger log;

  NetworkMapper({
    required this.log,
  });

  Movie toMovie(MovieEntity movieEntity) {
    try {
      return Movie(
        id: movieEntity.id,
        title: movieEntity.titleText.text,
        imageUrl: movieEntity.primaryImage?.url,
        releaseDate: DateTime(
          movieEntity.releaseDate.year,
          movieEntity.releaseDate.month,
          movieEntity.releaseDate.day,
        ),
      );
    } catch (e) {
      throw MapperException<MovieEntity, Movie>(e.toString());
    }
  }

  List<Movie> toMovies(List<MovieEntity> entities) {
    final List<Movie> movies = [];

    for (final entity in entities) {
      try {
        movies.add(toMovie(entity));
      } catch (e) {
        log.w("Could not mao entity ${entity.id}", error: e);
      }
    }

    return movies;
  }
}
