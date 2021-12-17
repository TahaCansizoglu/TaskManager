import 'package:sqflite/sqflite.dart';

import '../models/taskmodel.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';
  static String _path = "";
  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, note TEXT, date STRING, startTime STRING, endTime STRING, isCompleted INTEGER, backgroundColor STRING, taskType STRING)",
          );
        },
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  static Future<List<Task>> getTasks() async {
    List<Map<String, dynamic>> tasks = await _db!.query('tasks');
    return tasks.map((data) => Task.fromJson(data)).toList();
  }

  static Future<int> insert(Task task) async {
    return await _db!.insert(_tableName, task.toJson());
  }

  static Future<void> deleteDb() async {
    await deleteDatabase(_path);
  }

  static Future<int> delete(Task task) async =>
      await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static Future<int> update(int id) async {
    return await _db!.rawUpdate(
        ''' UPDATE tasks SET isCompleted = ? WHERE id = ? ''', [1, id]);
  }
}
