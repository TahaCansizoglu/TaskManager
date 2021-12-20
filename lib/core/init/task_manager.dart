import 'package:flutter/material.dart';
import 'package:task_management/core/service/firebase_service.dart';
import '../constants/utils.dart';

import '../database/db.dart';
import '../models/taskmodel.dart';

class TaskManager extends ChangeNotifier {
  List<Task> tasks = <Task>[];
  List<Task> tasksType = <Task>[];

  String name = "";
  TaskManager() {
    getTasks();
  }
  void getTasks() async {
    tasks = await DBHelper.getTasks();

    List<Task> firebaseTasks = [];
    await FirebaseService.firestore
        .collection('Users')
        .doc(FirebaseService.user!.uid)
        .get()
        .then((value) => name = value['name']);

    if (tasks.isEmpty) {
      var querySnapshot = await FirebaseService.getFirebaseData();
      for (var e in querySnapshot.docs) {
        firebaseTasks.add(Task.fromJson(e.data()));
      }
      for (var i = 0; i < firebaseTasks.length; i++) {
        if (tasks.every((item) => item.id != firebaseTasks[i].id)) {
          tasks.add(firebaseTasks[i]);
        }
      }
    }
    for (var element in tasks) {
      element.id = null;
      await DBHelper.insert(element);
    }
    tasksType = [...tasks];
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final id = await DBHelper.insert(task);
    task.id = int.parse(id.toString());
    FirebaseService.firestore
        .collection('Users')
        .doc(FirebaseService.user!.uid)
        .collection('todo')
        .doc()
        .set(task.toJson());
    tasks.add(task);
    notifyListeners();
  }

  void toggleTaskDone(int? id) {
    DBHelper.update(id!);
    getTasks();

    notifyListeners();
  }

  void changeTaskType(String type, List<Task> list) {
    switch (type) {
      case "High":
        tasksType =
            list.where((element) => element.taskPriority == "High").toList();
        break;
      case "low":
        tasksType =
            list.where((element) => element.taskPriority == "Low").toList();
        break;
      case "notcomp":
        tasksType = list.where((element) => element.isCompleted == 0).toList();
        break;
      case "comp":
        tasksType = list.where((element) => element.isCompleted == 1).toList();
        break;

      default:
        tasksType = [...tasks];
    }
    notifyListeners();
  }

  void deleteTask(Task task) {
    DBHelper.delete(task);
    tasks.remove(task);
    getTasks();
    notifyListeners();
  }
}
