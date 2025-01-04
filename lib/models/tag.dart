import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class Tag {
  String title;
  Color color;

  Tag({
    required this.title,
    Color? color,
  }) : color = color ??
            Colors.primaries[Random().nextInt(Colors.primaries.length)];

  Tag copyWith({
    String? title,
    Color? color,
  }) {
    return Tag(
      title: title ?? this.title,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'color': color.value,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      title: map['title'] ?? '',
      color: map['color'] != null ? Color(map['color']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Tag.fromJson(String source) => Tag.fromMap(json.decode(source));

  @override
  String toString() => 'Tag(title: $title, color: $color)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tag && other.title == title;
  }

  @override
  int get hashCode => title.hashCode ^ color.hashCode;
}
