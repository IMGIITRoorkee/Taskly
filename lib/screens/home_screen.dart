import 'package:flutter/material.dart';

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
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
