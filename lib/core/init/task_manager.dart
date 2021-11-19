import 'package:flutter/material.dart';

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

  void addTask(Task task) {
    DBHelper.insert(task);
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
