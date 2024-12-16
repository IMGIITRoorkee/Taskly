import 'dart:convert';

class Tip {
  String content;
  String author;
  Tip({
    required this.content,
    required this.author,
  });

  Tip copyWith({
    String? content,
    String? author,
  }) {
    return Tip(
      content: content ?? this.content,
      author: author ?? this.author,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'author': author,
    };
  }

  factory Tip.fromMap(Map<String, dynamic> map) {
    return Tip(
      content: map['content'] ?? '',
      author: map['author'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Tip.fromJson(String source) => Tip.fromMap(json.decode(source));

  @override
  String toString() => 'Tip(content: $content, author: $author)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tip && other.content == content && other.author == author;
  }

  @override
  int get hashCode => content.hashCode ^ author.hashCode;
}
