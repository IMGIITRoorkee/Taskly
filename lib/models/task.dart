import 'package:flutter/material.dart';

class Task {
  String title;
  String description;
  bool isCompleted;
  DateTime deadline;
  bool hasDeadline;
  Color color;
  double? lat;
  double? lng;

  Task({
    required this.title,
    this.description = '',
    this.isCompleted = false,
    DateTime? deadline,
    this.hasDeadline = false,
    this.color = Colors.blue,
    this.lat,
    this.lng,
  }) : deadline = deadline ?? DateTime.now();

  // Convert a Task object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'deadline': deadline.toIso8601String(),
      'hasDeadline': hasDeadline,
      'color': color.value,
      'lat': lat,
      'lng': lng,
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
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
