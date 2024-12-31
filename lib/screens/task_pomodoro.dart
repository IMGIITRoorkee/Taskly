import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/utils/date_utils.dart';
import 'package:taskly/utils/screen_utils.dart';
import 'package:taskly/widgets/spacing.dart';

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
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("Mark as Complete"),
          ),
        )
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Text(
                  widget.task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  widget.task.description,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  MyDateUtils.getFormattedDate(widget.task.deadline),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
          const Spacing(large: true),
          DurationPicker(
            duration: _duration,
            baseUnit: BaseUnit.minute,
            width: ScreenUtils.getPercentOfWidth(context, 0.6),
            height: ScreenUtils.getPercentOfWidth(context, 0.6),
            lowerBound: const Duration(minutes: 15),
            upperBound: const Duration(minutes: 60),
            onChange: (value) => setState(() {
              _duration = value;
            }),
          ),
          const Spacing(),
          const Text("Stay focused for 25 mins"),
          const Spacing(large: true),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(48),
            ),
            color: Theme.of(context).primaryColorLight,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow_rounded),
              iconSize: 48,
            ),
          ),
        ],
      ),
    );
  }
}
