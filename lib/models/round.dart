/// Eine gespielte/laufende Runde. [scores] verwendet exakt das Schlüssel-
/// Format der bisherigen App: `"front-<n>"` bzw. `"back-<n>"` (n = 1..9).
/// [date] wird als reines Datum (ohne Uhrzeit) gespeichert, analog zum
/// bisherigen ISO-Datumsstring.
class Round {
  final String id;
  final DateTime date;
  final int holeCount;
  final Map<String, int> scores;

  const Round({
    required this.id,
    required this.date,
    required this.holeCount,
    required this.scores,
  });

  Round copyWith({int? holeCount, Map<String, int>? scores}) {
    return Round(
      id: id,
      date: date,
      holeCount: holeCount ?? this.holeCount,
      scores: scores ?? this.scores,
    );
  }

  static String scoreKey({required bool isBack, required int n}) =>
      '${isBack ? 'back' : 'front'}-$n';

  Map<String, dynamic> toJson() => {
        'id': id,
        'date':
            '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'holeCount': holeCount,
        'scores': scores,
      };

  factory Round.fromJson(Map<String, dynamic> json) {
    final rawScores = (json['scores'] as Map).cast<String, dynamic>();
    return Round(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      holeCount: json['holeCount'] as int,
      scores: rawScores.map((k, v) => MapEntry(k, v as int)),
    );
  }
}
