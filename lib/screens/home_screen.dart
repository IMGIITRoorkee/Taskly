import 'package:flutter/material.dart';
import 'package:taskly/screens/taskform_screen.dart';
import 'package:taskly/screens/tasklist_screen.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/task_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks from SharedPreferences
  void _loadTasks() async {
    List<Task> loadedTasks = await TaskStorage.loadTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }

  void _addTask(Task task) async {
    setState(() {
      tasks.add(task);
    });
    await TaskStorage.saveTasks(tasks); 
  }

  void _toggleTaskCompletion(int index, bool? value) async {
    setState(() {
      tasks[index].isCompleted = value ?? false;
    });
    await TaskStorage.saveTasks(tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet!'))
          : TaskListScreen(tasks: tasks, onToggle: _toggleTaskCompletion),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push<Task>(
            context,
            MaterialPageRoute(builder: (context) => const TaskFormScreen()),
          );
          if (newTask != null) {
            _addTask(newTask);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
