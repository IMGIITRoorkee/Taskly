import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskly/google_calendar.dart';
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
      backgroundColor: Colors.white.withOpacity(0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

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

                      // Edit and Delete Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
            ),
          ),
          // Close Button at the Top Right
          Positioned(
            top: 0,
            left: 0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              margin: const EdgeInsets.all(0),
              child: IconButton(
                icon: const Icon(Icons.close),
                iconSize: 16,
                onPressed: onClose,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
