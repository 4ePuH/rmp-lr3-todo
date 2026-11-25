import 'package:flutter/material.dart';

import '../models/task.dart';
import '../utils/format.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priorityColors = {
      TaskPriority.low: Colors.green.shade300,
      TaskPriority.medium: Colors.orange.shade300,
      TaskPriority.high: theme.colorScheme.error,
    };

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: ListTile(
        leading: Checkbox(value: task.isDone, onChanged: (_) => onToggle()),
        title: Text(
          task.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          // выполненная задача зачёркнута и бледнее
          style: task.isDone
              ? TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: theme.colorScheme.onSurfaceVariant,
                )
              : null,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty)
              Text(
                task.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              'Создана ${formatDateTime(task.createdAt)}',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              'Приоритет: ${task.priority.label}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: priorityColors[task.priority],
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Удалить',
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
