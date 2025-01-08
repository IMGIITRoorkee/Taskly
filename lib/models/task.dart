import 'package:flutter/material.dart';

class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime deadline;
  bool hasDeadline;
  Color color;
  int? recurringDays;
  Task? dependency;

  bool get isRecurring => recurringDays != null;

  Task(
      {required this.title,
      this.description = '',
      this.isCompleted = false,
      DateTime? deadline,
      this.hasDeadline = false,
      this.color = Colors.blue,
      this.recurringDays,
      this.dependency,
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
      'dependency': dependency?.toJson(),
      'recurringDays': recurringDays,
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
      dependency:
          json['dependency'] != null ? Task.fromJson(json['dependency']) : null,
      recurringDays: json['recurringDays'],
      color: Color(json['color']),
      id: json['id'],
    );
  }

  void toggleCompletion() {
    if (!isRecurring) {
      isCompleted = !isCompleted;
      return;
    }

    if (hasDeadline) {
      deadline = deadline.add(Duration(days: recurringDays!));
      return;
    }
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, isCompleted: $isCompleted, deadline: $deadline, hasDeadline: $hasDeadline)';
  }
}
