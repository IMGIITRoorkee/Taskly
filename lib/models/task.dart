class Task {
  String title;
  String description;
  bool isCompleted;

  Task({required this.title, this.description = '', this.isCompleted = false});

  set setTitle(String t) {
    title = t;
  }

  set setDescription(String d) {
    description = d;
  }

  void updateTask(Task task) {
    setTitle = task.title;
    setDescription = task.description;

    //update more properties (like color, due date etc)
  }

  // Convert a Task object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  // Create a Task object from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
    );
  }
}
