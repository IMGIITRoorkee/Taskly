import 'package:flutter/material.dart';

class TaskFormScreen extends StatelessWidget {
  const TaskFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Task Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save task
              },
              child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
