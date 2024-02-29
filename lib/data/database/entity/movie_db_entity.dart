// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part "movie_db_entity.g.dart";

@JsonSerializable()
class MovieDbEntity {
  // keeps track of each row in db which is autoIncremented, which is managed by the app
  static const fieldId = "movie_id";
  static const fieldMovieId = "movie_movie_id";
  static const fieldTitle = "movie_title";
  static const fieldImageUrl = "movie_image_url";
  static const fieldReleaseDate = "movie_release_date";

  @JsonKey(name: fieldId)
  final int? id;
  @JsonKey(name: fieldMovieId)
  final String movieId;
  @JsonKey(name: fieldTitle)
  final String movieTitle;
  @JsonKey(name: fieldImageUrl)
  final String? imageUrl;
  @JsonKey(name: fieldReleaseDate)
  final int
      releaseDate; // timestamp of release date since can't store Date directly

  MovieDbEntity({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    this.imageUrl,
    required this.releaseDate,
  });

  factory MovieDbEntity.fromJson(Map<String, dynamic> json) =>
      _$MovieDbEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDbEntityToJson(this);
}
