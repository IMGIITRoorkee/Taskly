import 'package:flutter/material.dart';

import 'package:taskly/models/subtask.dart';

class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime? deadline;
  Color color;
  int? recurringDays;
  Task? dependency;
  List<Subtask> subtasks;

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
    List<Subtask>? subtasks,
  })  : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        subtasks = subtasks ?? [];

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
      'subtasks': subtasks.map((e) => e.toMap()).toList(),
    };
  }

  // Create a Task object from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    List<Subtask> subtasks;
    if (json['subtasks'] == null) {
      subtasks = [];
    } else {
      subtasks =
          (json['subtasks'] as List).map((e) => Subtask.fromMap(e)).toList();
    }

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
      subtasks: subtasks,
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
    return 'Task(id: $id, title: $title, description: $description, isCompleted: $isCompleted, deadline: $deadline, color: $color, recurringDays: $recurringDays, subtasks: $subtasks)';
  }
}
