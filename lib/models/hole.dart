import 'hole_scorecard.dart';

/// Ein physisches Loch (1–9) des 9-Loch-Turnierplatzes. [title]/[text] sind
/// seit 18.09.2026 dreisprachig (de/en/nl) gepflegt (Nutzerwunsch, siehe
/// PFLICHTENHEFT.md Abschnitt 8/18) – Quelltexte weiterhin Deutsch
/// (golfclub-winterberg.de), EN/NL sind sinngemäße Übersetzungen.
class Hole {
  final int n;
  final Map<String, String> title;
  final Map<String, String> text;
  final String refImage;
  final HoleScorecard? scorecard;

  const Hole({
    required this.n,
    required this.title,
    required this.text,
    required this.refImage,
    required this.scorecard,
  });

  /// Fallback-Kette wie bei LocaleService.t(): gewünschte Sprache -> Deutsch.
  String titleFor(String lang) => title[lang] ?? title['de']!;
  String textFor(String lang) => text[lang] ?? text['de']!;
}
