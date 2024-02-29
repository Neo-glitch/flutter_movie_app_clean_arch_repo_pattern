import 'package:flutter_movie_app_clean_arch_repo_pattern/data/database/dao/base_dao.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/database/entity/movie_db_entity.dart';
import 'package:sqflite/sqflite.dart';

class MoviesDao extends BaseDao {
  Future<List<MovieDbEntity>> selectAll({int? limit, int? offset}) async {
    final Database db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      BaseDao.moviesTableName,
      limit: limit, // no of rows ret by query
      offset: offset, // start index of query
      orderBy: "${MovieDbEntity.fieldId} ASC",
    );

    return List.generate(
      maps.length,
      (index) {
        return MovieDbEntity.fromJson(maps[index]);
      },
    );
  }

  Future<void> insertAll(List<MovieDbEntity> entities) async {
    final Database db = await getDb();
    await db.transaction(
      (transaction) async {
        for (final entity in entities) {
          transaction.insert(BaseDao.moviesTableName, entity.toJson());
        }
      },
    );
  }

  Future<void> deleteAll() async {
    final db = await getDb();
    await db.delete(BaseDao.moviesTableName);
  }
}
