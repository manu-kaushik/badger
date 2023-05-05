import 'dart:async';

import 'package:notes/models/todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodosRepository {
  static final TodosRepository _singleton = TodosRepository._internal();

  static const String _dbName = 'todos.db';
  static const int _dbVersion = 1;

  static const String _tableName = 'todos';
  static const String _colId = "id";
  static const String _colText = "text";
  static const String _colCompleted = "completed";
  static const String _colColor = "color";

  Database? _database;

  TodosRepository._internal();

  factory TodosRepository() {
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
          CREATE TABLE $_tableName(
            $_colId INTEGER PRIMARY KEY, 
            $_colText TEXT, 
            $_colCompleted INTEGER, 
            $_colColor TEXT
          )
          ''');
    });
  }

  Future<void> insert(Todo todo) async {
    final db = await database;

    await db.insert(
      _tableName,
      todo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Todo>> getAll() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Todo.fromJson(maps[i]);
    });
  }

  Future<void> update(Todo todo) async {
    final db = await database;

    await db.update(
      _tableName,
      todo.toJson(),
      where: "$_colId = ?",
      whereArgs: [todo.id],
    );
  }

  Future<void> delete(Todo todo) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: "$_colId = ?",
      whereArgs: [todo.id],
    );
  }
}
