import 'dart:async';

import 'package:badger/models/exports.dart';
import 'package:badger/utils/exports.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesRepository {
  static final NotesRepository singleton = NotesRepository._internal();

  static const String dbName = 'notes.db';
  static const int dbVersion = 1;

  static const String tableName = 'notes';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colBody = 'body';
  static const String colDate = 'date';

  Database? _database;

  NotesRepository._internal();

  factory NotesRepository() {
    return singleton;
  }

  Future<Database> get database async {
    _database ??= await initDatabase();

    return _database!;
  }

  Future<Database> initDatabase() async {
    final String dbPath = await getDatabasesPath();

    final String path = join(dbPath, dbName);

    return await openDatabase(path, version: dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $tableName (
            $colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $colTitle TEXT,
            $colBody TEXT,
            $colDate TEXT
          )
          ''');
    });
  }

  Future<void> insert(NoteModel note) async {
    final db = await database;

    await db.insert(tableName, note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NoteModel>> getAll({Orders order = Orders.desc}) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    var notes = List.generate(maps.length, (i) {
      return NoteModel.fromJson(maps[i]);
    });

    if (order == Orders.desc) {
      return notes.reversed.toList();
    } else {
      return notes;
    }
  }

  Future<void> update(NoteModel note) async {
    final db = await database;

    await db.update(tableName, note.toJson(),
        where: '$colId = ?', whereArgs: [note.id]);
  }

  Future<void> delete(NoteModel note) async {
    final db = await database;

    await db.delete(tableName, where: '$colId = ?', whereArgs: [note.id]);
  }

  Future<int> getLastInsertedId() async {
    final db = await database;

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX(id) FROM $tableName;');

    int? lastInsertedId =
        result.isNotEmpty ? result.first.values.first as int? : null;

    return lastInsertedId ?? 0;
  }
}
