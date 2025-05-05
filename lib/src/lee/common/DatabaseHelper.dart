import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../model/Song.dart';

class DatabaseHelper {
  // 数据库表名和字段
  final String dbName = 'songs.db';
  final String tableName = 'songs';
  final String id = 'id';
  final String title = 'title';
  final String artist = 'artist';
  final String album = 'album';
  final String imgItems = 'imgItems';
  final String lyrics = 'lyrics';
  final String url = 'url';
  final String year = 'year';
  final String track = 'track';
  final String genre = 'genre';
  final String isFavorite = 'isFavorite';

  static final DatabaseHelper instance = DatabaseHelper._internal();

  factory DatabaseHelper() => DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (Platform.isAndroid) {
      String path = join(await getDatabasesPath(), dbName);
      return await openDatabase(path,
          version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    } else if (Platform.isWindows) {
      var databaseFactory = databaseFactoryFfi;
      return await databaseFactory.openDatabase(inMemoryDatabasePath,
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
          ));
    } else {
      throw Exception('Unsupported platform');
    }
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName(
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
        $title TEXT NOT NULL,
        $artist TEXT,
        $album  TEXT,
        $imgItems TEXT,
        $lyrics TEXT,
        $url TEXT,
        $track TEXT,
        $year CHAR(10),
        $genre INTEGER DEFAULT 0,
        $isFavorite INTEGER DEFAULT 0
      )
    ''');
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 示例：删除旧表并重建（生产环境需谨慎处理数据迁移）
    db.execute('DROP TABLE IF EXISTS $tableName');
    _onCreate(db, newVersion);
  }

  // 查询收藏的歌曲
  Future<List<ProSong>> getFavorites() async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => ProSong.fromJson(maps[i]));
  }

// 模糊搜索标题
  Future<List<ProSong>> searchSongs(String keyword) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'title LIKE ?',
      whereArgs: ['%$keyword%'],
    );
    return List.generate(maps.length, (i) => ProSong.fromJson(maps[i]));
  }

  Future<void> batchInsert(List<ProSong> songs) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var song in songs) {
        await txn.insert(tableName, song.toSqlMap());
      }
    });
  }

  Future<int> addSong(ProSong song) async {
    final db = await database;
    return await db.insert(tableName, song.toSqlMap());
  }

  Future<int> delSong(ProSong song) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [song.id],
    );
  }

  Future<int> upsertSong(ProSong song) async {
    final db = await database;
    if (song.id == null) {
      return await db.insert(tableName, song.toSqlMap());
    } else {
      return await db.update(tableName, song.toSqlMap(),
          where: '$id = ?', whereArgs: [song.id]);
    }
  }

  Future<List<ProSong>> getSongs({bool? favorite}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;
    if (favorite != null) {
      maps = await db.query(tableName,
          where: '$isFavorite = ?', whereArgs: [favorite ? 1 : 0]);
    } else {
      maps = await db.query(tableName);
    }
    return maps.map((e) => ProSong.fromJson(e)).toList();
  }
}
