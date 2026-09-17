/// Werte, die je nach Platzhälfte (vordere/hintere 9) unterschiedlich sind
/// (z. B. HCP oder Distanz für Loch n vorne vs. Loch n+9 hinten).
class SideValues {
  final int front;
  final int back;

  const SideValues({required this.front, required this.back});
}

/// Scorecard-Referenzdaten eines Lochs (Par, HCP, Abschlagsdistanzen).
/// Liegt seit dem 17.09.2026 für alle 9 Bahnen vollständig vor (Quelle:
/// Platzausschilderung, siehe PFLICHTENHEFT.md). Bleibt nullable auf
/// `Hole.scorecard`, falls künftig weitere Bahnen hinzukommen sollten, deren
/// Daten noch nicht erfasst sind.
class HoleScorecard {
  final int par;
  final SideValues hcp;
  final SideValues herren;
  final SideValues damen;

  const HoleScorecard({
    required this.par,
    required this.hcp,
    required this.herren,
    required this.damen,
  });
}
