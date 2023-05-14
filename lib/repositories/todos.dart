import 'dart:async';

import 'package:notes/models/todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:notes/utils/constants.dart';

class TodosRepository {
  static final TodosRepository _singleton = TodosRepository._internal();

  static const String _dbName = 'todos.db';
  static const int _dbVersion = 1;

  static const String _tableName = 'todos';
  static const String _colId = "id";
  static const String _colTitle = "title";
  static const String _colDescription = "description";
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
            $_colTitle TEXT, 
            $_colDescription TEXT, 
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

  Future<List<Todo>> getAll({Orders order = Orders.desc}) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    var todos = List.generate(maps.length, (i) {
      return Todo.fromJson(maps[i]);
    });

    if (order == Orders.desc) {
      return todos.reversed.toList();
    } else {
      return todos;
    }
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

  Future<int> getLastInsertedId() async {
    final db = await database;

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX(id) FROM $_tableName;');

    int lastInsertedId =
        result.isNotEmpty ? result.first.values.first as int : 0;

    return lastInsertedId;
  }

  Future<void> deleteCompletedTodos() async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'completed = ?',
      whereArgs: [true],
    );
  }
}
