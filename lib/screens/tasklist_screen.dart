import 'package:flutter/material.dart';
import 'package:taskly/models/task.dart';

class TaskListScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(int, bool?) onToggle;

  const TaskListScreen({super.key, required this.tasks, required this.onToggle});

  void opfinal(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
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
            onChanged: (value) {
              if (!task.isCompleted) {
                opfinal(context, 'Well Done! Task Complete!');
              }
              onToggle(index, value);            },
          ),
        );
      },
    );
  }
}