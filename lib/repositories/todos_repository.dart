import 'dart:async';

import 'package:badger/models/todo_model.dart';
import 'package:badger/utils/enums.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodosRepository {
  static final TodosRepository singleton = TodosRepository._internal();

  static const String dbName = 'todos.db';
  static const int dbVersion = 1;

  static const String tableName = 'todos';
  static const String colId = "id";
  static const String colTitle = "title";
  static const String colDescription = "description";
  static const String colCompleted = "completed";
  static const String colColor = "color";
  static const String colDate = 'date';

  Database? _database;

  TodosRepository._internal();

  factory TodosRepository() {
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
          CREATE TABLE $tableName(
            $colId INTEGER PRIMARY KEY, 
            $colTitle TEXT, 
            $colDescription TEXT, 
            $colCompleted INTEGER, 
            $colColor TEXT,
            $colDate TEXT
          )
          ''');
    });
  }

  Future<void> insert(TodoModel todo) async {
    final db = await database;

    await db.insert(
      tableName,
      todo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TodoModel>> getAll({Orders order = Orders.desc}) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    var todos = List.generate(maps.length, (i) {
      return TodoModel.fromJson(maps[i]);
    });

    if (order == Orders.desc) {
      return todos.reversed.toList();
    } else {
      return todos;
    }
  }

  Future<void> update(TodoModel todo) async {
    final db = await database;

    await db.update(
      tableName,
      todo.toJson(),
      where: "$colId = ?",
      whereArgs: [todo.id],
    );
  }

  Future<void> delete(TodoModel todo) async {
    final db = await database;

    await db.delete(
      tableName,
      where: "$colId = ?",
      whereArgs: [todo.id],
    );
  }

  Future<int> getLastInsertedId() async {
    final db = await database;

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX(id) FROM $tableName;');

    int? lastInsertedId =
        result.isNotEmpty ? result.first.values.first as int? : null;

    return lastInsertedId ?? 0;
  }

  Future<void> deleteCompletedTodos() async {
    final db = await database;

    await db.delete(
      tableName,
      where: 'completed = ?',
      whereArgs: [true],
    );
  }
}
