import 'package:flutter/material.dart';
import 'package:taskly/models/task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskly/screens/task_box.dart';
import 'package:taskly/task_storage.dart';
import 'package:taskly/utils/date_utils.dart';

class TaskListScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(int, bool?) onToggle;
  final Function(int) onEdit;

  const TaskListScreen({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  int? deletedIndex;
  Task? deletedTask;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tasks.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final task = widget.tasks[index];
        return Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
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
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 8),
            child: Container(
              color: task.color.withOpacity(0.2),
              child: ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => TaskBoxWidget(
                      task: task,
                      onEdit: () => widget.onEdit(index),
                      onDelete: () async {
                        setState(() {
                          deletedTask = widget.tasks[index];
                          deletedIndex = index;
                          widget.tasks.removeAt(index);
                        });
                        Navigator.of(context)
                            .pop(); // Close the dialog after deletion
              
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                              SnackBar(
                                content: const Text("Deleted accidentally?"),
                                action: SnackBarAction(
                                  label: "Undo",
                                  onPressed: () {
                                    widget.tasks
                                        .insert(deletedIndex!, deletedTask!);
                                    setState(() {});
                                  },
                                ),
                              ),
                            )
                            .closed
                            .then(
                          (value) async {
                            if (value != SnackBarClosedReason.action) {
                              await TaskStorage.saveTasks(widget.tasks);
                            }
                          },
                        );
                      },
                      onClose: () => Navigator.of(context).pop(),
                    ),
                  );
                },
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle:
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    task.description.length > 30
                        ? '${task.description.substring(0, 30)}...'
                        : task.description,
                  ),
                  Row(children: [
                    if (task.hasDeadline)
                      Text(
                          'Deadline: ${MyDateUtils.getFormattedDate(task.deadline)}'),
                    if (task.hasDeadline &&
                        task.deadline.isBefore(DateTime.now()) &&
                        !task.isCompleted)
                      const Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                  ]),
                ]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => widget.onEdit(index),
                      icon: const Icon(Icons.edit),
                    ),
                    const SizedBox(width: 5),
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) => widget.onToggle(index, value),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}