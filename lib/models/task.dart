import 'package:flutter/material.dart';

class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime deadline;
  bool hasDeadline;
  Color color;

  Task(
      {required this.title,
      this.description = '',
      this.isCompleted = false,
      DateTime? deadline,
      this.hasDeadline = false,
      this.color = Colors.blue,
      String? id})
      : deadline = deadline ?? DateTime.now(),
        id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  // Convert a Task object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'deadline': deadline.toIso8601String(),
      'hasDeadline': hasDeadline,
      'color': color.value,
      'id': id,
    };
  }

  // Create a Task object from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      deadline: DateTime.parse(json['deadline']),
      hasDeadline: json['hasDeadline'],
      color: Color(json['color']),
      id: json['id'],
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, isCompleted: $isCompleted, deadline: $deadline, hasDeadline: $hasDeadline)';
  }
}
