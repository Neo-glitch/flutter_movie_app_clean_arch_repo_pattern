import 'package:flutter/foundation.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/database/entity/movie_db_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// data source that connects to data base
/// and from which other dao object will inherit from
/// class is abstract to having multi instances of this
abstract class BaseDao {
  static const databaseVersion = 1;
  static const _databaseName = "com.my.app.db";
  static const moviesTableName = "movies";

  Database? _database;

  @protected
  Future<Database> getDb() async {
    _database ??= await _getDatabase();
    return _database!;
  }

  Future<Database> _getDatabase() async {
    return openDatabase(join(await getDatabasesPath(), _databaseName),
        onCreate: (db, version) async {
      final batch = db.batch();
      _createMoviesTablev1(batch);
      await batch.commit();
    }, version: databaseVersion);
  }

  void _createMoviesTablev1(Batch batch) {
    // batch is used to exec queries efficiently in a sequence
    batch.execute('''
      CREATE TABLE $moviesTableName(
        ${MovieDbEntity.fieldId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${MovieDbEntity.fieldMovieId} TEXT NOT NULL,
        ${MovieDbEntity.fieldTitle} TEXT NOT NULL,
        ${MovieDbEntity.fieldImageUrl} TEXT NULL,
        ${MovieDbEntity.fieldReleaseDate} INTEGER NOT NULL
      );
      ''');
  }
}
