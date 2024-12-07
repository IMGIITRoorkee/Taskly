import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskListScreen extends StatelessWidget {
  final List<Task> tasks;

  const TaskListScreen({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              // Toggle task completion
            },
          ),
        );
      },
    );
  }
}
