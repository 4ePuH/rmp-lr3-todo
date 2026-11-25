import 'package:flutter/foundation.dart';

import '../data/todo_repository.dart';
import '../models/task.dart';

enum TaskFilter { all, active, done }

// Состояние списка: сами задачи, выбранный фильтр и строка поиска.
// Экраны сюда только обращаются, сами список не меняют
class TodoState extends ChangeNotifier {
  final TodoRepository repository;

  TodoState(this.repository) {
    for (final task in repository.tasks) {
      if (task.id >= _nextId) _nextId = task.id + 1;
    }
  }

  List<Task> get tasks => repository.tasks;
  bool get storageError => repository.storageError;
  TaskFilter filter = TaskFilter.all;
  String query = '';

  List<Task> get visibleTasks {
    final search = query.trim().toLowerCase();
    final visible = <Task>[];
    for (final task in tasks) {
      if (filter == TaskFilter.active && task.isDone) continue;
      if (filter == TaskFilter.done && !task.isDone) continue;
      if (!task.title.toLowerCase().contains(search)) continue;
      visible.add(task);
    }
    return visible;
  }

  int get activeCount => tasks.where((t) => !t.isDone).length;
  int get doneCount => tasks.where((t) => t.isDone).length;

  void setFilter(TaskFilter value) {
    filter = value;
    notifyListeners();
  }

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  int _nextId = 1;

  bool addTask(String title, String description, TaskPriority priority) {
    if (title.trim().isEmpty) return false;
    repository.add(
      Task(
        id: _nextId++,
        title: title.trim(),
        description: description.trim(),
        priority: priority,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
    return true;
  }

  bool updateTask(Task updated) {
    if (updated.title.trim().isEmpty) return false;
    if (!repository.update(updated)) return false;
    notifyListeners();
    return true;
  }

  void toggleDone(Task task) {
    updateTask(task.copyWith(isDone: !task.isDone));
  }

  void deleteTask(int id) {
    repository.delete(id);
    notifyListeners();
  }
}
