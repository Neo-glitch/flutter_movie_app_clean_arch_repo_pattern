import 'package:flutter_movie_app_clean_arch_repo_pattern/data/database/entity/movie_db_entity.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/domain/exception/mapper_exception.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/domain/model/movie.dart';
import 'package:logger/logger.dart';

/// handles converting db entities to model classes and vice versa
class DatabaseMapper {
  final Logger log;

  DatabaseMapper(this.log);

  Movie toMovie(MovieDbEntity entity) {
    try {
      return Movie(
        id: entity.movieId,
        title: entity.movieTitle,
        imageUrl: entity.imageUrl,
        releaseDate: DateTime.fromMillisecondsSinceEpoch(entity.releaseDate),
      );
    } catch (e) {
      throw MapperException<MovieDbEntity, Movie>(e.toString());
    }
  }

  List<Movie> toMovies(List<MovieDbEntity> entities) {
    final List<Movie> movies = [];

    for (final entity in entities) {
      try {
        movies.add(toMovie(entity));
      } catch (e) {
        log.w("Could not map entity ${entity.movieId}", error: e);
      }
    }
    return movies;
  }

  MovieDbEntity toMovieDbEntity(Movie movie) {
    try {
      return MovieDbEntity(
          // id is null sice want to auto_gen in db
          id: null,
          movieId: movie.id,
          movieTitle: movie.title,
          imageUrl: movie.imageUrl,
          releaseDate: movie.releaseDate.millisecondsSinceEpoch);
    } catch (e) {
      throw MapperException<Movie, MovieDbEntity>(e.toString());
    }
  }

  List<MovieDbEntity> toMovieDbEntities(List<Movie> movies) {
    final List<MovieDbEntity> entities = [];

    for (final movie in movies) {
      try {
        entities.add(toMovieDbEntity(movie));
      } catch (e) {
        log.w("Could not map movie ${movie.id}", error: e);
      }
    }
    return entities;
  }
}
