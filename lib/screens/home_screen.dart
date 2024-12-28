import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskly/enums/taskoptions.dart';
import 'package:taskly/kudos_storage.dart';
import 'package:taskly/models/kudos.dart';
import 'package:taskly/models/tip.dart';
import 'package:taskly/screens/kudos_details.dart';
import 'package:taskly/screens/taskform_screen.dart';
import 'package:taskly/screens/tasklist_screen.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/task_storage.dart';
import 'package:taskly/service/random_tip_service.dart';
import 'package:taskly/widgets/theme_mode_switch.dart';
import 'package:taskly/widgets/tip_of_day_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  Kudos kudos = Kudos(score: 0, history: []);
  Tip? tip;

  @override
  void initState() {
    super.initState();
    _fetch();
    _loadTasks();
    _loadKudos();
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

    if (tasks[index].isCompleted) {
      // Task is marked as completed
      if (tasks[index].hasDeadline) {
        var days_diff =
            tasks[index].deadline.difference(DateTime.now()).inDays;
        kudos.score += days_diff;

        String status = (days_diff > 0)
            ? "$days_diff days before deadline"
            : (days_diff == 0)
                ? "on time"
                : "${-days_diff} days after deadline";

        String title = "Completed '${tasks[index].title}' $status";

        kudos.history.add([title, days_diff.toString()]);
      } else {
        kudos.score += 1;
        kudos.history.add(["Completed '${tasks[index].title}'", "1"]);
      }
    } else {
      // Task is marked as incomplete
      if (tasks[index].hasDeadline) {
        for (int i = 0; i < kudos.history.length; i++) {
          // Find the matching task in history
          if (kudos.history[i][0].startsWith("Completed '${tasks[index].title}'")) {
            // Reduce the score by the previously added value
            int previousScore = int.parse(kudos.history[i][1]);
            kudos.score -= previousScore;

            // Add a new history entry to indicate score reduction
            String reductionTitle =
                "Score reduced for '${tasks[index].title}'";
            kudos.history.add([reductionTitle, (-previousScore).toString()]);

            break;
          }
        }
      } else {
        // For tasks without deadlines, reduce score by 1
        kudos.score -= 1;
        kudos.history.add(["Score reduced for '${tasks[index].title}'", "-1"]);
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
      } else if (option == TaskOption.showKudos) {
        showDialog(
          context: context,
          builder: (context) => KudosDetails(
              kudos: kudos, onClose: () => Navigator.of(context).pop()),
        );
      }
    });
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

  // Load kudos from SharedPreferences
  void _loadKudos() async {
    Kudos loadedKudos = await KudosStorage.loadKudos();
    setState(() {
      kudos = loadedKudos;
    });
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
                  value: TaskOption.showKudos,
                  child: Text("My Kudos"),
                )
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
