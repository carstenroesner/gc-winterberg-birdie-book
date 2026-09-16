/// Eine Ellipse (cx, cy, rx, ry) – Datentyp für Wasser-/Bunker-/Grün-Formen
/// innerhalb einer Lochskizze. Entspricht 1:1 den `{cx,cy,rx,ry}`-Objekten
/// aus `HOLE_SKETCH_DEFS` in der bisherigen `js/app.js`.
class EllipseDef {
  final double cx;
  final double cy;
  final double rx;
  final double ry;

  const EllipseDef({
    required this.cx,
    required this.cy,
    required this.rx,
    required this.ry,
  });
}

/// Ein Punkt (x, y) – für die Fahnenposition.
class PointDef {
  final double x;
  final double y;

  const PointDef({required this.x, required this.y});
}

/// Geometrie-Daten für die Illustration eines Lochs (Loch 1–9). Bewusst
/// getrennt vom Zeichen-Stil (siehe `hole_sketch_painter.dart`), damit ein
/// künftiges Redesign nur den Zeichen-Layer betrifft, nicht dieses
/// Datenmodell (siehe PFLICHTENHEFT.md, offene Design-Runde zur
/// Lochskizzen-Optik).
///
/// [fairwayPath] ist ein SVG-Pfad-`d`-String (kubische Bézierkurven,
/// Koordinatenraum viewBox "0 0 180 230"), zeichengenau aus
/// `HOLE_SKETCH_DEFS` übernommen. Der erste `M x y`-Punkt dieses Strings
/// dient zugleich als Abschlagposition (siehe `teeFromFairwayPath()` in
/// `hole_sketch_painter.dart`, analog zur Regex-Extraktion in der
/// bisherigen JS-Implementierung).
class HoleSketchDef {
  final String fairwayPath;
  final EllipseDef? water;
  final List<EllipseDef> bunkers;
  final EllipseDef green;
  final PointDef flag;

  const HoleSketchDef({
    required this.fairwayPath,
    required this.water,
    required this.bunkers,
    required this.green,
    required this.flag,
  });
}
