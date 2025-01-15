import 'package:flutter/material.dart';

class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime? deadline;
  Color color;
  int? recurringDays;
  Task? dependency;
  int? reminder; // hrs before deadline

  bool get isRecurring => recurringDays != null;

  bool get hasDeadline => deadline != null;

  Task({
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.deadline,
    this.color = Colors.blue,
    this.recurringDays,
    this.dependency,
    String? id,
    this.reminder,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  // Convert a Task object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'deadline': deadline?.toIso8601String(),
      'dependency': dependency?.toJson(),
      'recurringDays': recurringDays,
      'color': color.value,
      'id': id,
      'reminder': reminder,
    };
  }

  // Create a Task object from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      deadline: DateTime.tryParse(json['deadline'] ?? ""),
      dependency:
          json['dependency'] != null ? Task.fromJson(json['dependency']) : null,
      recurringDays: json['recurringDays'],
      color: Color(json['color']),
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      reminder: json['reminder'],
    );
  }

  void toggleCompletion() {
    if (!isRecurring) {
      isCompleted = !isCompleted;
      return;
    }

    if (hasDeadline) {
      deadline = deadline!.add(Duration(days: recurringDays!));
      return;
    }
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, isCompleted: $isCompleted, deadline: $deadline, color: $color, recurringDays: $recurringDays, reminder: $reminder)';
  }
}
