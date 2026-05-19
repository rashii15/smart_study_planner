import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTask(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;

    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  int get totalTasks => _tasks.length;

  int get completedTasks => _tasks.where((t) => t.isCompleted).length;

  int get pendingTasks => _tasks.where((t) => !t.isCompleted).length;
}
