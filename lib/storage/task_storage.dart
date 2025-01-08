import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskly/models/task.dart';

class TaskStorage {
  static const String _taskKey = 'tasks';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> encodedTasks =
        tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_taskKey, encodedTasks);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? encodedTasks = prefs.getStringList(_taskKey);
    if (encodedTasks == null) return [];

    return encodedTasks
        .map((encodedTask) => Task.fromJson(jsonDecode(encodedTask)))
        .toList();
  }
}
