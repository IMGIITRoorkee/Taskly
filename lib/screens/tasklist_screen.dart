import 'package:flutter/material.dart';
import 'package:taskly/models/task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskly/screens/task_box.dart';
import 'package:taskly/storage/task_storage.dart';
import 'package:taskly/utils/date_utils.dart';
import 'package:taskly/utils/share_utils.dart';

class TaskListScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(int, bool?) onToggle;
  final Function(int) onEdit;
  final Set<int> selectedIndexes;
  final Function(int) onSelectionAdded;
  final Function(int) onSelectionRemoved;
  final Function(int) onStart;
  final Function(int, Task) onSubtaskChanged;

  const TaskListScreen({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onEdit,
    required this.selectedIndexes,
    required this.onSelectionAdded,
    required this.onSelectionRemoved,
    required this.onStart,
    required this.onSubtaskChanged,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final Map<String, bool> _expandedSections = {};
  int? deletedIndex;
  Task? deletedTask;

  List<MapEntry<String, List<Task>>> _groupTasksByDeadline() {
    final Map<String, List<Task>> grouped = {
      'No Deadline': [],
    };

    for (var task in widget.tasks) {
      if (!task.hasDeadline) {
        grouped['No Deadline']!.add(task);
        continue;
      }

      final deadline = MyDateUtils.getFormattedDate(task.deadline!);
      grouped.putIfAbsent(deadline, () => []);
      grouped[deadline]!.add(task);
    }

    return grouped.entries.toList()
      ..sort((a, b) {
        if (a.key == 'No Deadline') return -1;
        if (b.key == 'No Deadline') return 1;
        return a.key.compareTo(b.key);
      });
  }

  void _showTaskDetails(Task task, int index) async {
    bool? res = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TaskBoxWidget(
        task: task,
        onEdit: () => widget.onEdit(index),
        onStart: () => widget.onStart(index),
        onShare: () => ShareUtils.shareTask(task),
        onDelete: () async {
          setState(() {
            deletedTask = widget.tasks[index];
            deletedIndex = index;
            widget.tasks.removeAt(index);
          });
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  content: const Text("Deleted accidentally?"),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      widget.tasks.insert(deletedIndex!, deletedTask!);
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
      ),
    );
    if (res != null && res) {
      widget.onSubtaskChanged(index, task);
    }
  }

  void _toggleTaskSelection(int index) {
    if (widget.selectedIndexes.contains(index)) {
      widget.onSelectionRemoved(index);
    } else {
      widget.onSelectionAdded(index);
    }
  }

  Widget _buildTaskTile(Task task, int index) {
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
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Card(
          elevation: 0,
          color: widget.selectedIndexes.contains(index)
              ? Colors.grey.withOpacity(0.5)
              : task.color.withOpacity(0.2),
          margin: const EdgeInsets.all(0),
          child: ListTile(
            onTap: () {
              if (widget.selectedIndexes.isEmpty) {
                _showTaskDetails(task, index);
              } else {
                _toggleTaskSelection(index);
              }
            },
            onLongPress: () => _toggleTaskSelection(index),
            title: Text(
              task.title,
              style: TextStyle(
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              task.description.length > 30
                  ? '${task.description.substring(0, 30)}...'
                  : task.description,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (task.dependency != null)
                  Icon(
                    Icons.link,
                    color: task.dependency!.isCompleted
                        ? Colors.green
                        : Colors.blue,
                  ),
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
  }

  @override
  Widget build(BuildContext context) {
    final groupedTasks = _groupTasksByDeadline();

    return ListView.builder(
      itemCount: groupedTasks.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, sectionIndex) {
        final section = groupedTasks[sectionIndex];
        final isExpanded = _expandedSections[section.key] ?? true;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  _expandedSections[section.key] = !isExpanded;
                });
              },
              leading: Icon(
                isExpanded ? Icons.expand_more : Icons.chevron_right,
              ),
              title: Text(
                '${section.key} (${section.value.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (isExpanded)
              ...section.value.map((task) {
                final index = widget.tasks.indexOf(task);
                return _buildTaskTile(task, index);
              }),
          ],
        );
      },
    );
  }
}
