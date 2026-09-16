import 'hole_scorecard.dart';

/// Ein physisches Loch (1–9) des 9-Loch-Turnierplatzes. Titel und
/// Charakteristik-Text sind bewusst nur auf Deutsch gepflegt (nicht Teil des
/// i18n-Systems) – siehe PFLICHTENHEFT.md.
class Hole {
  final int n;
  final String title;
  final String text;
  final String refImage;
  final HoleScorecard? scorecard;

  const Hole({
    required this.n,
    required this.title,
    required this.text,
    required this.refImage,
    required this.scorecard,
  });
}
