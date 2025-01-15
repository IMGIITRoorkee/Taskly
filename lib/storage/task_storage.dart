import 'dart:convert';
import 'package:flutter/material.dart';
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

class DefaultTaskColorStorage {
  static const String _defaultColorKey = 'defaultColor';

  static Future<void> saveDefaultColor(int color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_defaultColorKey, color);
  }

  static Future<Color> loadDefaultColor() async {
    final prefs = await SharedPreferences.getInstance();
    return Color(prefs.getInt(_defaultColorKey)?? Colors.blue as int);
  }
}