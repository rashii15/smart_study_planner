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

  Future<void> toggleTask(int index) async {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;

    await _taskService.updateTask(_tasks[index]);

    notifyListeners();
  }

  Future<void> deleteTask(int index) async {
    final taskId = _tasks[index].id;

    if (taskId == null) return;

    await _taskService.deleteTask(taskId);

    _tasks.removeAt(index);

    notifyListeners();
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
}
