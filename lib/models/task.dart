class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime deadline;
  bool hasDeadline;

  Task(
      {required this.title,
      this.description = '',
      this.isCompleted = false,
      DateTime? deadline,
      this.hasDeadline = false,
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
      id: json['id'],
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, isCompleted: $isCompleted, deadline: $deadline, hasDeadline: $hasDeadline)';
  }
}
