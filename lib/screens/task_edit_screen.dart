import 'package:flutter/material.dart';

import '../models/task.dart';

// что возвращает экран формы через Navigator.pop
class TaskDraft {
  final String title;
  final String description;
  final TaskPriority priority;

  TaskDraft(this.title, this.description, this.priority);
}

// Один экран и для создания, и для редактирования.
// task == null - новая задача, иначе редактируем переданную
class TaskEditScreen extends StatefulWidget {
  final Task? task;

  const TaskEditScreen({super.key, this.task});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late TaskPriority priority;

  static const int maxTitleLength = 100;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task?.title ?? '');
    descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    priority = widget.task?.priority ?? TaskPriority.medium;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите название задачи';
    }
    if (value.trim().length > maxTitleLength) {
      return 'Слишком длинное название';
    }
    return null;
  }

  void save() {
    // validate() вызывает validator у всех полей формы и показывает ошибки
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      TaskDraft(
        titleController.text.trim(),
        descriptionController.text.trim(),
        priority,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактирование' : 'Новая задача'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: titleController,
              autofocus: !isEditing,
              maxLength: maxTitleLength,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Название'),
              validator: validateTitle,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: descriptionController,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Описание (необязательно)',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskPriority>(
              initialValue: priority,
              decoration: const InputDecoration(labelText: 'Приоритет'),
              items: [
                for (final level in TaskPriority.values)
                  DropdownMenuItem(value: level, child: Text(level.label)),
              ],
              onChanged: (value) {
                if (value != null) priority = value;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: save,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
