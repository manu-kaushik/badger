import 'dart:async';

import 'package:notes/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesRepository {
  static final NotesRepository _singleton = NotesRepository._internal();

  static const String _dbName = 'notes.db';
  static const int _dbVersion = 1;

  static const String _tableName = 'notes';
  static const String _colId = 'id';
  static const String _colTitle = 'title';
  static const String _colBody = 'body';

  Database? _database;

  NotesRepository._internal();

  factory NotesRepository() {
    return _singleton;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();

    final String path = join(dbPath, _dbName);

    return await openDatabase(path, version: _dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $_tableName (
            $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_colTitle TEXT,
            $_colBody TEXT
          )
          ''');
    });
  }

  Future<void> insert(Note note) async {
    final db = await database;

    await db.insert(_tableName, note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Note>> getAll() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Note.fromJson(maps[i]);
    });
  }

  Future<void> update(Note note) async {
    final db = await database;

    await db.update(_tableName, note.toJson(),
        where: '$_colId = ?', whereArgs: [note.id]);
  }

  Future<void> delete(Note note) async {
    final db = await database;

    await db.delete(_tableName, where: '$_colId = ?', whereArgs: [note.id]);
  }
}
