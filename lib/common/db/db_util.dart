import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../util/log_util.dart';
import 'abs_basedb.dart';

class DBUtil {
  /// Delete the table with the given name from the database.
  static Future<void> deleteTable(Database db, String tableName) {
    return db.execute("DROP TABLE '$tableName'");
  }

  ///创建数据库或者得到数据库
  static Future<Database> createOrGet(AbsDb absDb, Database? db, int dbVersion) async {
    if (db == null || !db.isOpen) {
      String dbPath = await absDb.getDbPath();
      File file = File(join(dbPath, absDb.getFileName()));
      bool exists = await file.exists();
      if (!exists) {
        await file.create(recursive: true);
      }
      LogUtil.d("BaseDb", "db path:${file.path}");
      //https://pub.dev/packages/sqflite_common_ffi
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      db = await databaseFactory.openDatabase(file.path,
          options: OpenDatabaseOptions(
            version: dbVersion,
            onCreate: absDb.onCreate,
            onUpgrade: absDb.onUpgrade,
          ));
    }
    return db;
  }

  ///sql: rawQuery > SELECT [column] FROM [tableName] WHERE [column]=[columnValue]
  /// 如果结果不为空，表示数据存在，返回true ，否则返回false
  static Future<bool> columnEquals(
      Database db, String tableName, String column, Object columnValue) async {
    var map = await db.rawQuery("SELECT $column FROM $tableName WHERE $column=$columnValue");
    if (map.isNotEmpty) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  static Future<List<Map<String, Object?>>> selectAll(Database db, String tableName) {
    return db.query(tableName);
  }
}
