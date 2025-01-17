import 'package:flutter/material.dart';
import 'package:taskly/models/subtask.dart';
import 'package:taskly/models/task.dart';

class SubtaskAddCard extends StatefulWidget {
  final Task? task;
  const SubtaskAddCard({
    super.key,
    required this.task,
  });

  @override
  State<SubtaskAddCard> createState() => _SubtaskAddCardState();
}

class _SubtaskAddCardState extends State<SubtaskAddCard> {
  List<Subtask> subtasks = [];
  Set<int> completedSubtaskIndexes = {};
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    if (widget.task != null && widget.task!.subtasks.isNotEmpty) {
      subtasks.addAll(widget.task!.subtasks);
      controllers.addAll(List.generate(
        widget.task!.subtasks.length,
        (index) =>
            TextEditingController(text: widget.task!.subtasks[index].title),
      ));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: const Text("Save"),
            onPressed: () {
              for (int i = 0; i < subtasks.length; i++) {
                Subtask s = subtasks[i];
                s.title = controllers[i].text;
              }
              Navigator.pop(context, subtasks);
            },
          ),
        )
      ],
      body: ListView.builder(
        itemCount: subtasks.length + 1,
        itemBuilder: (context, index) {
          if (index == subtasks.length) {
            return ListTile(
              title: const Text("Add subtask"),
              leading: const Icon(Icons.add_rounded),
              onTap: () {
                subtasks.add(Subtask(title: "", isCompleted: false));
                controllers.add(
                    TextEditingController(text: "Subtask #${subtasks.length}"));
                setState(() {});
              },
            );
          }
          return ListTile(
            title: TextField(controller: controllers[index]),
            leading: Checkbox(
              value: subtasks[index].isCompleted,
              onChanged: (value) => setState(() {
                completedSubtaskIndexes.contains(index)
                    ? completedSubtaskIndexes.remove(index)
                    : completedSubtaskIndexes.add(index);
              }),
            ),
          );
        },
      ),
    );
  }
}
