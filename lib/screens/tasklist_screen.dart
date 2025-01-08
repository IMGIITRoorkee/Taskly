import 'package:flutter/material.dart';
import 'package:taskly/models/task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskly/screens/task_box.dart';
import 'package:taskly/storage/task_storage.dart';
import 'package:taskly/utils/date_utils.dart';

class TaskListScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(int, bool?) onToggle;
  final Function(int) onEdit;
  final Function(int) onStart;

  const TaskListScreen({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onEdit,
    required this.onStart,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  int? deletedIndex;
  Task? deletedTask;
  Map<String, bool> sectionExpanded = {};

  // Group tasks by deadline
  Map<String, List<Task>> _groupTasksByDeadline() {
    final Map<String, List<Task>> grouped = {
      'No Deadline': [],
    };
    
    for (var task in widget.tasks) {
      if (!task.hasDeadline) {
        grouped['No Deadline']!.add(task);
        continue;
      }
      
      String key = MyDateUtils.getFormattedDate(task.deadline);
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
        // Initialize expansion state
        if (!sectionExpanded.containsKey(key)) {
          sectionExpanded[key] = true;
        }
      }
      grouped[key]!.add(task);
    }
    
    return grouped;
  }

  Widget _buildTaskTile(Task task, int globalIndex) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              setState(() {
                widget.tasks.removeAt(globalIndex);
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
          color: task.color.withOpacity(0.2),
          margin: const EdgeInsets.all(0),
          child: ListTile(
            onTap: () => _showTaskDialog(task, globalIndex),
            title: Row(
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(width: 4),
                if (task.isRecurring) const Icon(Icons.repeat_rounded, size: 16),
              ],
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
                    color: task.dependency!.isCompleted ? Colors.green : Colors.blue,
                    size: 20,
                  ),
                IconButton(
                  onPressed: () => widget.onEdit(globalIndex),
                  icon: const Icon(Icons.edit),
                  iconSize: 20,
                ),
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) => widget.onToggle(globalIndex, value),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTaskDialog(Task task, int index) {
    showDialog(
      context: context,
      builder: (context) => TaskBoxWidget(
        task: task,
        onEdit: () => widget.onEdit(index),
        onStart: () => widget.onStart(index),
        onDelete: () => _deleteTask(index),
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _deleteTask(int index) async {
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
                setState(() {
                  widget.tasks.insert(deletedIndex!, deletedTask!);
                });
              },
            ),
          ),
        )
        .closed
        .then((value) async {
          if (value != SnackBarClosedReason.action) {
            await TaskStorage.saveTasks(widget.tasks);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final groupedTasks = _groupTasksByDeadline();
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedTasks.length,
      itemBuilder: (context, sectionIndex) {
        final deadline = groupedTasks.keys.elementAt(sectionIndex);
        final tasksInSection = groupedTasks[deadline]!;
        
        return Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  sectionExpanded[deadline] = !(sectionExpanded[deadline] ?? true);
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(
                      (sectionExpanded[deadline] ?? true)
                          ? Icons.expand_more
                          : Icons.chevron_right,
                    ),
                    Text(
                      '$deadline (${tasksInSection.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            if (sectionExpanded[deadline] ?? true)
              ...tasksInSection.map((task) {
                final globalIndex = widget.tasks.indexOf(task);
                return _buildTaskTile(task, globalIndex);
              }).toList(),
          ],
        );
      },
    );
  }
}