import 'package:flutter/material.dart';
import 'package:taskly/screens/taskform_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
      ),
      body: const Center(
        child: Text('Welcome to Taskly!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add task functionality
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
