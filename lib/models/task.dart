enum TaskPriority {
  low('Низкий'),
  medium('Средний'),
  high('Высокий');

  const TaskPriority(this.label);

  final String label;
}

class Task {
  final int id;
  final String title;
  final String description;
  final bool isDone;
  final TaskPriority priority;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isDone = false,
    this.priority = TaskPriority.medium,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json, {int? legacyId}) {
    return Task(
      id: legacyId ?? (json['id'] as int),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isDone: json['isDone'] as bool? ?? false,
      priority: TaskPriority.values.firstWhere(
        (value) => value.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'priority': priority.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // поля final, поэтому для изменения делаем копию с новыми значениями
  Task copyWith({
    String? title,
    String? description,
    bool? isDone,
    TaskPriority? priority,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      priority: priority ?? this.priority,
      createdAt: createdAt,
    );
  }
}
