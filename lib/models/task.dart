import 'package:flutter/material.dart';

class Task {
  String title;
  String description;
  bool isCompleted;
  DateTime? deadline;
  Color color;

  bool get hasDeadline => deadline != null;

  Task({
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.deadline,
    this.color = Colors.blue,
  });

  // Convert a Task object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'deadline': deadline?.toIso8601String(),
      'color': color.value,
    };
  }

  // Create a Task object from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      deadline: DateTime.parse(json['deadline']),
      color: Color(json['color']),
    );
  }
}
