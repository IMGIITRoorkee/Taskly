import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskly/enums/taskoptions.dart';
import 'package:taskly/models/tip.dart';
import 'package:taskly/screens/taskform_screen.dart';
import 'package:taskly/screens/tasklist_screen.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/task_storage.dart';
import 'package:taskly/service/random_tip_service.dart';
import 'package:taskly/widgets/theme_mode_switch.dart';
import 'package:taskly/widgets/tip_of_day_card.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  Tip? tip;

  @override
  void initState() {
    super.initState();
    _fetch();
    _loadTasks();
  }

  void _fetch() async {
    (await RandomTipService().getRandomTip()).when(
      (success) {
        tip = success;
        setState(() {});
      },
      (error) {
        Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_LONG,
        );
      },
    );
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

  // Handle task options, now using the enum
  void _onOptionSelected(TaskOption option) {
    setState(() {
      if (option == TaskOption.deleteAll) {
        tasks = [];
        TaskStorage.saveTasks(tasks);
      }
      else if (option == TaskOption.exportToCSV) {
        exportToCSV(tasks);
      }

    });

    void _editTask(int index) async {
      final newTask = await Navigator.push<Task>(
        context,
        MaterialPageRoute(
          builder: (context) => TaskFormScreen(task: tasks[index]),
        ),
      );

      if (newTask != null) {
        tasks[index] = newTask;
        setState(() {});
        await TaskStorage.saveTasks(tasks);
      }
    }
  }

  void _editTask(int index) async {
    final newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: tasks[index]),
      ),
    );

    if (newTask != null) {
      tasks[index] = newTask;
      setState(() {});
      await TaskStorage.saveTasks(tasks);
    }
  }
void exportToCSV(List<Task> tasks) async {
  // Prepare CSV data
  List<List<dynamic>> rows = [];

  // Add header
  rows.add(["Title", "Description", "Is Completed","Has Deadline","Deadline"]);

  // Add data rows
  for (var task in tasks) {
    rows.add([task.title, task.description, task.isCompleted,task.hasDeadline,'${task.deadline.day}/${task.deadline.month}/${task.deadline.year}']);
  }

  // Convert to CSV string
  String csv = const ListToCsvConverter().convert(rows);

  // Open directory picker
  String? directory = await FilePicker.platform.getDirectoryPath();

  if (directory == null) {
    // User canceled the picker
    print("Export canceled.");
    return;
  }

  // Create the file path
  final path = "$directory/tasks.csv";

  // Write the CSV file
  final file = File(path);
  await file.writeAsString(csv);

  print("File saved at: $path");
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Taskly',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        actions: [
          const ThemeModeSwitch(),
          PopupMenuButton<TaskOption>(
            onSelected: _onOptionSelected,
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: TaskOption.deleteAll,
                  child: Text("Delete all tasks"),
                ),
                const PopupMenuItem(
                  value: TaskOption.exportToCSV,
                  child: Text("Export to CSV file."),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          AnimatedCrossFade(
            firstChild: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 24),
              child: TipOfDayCard(tip: tip),
            ),
            secondChild: Container(),
            crossFadeState: tip != null
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(seconds: 1),
          ),
          tasks.isEmpty
              ? const Center(child: Text('No tasks yet!'))
              : TaskListScreen(
                  tasks: tasks,
                  onToggle: _toggleTaskCompletion,
                  onEdit: _editTask,
                ),
        ],
      ),
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
