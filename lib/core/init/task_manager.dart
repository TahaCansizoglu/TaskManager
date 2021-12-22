import 'package:flutter/material.dart';
import '../service/firebase_service.dart';
import '../constants/utils.dart';

import '../database/db.dart';
import '../models/taskmodel.dart';

class TaskManager extends ChangeNotifier {
  List<Task> tasks = <Task>[];
  List<Task> tasksType = <Task>[];
  Map<String, int> countList = {};
  int listLength = 0;
  bool isFill = true;
  TaskManager() {
    getTasks();
  }
  void getTasks() async {
    bool isFirebase = false;
    await FirebaseService.getName();
    tasks = await DBHelper.getTasks()
        .whenComplete(() => {tasks.isEmpty ? isFill = false : isFill = true});

    print(tasks.length);
    List<Task> firebaseTasks = [];

    if (tasks.isEmpty && !isFill) {
      var querySnapshot = await FirebaseService.getFirebaseData();
      for (var e in querySnapshot.docs) {
        firebaseTasks.add(Task.fromJson(e.data()));
      }
      for (var i = 0; i < firebaseTasks.length; i++) {
        if (tasks.every((item) => item.id != firebaseTasks[i].id)) {
          firebaseTasks[i].id = null;
          addTask(firebaseTasks[i], "DB");
        }
      }
    }

    tasksType = [...tasks];
    notifyListeners();
  }

  Future<void> addTask(Task task, var type) async {
    final id = await DBHelper.insert(task);
    task.id = id;
    if (type == "FB") {
      FirebaseService.addTaskFirebase(task);
    }
    if (type == "DB") {
      await FirebaseService.updateField(task, "id", task.id);
    }
    tasks.add(task);
    tasksType = [...tasks];
    notifyListeners();
  }

  void toggleTaskDone(int? id) {
    DBHelper.update(id!);
    getTasks();
    notifyListeners();
  }

  Future<void> getListLength(List<Task> list) async {
    if (list.isNotEmpty) {
      countList["High"] = priorityLenght(list, "High");
      countList["Low"] = priorityLenght(list, "Low");
      countList["0"] = completedLenght(list, 0);
      countList["1"] = completedLenght(list, 1);
      countList["All"] = list.length;
    } else {
      countList["High"] = 0;
      countList["Low"] = 0;
      countList["0"] = 0;
      countList["1"] = 0;
      countList["All"] = 0;
    }
    notifyListeners();
  }

  priorityLenght(List<Task> dbTasks, String type) =>
      dbTasks.where((element) => element.taskPriority == type).toList().length;
  completedLenght(List<Task> dbTasks, int type) =>
      dbTasks.where((element) => element.isCompleted == type).toList().length;
  void changeTaskType(var type, List<Task> list) {
    switch (type) {
      case "High":
        tasksType =
            tasks.where((element) => element.taskPriority == "High").toList();
        break;
      case "Low":
        tasksType =
            tasks.where((element) => element.taskPriority == "Low").toList();
        break;
      case 0:
        tasksType = tasks.where((element) => element.isCompleted == 0).toList();
        break;
      case 1:
        tasksType = tasks.where((element) => element.isCompleted == 1).toList();
        break;
      case "All":
        tasksType = [...tasks];
        break;
      default:
        tasksType = [...tasks];
    }
    notifyListeners();
  }

  void deleteAllTask() {
    tasks = [];
    print(tasks);
    notifyListeners();
  }

  void deleteTask(Task task) {
    DBHelper.delete(task);
    tasks.remove(task);
    getTasks();
    notifyListeners();
  }
}
