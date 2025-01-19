import 'dart:convert';

class Subtask {
  String title;
  bool isCompleted;
  Subtask({
    required this.title,
    required this.isCompleted,
  });

  Subtask copyWith({
    String? title,
    bool? isCompleted,
  }) {
    return Subtask(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory Subtask.fromMap(Map<String, dynamic> map) {
    return Subtask(
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Subtask.fromJson(String source) =>
      Subtask.fromMap(json.decode(source));

  @override
  String toString() => 'Subtask(title: $title, isCompleted: $isCompleted)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Subtask && other.title == title;
  }

  @override
  int get hashCode => title.hashCode;
}
