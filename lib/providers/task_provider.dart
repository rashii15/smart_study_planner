import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  final List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks.clear();

    final loadedTasks = await _taskService.fetchTasks();

    _tasks.addAll(loadedTasks);

    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    await _taskService.addTask(task);
    await loadTasks();
  }

  Future<void> toggleTask(TaskModel task) async {
    task.isCompleted = !task.isCompleted;

    await _taskService.updateTask(task);

    notifyListeners();
  }

  Future<void> deleteTask(TaskModel task) async {
    final taskId = task.id;

    if (taskId == null) return;

    await _taskService.deleteTask(taskId);

    _tasks.removeWhere((t) => t.id == taskId);

    notifyListeners();
  }

  Future<void> updateTask(TaskModel updatedTask) async {
    await _taskService.updateTask((updatedTask));

    await loadTasks();
  }

  int get totalTasks => _tasks.length;

  int get completedTasks => _tasks.where((t) => t.isCompleted).length;

  int get pendingTasks => _tasks.where((t) => !t.isCompleted).length;

  String _selectedCategory = "All";

  String get selectedCategory => _selectedCategory;

  void changeCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<String> get categories {
    final subjects = _tasks.map((task) => task.subject).toSet().toList();
    return ["All", ...subjects];
  }

  List<TaskModel> get filteredTasks {
    if (_selectedCategory == "All") {
      return _tasks;
    }

    return _tasks.where((task) => task.subject == _selectedCategory).toList();
  }

  int get highPriorityTasks =>
      _tasks.where((task) => task.priority == "High").length;

  int get overdueTasks =>
      _tasks.where((task) => task.priority == "Overdue").length;

  double get productivityPercent {
    if (_tasks.isEmpty) return 0;

    return completedTasks / totalTasks;
  }

  String get studyInsight {
    if (_tasks.isEmpty) {
      return "Start by adding your first study task.";
    }

    if (overdueTasks > 0) {
      return "You have $overdueTasks overdue task(s). Try to complete them first.";
    }

    if (highPriorityTasks > 0) {
      return "You have $highPriorityTasks high priority task(s). Focus on them today.";
    }

    if (productivityPercent >= 0.8) {
      return "Great job! You are completing most of your study tasks.";
    }

    if (pendingTasks > completedTasks) {
      return "You have more pending tasks. Plan your study time carefully.";
    }

    return "Your study progress looks balanced. Keep going!";
  }
}
