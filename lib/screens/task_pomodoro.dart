import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/utils/date_utils.dart';

class TaskPomodoroScreen extends StatefulWidget {
  final Task task;
  const TaskPomodoroScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskPomodoroScreen> createState() => _TaskPomodoroScreenState();
}

class _TaskPomodoroScreenState extends State<TaskPomodoroScreen> {
  Duration _duration = const Duration(minutes: 25);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pomodoro Timer"),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text(
                widget.task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                widget.task.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                MyDateUtils.getFormattedDate(widget.task.deadline),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
          Center(
            child: DurationPicker(
              duration: _duration,
              baseUnit: BaseUnit.minute,
              lowerBound: const Duration(minutes: 15),
              upperBound: const Duration(minutes: 60),
              onChange: (value) => setState(() {
                _duration = value;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
