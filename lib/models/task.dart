import 'package:flutter/material.dart';

class Task {
  String title;
  String description;
  bool isCompleted;
  DateTime deadline;
  bool hasDeadline;
  Color color;
  bool isRecurring;
  int recurringDays;

  Task(
      {required this.title,
      this.description = '',
      this.isCompleted = false,
      DateTime? deadline,
      this.hasDeadline = false,
      this.color = Colors.blue,
      this.isRecurring = false,
      int? recurringDays})
      : deadline = deadline ?? DateTime.now(),
        recurringDays = recurringDays ?? 0;

  // Convert a Task object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'deadline': deadline.toIso8601String(),
      'hasDeadline': hasDeadline,
      'isRecurring': isRecurring,
      'recurringDays': recurringDays,
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
      hasDeadline: json['hasDeadline'],
      isRecurring: json['isRecurring'],
      recurringDays: json['recurringDays'],
      color: Color(json['color']),
    );
  }

  void toggleCompletion() {
    if (!isRecurring) {
      isCompleted = !isCompleted;
      return;
    }

    if (hasDeadline) {
      deadline = deadline.add(Duration(days: recurringDays));
      return;
    }
  }
}
