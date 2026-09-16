/// Werte, die je nach Platzhälfte (vordere/hintere 9) unterschiedlich sind
/// (z. B. HCP oder Distanz für Loch n vorne vs. Loch n+9 hinten).
class SideValues {
  final int front;
  final int back;

  const SideValues({required this.front, required this.back});
}

/// Scorecard-Referenzdaten eines Lochs (Par, HCP, Abschlagsdistanzen).
/// Nullable auf `Hole.scorecard`, da aktuell nur für Loch 2/11 echte Daten
/// vorliegen (siehe PFLICHTENHEFT.md) – für die übrigen 8 Löcher bewusst
/// `null`, nicht erfunden.
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
