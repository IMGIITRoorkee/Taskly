import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class Tag {
  String id;
  String title;
  Color color;

  Tag({
    Color? color,
    String? id,
    required this.title,
  })  : color = color ??
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
        id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Tag copyWith({
    String? id,
    String? title,
    Color? color,
  }) {
    return Tag(
      id: id ?? this.id,
      title: title ?? this.title,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'color': color.value,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      color: Color(map['color']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Tag.fromJson(String source) => Tag.fromMap(json.decode(source));

  @override
  String toString() => 'Tag(id: $id, title: $title, color: $color)';

  @override
  bool operator ==(Object other) {
    return other is Tag && other.id == id;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ color.hashCode;
}
