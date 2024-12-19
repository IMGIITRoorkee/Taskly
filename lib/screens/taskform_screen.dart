import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskly/models/task.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _key,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Task Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Title cannot be empty!";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descController,
                  decoration:
                      const InputDecoration(labelText: 'Task Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Description cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      Task task = Task(
                        title: _titleController.text,
                        description: _descController.text,
                      );
                      Fluttertoast.showToast(msg: "Task Successfully Created!");
                      Navigator.pop(context,task);
                    }
                  },
                  child: const Text('Save Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
