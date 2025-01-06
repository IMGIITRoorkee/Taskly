class Kudos {
  int score;
  List<List<String>> history;

  Kudos({required this.score, required this.history});

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'history': history,
    };
  }

  factory Kudos.fromJson(Map<String, dynamic> json) {
    return Kudos(
      score: json['score'],
      history: (json['history'] as List)
          .map((item) => List<String>.from(item as List))
          .toList(),
    );
  }
}
