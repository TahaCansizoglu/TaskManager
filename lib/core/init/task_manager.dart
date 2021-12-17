import 'package:flutter/material.dart';
import '../constants/utils.dart';

import '../database/db.dart';
import '../models/taskmodel.dart';

class TaskManager extends ChangeNotifier {
  List<Task> tasks = <Task>[];
  TaskManager() {
    getTasks();
  }
  void getTasks() async {
    tasks = await DBHelper.getTasks();

    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final id = await DBHelper.insert(task);
    task.id = int.parse(id.toString());
    firestore
        .collection('Users')
        .doc("${user!.uid}")
        .collection('todo')
        .doc()
        .set(task.toJson());
    tasks.add(task);
    notifyListeners();
  }

  void toggleTaskDone(int? id) {
    DBHelper.update(id!);
    getTasks();
  }

  void deleteTask(Task task) {
    DBHelper.delete(task);
    tasks.remove(task);
    getTasks();
  }
}
