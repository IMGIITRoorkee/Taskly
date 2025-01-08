import 'package:flutter/material.dart';
import 'package:taskly/models/task.dart';

class TaskBoxWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onClose;
  final VoidCallback onStart;

  const TaskBoxWidget({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onClose,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Title
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Task Description
                  Text(
                    task.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  // Deadline (if applicable)
                  if (task.hasDeadline)
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Deadline: ${task.deadline.day}/${task.deadline.month}/${task.deadline.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),

                  // Dependency (if applicable)
                  if (task.dependency != null)
                    Row(
                      children: [
                        const Icon(Icons.link, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Depends on: ${task.dependency!.title}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        if (task.dependency!.isCompleted)
                          const Text(
                            'Completed',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.green),
                          ),
                        if (!task.dependency!.isCompleted)
                          const Text(
                            'Pending',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.red),
                          ),
                      ],
                    ),
                  const SizedBox(height: 20),

                  // Edit and Delete Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!task.isCompleted)
                        IconButton(
                          icon: const Icon(Icons.play_arrow_rounded),
                          onPressed: onStart,
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Close Button at the Top Right
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }
}
