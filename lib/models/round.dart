/// Eine gespielte/laufende Runde. [scores] verwendet exakt das Schlüssel-
/// Format der bisherigen App: `"front-<n>"` bzw. `"back-<n>"` (n = 1..9).
/// [date] wird als reines Datum (ohne Uhrzeit) gespeichert, analog zum
/// bisherigen ISO-Datumsstring.
///
/// [weatherTempC]/[weatherCode]/[weatherWindKph] sind seit 18.09.2026
/// (Nutzerwunsch, siehe PFLICHTENHEFT.md Abschnitt 8/18) ein einmaliger,
/// unveränderlicher "Schnappschuss" der Wetterbedingungen zum Zeitpunkt des
/// Rundenanlegens (siehe RoundsService/WeatherService) – `null`, solange
/// der Abruf noch läuft oder fehlgeschlagen ist (z. B. offline).
class Round {
  final String id;
  final DateTime date;
  final int holeCount;
  final Map<String, int> scores;
  final double? weatherTempC;
  final int? weatherCode;
  final double? weatherWindKph;

  const Round({
    required this.id,
    required this.date,
    required this.holeCount,
    required this.scores,
    this.weatherTempC,
    this.weatherCode,
    this.weatherWindKph,
  });

  Round copyWith({int? holeCount, Map<String, int>? scores}) {
    return Round(
      id: id,
      date: date,
      holeCount: holeCount ?? this.holeCount,
      scores: scores ?? this.scores,
      weatherTempC: weatherTempC,
      weatherCode: weatherCode,
      weatherWindKph: weatherWindKph,
    );
  }

  /// Setzt einmalig die automatisch abgerufenen Wetterdaten (siehe
  /// RoundsService._fetchWeatherFor).
  Round copyWithWeather({
    required double weatherTempC,
    required int weatherCode,
    required double weatherWindKph,
  }) {
    return Round(
      id: id,
      date: date,
      holeCount: holeCount,
      scores: scores,
      weatherTempC: weatherTempC,
      weatherCode: weatherCode,
      weatherWindKph: weatherWindKph,
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
        if (weatherTempC != null) 'weatherTempC': weatherTempC,
        if (weatherCode != null) 'weatherCode': weatherCode,
        if (weatherWindKph != null) 'weatherWindKph': weatherWindKph,
      };

  factory Round.fromJson(Map<String, dynamic> json) {
    final rawScores = (json['scores'] as Map).cast<String, dynamic>();
    return Round(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      holeCount: json['holeCount'] as int,
      scores: rawScores.map((k, v) => MapEntry(k, v as int)),
      weatherTempC: (json['weatherTempC'] as num?)?.toDouble(),
      weatherCode: (json['weatherCode'] as num?)?.toInt(),
      weatherWindKph: (json['weatherWindKph'] as num?)?.toDouble(),
    );
  }
}
