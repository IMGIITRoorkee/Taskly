import 'package:flutter/material.dart';
import 'package:taskly/models/task.dart';

class TaskListScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(int, bool?) onToggle;

  const TaskListScreen(
      {super.key, required this.tasks, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(task.description),
          trailing: Checkbox(
            value: task.isCompleted,
            onChanged: (value) => onToggle(index, value),
          ),
        );
      },
    );
  }
}
