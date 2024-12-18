import 'package:flutter/material.dart';
import 'package:taskly/models/task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskly/task_storage.dart';

class TaskListScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(int, bool?) onToggle;

  const TaskListScreen(
      {super.key, required this.tasks, required this.onToggle});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tasks.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final task = widget.tasks[index];
        return Slidable(
          endActionPane: ActionPane(motion: StretchMotion(), children: [
            SlidableAction(
              onPressed: (context) async {
                setState(() {
                widget.tasks.removeAt(index);
                });
                await TaskStorage.saveTasks(widget.tasks);

              },
              icon: Icons.delete,
              foregroundColor: Colors.red,
            ),
          ]),
          child: ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description),
              Row(
                children: [
                if (task.hasDeadline)
                Text('Deadline: ${task.deadline.day}/${task.deadline.month}/${task.deadline.year}'),
              if (task.hasDeadline && task.deadline.isBefore(DateTime.now()) && !task.isCompleted)
                Icon(Icons.warning, color: Colors.red,),
              ]         ),
            ]
          ),
          trailing: Checkbox(
            value: task.isCompleted,
            onChanged: (value) => widget.onToggle(index, value),
          ),
        ),
        );
      },
    );
  }
}
