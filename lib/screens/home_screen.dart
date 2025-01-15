import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskly/constants.dart';
import 'package:taskly/enums/taskoptions.dart';
import 'package:taskly/service/permissions_service.dart';
import 'package:taskly/storage/kudos_storage.dart';
import 'package:taskly/models/kudos.dart';
import 'package:taskly/models/tip.dart';
import 'package:taskly/screens/kudos_details.dart';
import 'package:taskly/screens/meditation_screen.dart';
import 'package:taskly/screens/task_pomodoro_screen.dart';
import 'package:taskly/screens/taskform_screen.dart';
import 'package:taskly/screens/tasklist_screen.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/storage/task_storage.dart';
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
  static const platform = MethodChannel('com.example.taskly/deeplink');
  List<Task> tasks = [];
  Kudos kudos = Kudos(score: 0, history: []);
  Tip? tip;
  bool showtip = false;
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    _fetch();
    _loadTasks();
    _loadKudos();
    _listenForDeepLink();
  }

  void _listenForDeepLink() {
    platform.setMethodCallHandler(
      (call) async {
        if (call.method == "onDeepLink") {
          final String? data = call.arguments as String?;
          if (data != null) {
            Uri deeplink = Uri.parse(data);
            int index = tasks.indexWhere(
              (element) => element.id == deeplink.queryParameters['id'],
            );
            if (index == -1) {
              Fluttertoast.showToast(msg: "Task could not be found!");
            } else {
              _editTask(index);
            }
          }
        }
      },
    );
  }

  void _fetch() async {
    (await RandomTipService().getRandomTip()).when(
      (success) {
        tip = success;
        showtip = true;
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
    if (tasks[index].dependency != null &&
        !tasks[index].dependency!.isCompleted) {
      Fluttertoast.showToast(
        msg: AskDependencyCompletion,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }
    setState(() {
      tasks[index].toggleCompletion();

      if (tasks[index].isCompleted) {
        if (tasks[index].hasDeadline) {
          var days_diff =
              tasks[index].deadline!.difference(DateTime.now()).inDays + 1;
          if (days_diff == 0) {
            days_diff = 1;
          }
          kudos.score += days_diff;
          String status = (days_diff > 0)
              ? completedBeforeDeadline(days_diff)
              : (days_diff == 0)
                  ? completedOnTime
                  : completedAfterDeadline(days_diff.abs());

          String title = "'${tasks[index].title}': $status";
          kudos.history.add([title, days_diff.toString()]);
        } else {
          kudos.score += 1;
          kudos.history
              .add([completeTaskWithNoDeadline(tasks[index].title), "1"]);
        }
      } else {
        if (tasks[index].hasDeadline) {
          for (int i = 0; i < kudos.history.length; i++) {
            if (kudos.history[i][0].startsWith("'${tasks[index].title}':")) {
              print(kudos.history[i]);
              int previousScore = int.parse(kudos.history[i][1]);
              kudos.score -= previousScore;
              kudos.history.add([
                scoreReducedForTask(tasks[index].title),
                (-previousScore).toString()
              ]);
              break;
            }
          }
        } else {
          kudos.score -= 1;
          kudos.history.add([scoreReducedForTask(tasks[index].title), "-1"]);
        }
      }
    });

    await KudosStorage.saveKudos(kudos);
    await TaskStorage.saveTasks(tasks);
  }

  // Handle task options, now using the enum
  void _onOptionSelected(TaskOption option) {
    setState(() {
      if (option == TaskOption.deleteAll) {
        tasks = [];
        TaskStorage.saveTasks(tasks);
        KudosStorage.saveKudos(Kudos(score: 0, history: []));
      } else if (option == TaskOption.showKudos) {
        showDialog(
          context: context,
          builder: (context) => KudosDetails(
              kudos: kudos, onClose: () => Navigator.of(context).pop()),
        );
      } else if (option == TaskOption.deleteSelected) {
        if (selectedIndexes.isEmpty) {
          Fluttertoast.showToast(msg: "Long click on tasks to select them");
          return;
        }
        List<int> sorted = selectedIndexes.toList()
          ..sort((a, b) => b.compareTo(a));

        for (int i in sorted) {
          tasks.removeAt(i);
        }
        setState(() {
          selectedIndexes = {};
          TaskStorage.saveTasks(tasks);
        });
      } else if (option == TaskOption.launchMeditationScreen) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MeditationScreen()));
      } else if (option == TaskOption.toggleTipVisibility) {
      } else if (option == TaskOption.toggleTipVisibility) {
        showtip = !showtip;
      } else if (option == TaskOption.exportToCSV) {
      } else if (option == TaskOption.exportToCSV) {
        exportToCSV(tasks);
      }
    });
  }

  void _onSelectionAdded(int index) => setState(() {
        selectedIndexes.add(index);
        _showUpdatedSelectionsToast();
      });

  void _onSelectionRemoved(int index) => setState(() {
        selectedIndexes.remove(index);
        if (selectedIndexes.isNotEmpty) _showUpdatedSelectionsToast();
      });

  void _showUpdatedSelectionsToast() {
    Fluttertoast.showToast(msg: "Selected tasks: ${selectedIndexes.length}");
  }

  void _editTask(int index) async {
    final newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(
          task: tasks[index],
          availableTasks: tasks,
        ),
      ),
    );

    if (newTask != null) {
      tasks[index] = newTask;
      setState(() {});
      await TaskStorage.saveTasks(tasks);
    }
  }

  void exportToCSV(List<Task> tasks) async {
    if (Platform.isAndroid) {
      bool status = await PermissionsService.askForStorage();
      if (!status) {
        Fluttertoast.showToast(
            msg: "Storage permission is needed to export csv file!");
        return;
      }
    }

    // Prepare CSV data
    List<List<dynamic>> rows = [];

    // Add header
    rows.add(
        ["Title", "Description", "Is Completed", "Has Deadline", "Deadline"]);

    // Add data rows
    for (var task in tasks) {
      rows.add([
        task.title,
        task.description,
        task.isCompleted,
        task.hasDeadline,
        task.hasDeadline
            ? '${task.deadline!.day}/${task.deadline!.month}/${task.deadline!.year}'
            : null,
      ]);
    }

    // Convert to CSV string
    String csv = const ListToCsvConverter().convert(rows);

    // Open directory picker
    String? directory = await FilePicker.platform.getDirectoryPath();

    if (directory == null) {
      // User canceled the picker
      return;
    }

    // Create the file path
    final path = "$directory/tasks.csv";

    // Write the CSV file
    final file = File(path);
    await file.writeAsString(csv);

    Fluttertoast.showToast(msg: "File saved at: $path");
  }

  void _loadKudos() async {
    Kudos loadedKudos = await KudosStorage.loadKudos();
    setState(() {
      kudos = loadedKudos;
    });
  }

  void _onStartTask(int index) async {
    // close the task details dialog
    Navigator.pop(context);

    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskPomodoroScreen(task: tasks[index]),
      ),
    );
    if (result != null && result) {
      _toggleTaskCompletion(index, true);
    }
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
                  value: TaskOption.deleteSelected,
                  child: Text("Delete selected tasks"),
                ),
                const PopupMenuItem(
                  value: TaskOption.deleteAll,
                  child: Text("Delete all tasks"),
                ),
                PopupMenuItem(
                  value: TaskOption.toggleTipVisibility,
                  child: showtip
                      ? const Text("Hide tip of the day")
                      : const Text("Show tip of the day"),
                ),
                const PopupMenuItem(
                  value: TaskOption.exportToCSV,
                  child: Text("Export to CSV file."),
                ),
                const PopupMenuItem(
                  value: TaskOption.showKudos,
                  child: Text("My Kudos"),
                ),
                const PopupMenuItem(
                  value: TaskOption.launchMeditationScreen,
                  child: Text("Meditate"),
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
            crossFadeState:
                showtip ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(seconds: 1),
          ),
          tasks.isEmpty
              ? const Center(child: Text('No tasks yet!'))
              : TaskListScreen(
                  tasks: tasks,
                  onToggle: _toggleTaskCompletion,
                  onEdit: _editTask,
                  selectedIndexes: selectedIndexes,
                  onSelectionAdded: _onSelectionAdded,
                  onSelectionRemoved: _onSelectionRemoved,
                  onStart: _onStartTask,
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push<Task>(
            context,
            MaterialPageRoute(
                builder: (context) => TaskFormScreen(
                      availableTasks: tasks,
                    )),
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
