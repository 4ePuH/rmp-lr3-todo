import 'dart:convert';

import 'package:web/web.dart' as web;

import '../models/task.dart';

class TodoRepository {
  static const _storageKey = 'lab3.todo.tasks';
  static const _legacyKey = 'flutter.tasks';

  final List<Task> _tasks = [];
  bool storageError = false;

  TodoRepository() {
    _load();
  }

  List<Task> get tasks => List.unmodifiable(_tasks);

  void add(Task task) {
    _tasks.insert(0, task);
    _save();
  }

  void _load() {
    try {
      final storage = web.window.localStorage;
      final saved = storage.getItem(_storageKey);
      final raw = saved ?? storage.getItem(_legacyKey);
      if (raw == null) return;

      final legacy = saved == null;
      final decoded = jsonDecode(raw);
      final items =
          (legacy && decoded is String ? jsonDecode(decoded) : decoded)
              as List<dynamic>;
      final tasks = <Task>[];
      for (var i = 0; i < items.length; i++) {
        tasks.add(
          Task.fromJson(
            items[i] as Map<String, dynamic>,
            legacyId: legacy ? i + 1 : null,
          ),
        );
      }
      if (legacy) {
        tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
      _tasks.addAll(tasks);
      if (legacy) _save();
    } catch (_) {
      storageError = true;
    }
  }

  void _save() {
    try {
      final data = jsonEncode(_tasks.map((task) => task.toJson()).toList());
      web.window.localStorage.setItem(_storageKey, data);
      storageError = false;
    } catch (_) {
      storageError = true;
    }
  }

  bool update(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return false;
    _tasks[index] = task;
    _save();
    return true;
  }

  void delete(int id) {
    _tasks.removeWhere((task) => task.id == id);
    _save();
  }
}
