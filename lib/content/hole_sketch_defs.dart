// Geometrie-Daten der 9 Lochskizzen. Die fairwayPath-Strings sind
// zeichengenau (character-for-character) aus HOLE_SKETCH_DEFS in
// js/app.js der bisherigen Vanilla-JS-App übernommen – siehe
// hole_sketch_painter.dart für das (davon getrennte) Rendering.
//
// Achtung: Dieser Stil wurde vom Nutzer am 15.09.2026 als "nicht
// attraktiv genug" kritisiert (zu klein, zu verspielt/geschwungen,
// gewünscht: taktische Karte, bildschirmfüllend, gedreht mit Grün oben/
// Abschlag unten). Eine Redesign-Entscheidung läuft aktuell separat in
// einem Design Canvas (bisher nur für Loch 2 exploriert) und ist noch
// nicht final. Dieser Datensatz wird bewusst unverändert 1:1 portiert,
// damit die Migration nicht auf die Stil-Entscheidung wartet – ein
// späterer Redesign betrifft nur den Painter, nicht diese Datei.

import '../models/hole_sketch_def.dart';

const Map<int, HoleSketchDef> holeSketchDefs = {
  1: HoleSketchDef(
    fairwayPath:
        'M96 20 C 122 44, 118 78, 96 104 C 78 126, 58 140, 62 172 C 64 192, 78 206, 82 220 L 56 220 C 50 200, 40 188, 44 164 C 50 128, 76 112, 88 84 C 96 62, 78 40, 68 22 Z',
    water: EllipseDef(cx: 132, cy: 96, rx: 26, ry: 34),
    bunkers: [],
    green: EllipseDef(cx: 70, cy: 210, rx: 22, ry: 15),
    flag: PointDef(x: 64, y: 190),
  ),
  2: HoleSketchDef(
    fairwayPath:
        'M90 18 C 128 30, 130 60, 100 76 C 66 94, 56 116, 92 130 C 124 142, 128 168, 96 188 C 80 198, 78 210, 84 222 L 54 222 C 48 206, 52 194, 66 182 C 92 160, 86 140, 58 126 C 30 112, 30 84, 64 66 C 90 52, 86 34, 66 22 Z',
    water: EllipseDef(cx: 46, cy: 36, rx: 18, ry: 14),
    bunkers: [EllipseDef(cx: 118, cy: 98, rx: 14, ry: 9)],
    green: EllipseDef(cx: 86, cy: 212, rx: 18, ry: 13),
    flag: PointDef(x: 80, y: 195),
  ),
  3: HoleSketchDef(
    fairwayPath:
        'M92 60 C 112 76, 112 100, 92 118 C 76 132, 74 150, 88 168 L 62 168 C 50 150, 52 132, 68 118 C 84 104, 84 82, 66 68 Z',
    water: null,
    bunkers: [EllipseDef(cx: 118, cy: 140, rx: 11, ry: 8)],
    green: EllipseDef(cx: 78, cy: 158, rx: 22, ry: 15),
    flag: PointDef(x: 72, y: 140),
  ),
  4: HoleSketchDef(
    fairwayPath:
        'M84 18 C 108 40, 114 66, 100 92 C 88 114, 86 132, 96 150 L 66 150 C 58 132, 60 114, 72 94 C 84 74, 78 46, 58 26 Z',
    water: EllipseDef(cx: 80, cy: 172, rx: 38, ry: 16),
    bunkers: [],
    green: EllipseDef(cx: 80, cy: 208, rx: 20, ry: 13),
    flag: PointDef(x: 74, y: 190),
  ),
  5: HoleSketchDef(
    fairwayPath:
        'M92 20 C 100 60, 96 100, 90 140 C 86 168, 84 196, 90 222 L 60 222 C 56 196, 58 168, 64 140 C 70 100, 72 60, 64 22 Z',
    water: null,
    bunkers: [EllipseDef(cx: 126, cy: 132, rx: 18, ry: 12)],
    green: EllipseDef(cx: 76, cy: 210, rx: 20, ry: 14),
    flag: PointDef(x: 70, y: 192),
  ),
  6: HoleSketchDef(
    fairwayPath:
        'M90 16 C 96 56, 92 96, 90 136 C 88 168, 90 196, 96 222 L 58 222 C 54 196, 56 168, 58 136 C 60 96, 62 56, 58 18 Z',
    water: EllipseDef(cx: 74, cy: 34, rx: 22, ry: 12),
    bunkers: [
      EllipseDef(cx: 44, cy: 196, rx: 14, ry: 9),
      EllipseDef(cx: 112, cy: 200, rx: 14, ry: 9),
    ],
    green: EllipseDef(cx: 78, cy: 210, rx: 20, ry: 13),
    flag: PointDef(x: 72, y: 192),
  ),
  7: HoleSketchDef(
    fairwayPath:
        'M96 18 C 70 40, 66 66, 88 84 C 110 100, 108 122, 82 138 C 60 150, 56 172, 74 192 L 100 192 C 108 174, 100 158, 82 146 C 64 134, 66 116, 90 100 C 112 84, 114 58, 94 36 Z',
    water: EllipseDef(cx: 88, cy: 118, rx: 34, ry: 9),
    bunkers: [
      EllipseDef(cx: 66, cy: 176, rx: 12, ry: 8),
      EllipseDef(cx: 104, cy: 180, rx: 12, ry: 8),
    ],
    green: EllipseDef(cx: 86, cy: 186, rx: 20, ry: 13),
    flag: PointDef(x: 80, y: 168),
  ),
  8: HoleSketchDef(
    fairwayPath:
        'M90 20 C 94 60, 90 100, 92 140 C 94 168, 92 196, 90 220 L 60 220 C 58 196, 60 168, 58 140 C 56 100, 60 60, 56 22 Z',
    water: null,
    bunkers: [
      EllipseDef(cx: 36, cy: 196, rx: 14, ry: 10),
      EllipseDef(cx: 120, cy: 196, rx: 14, ry: 10),
    ],
    green: EllipseDef(cx: 76, cy: 206, rx: 22, ry: 13),
    flag: PointDef(x: 70, y: 188),
  ),
  9: HoleSketchDef(
    fairwayPath:
        'M92 22 C 100 50, 98 78, 88 102 C 80 122, 80 144, 92 162 L 64 162 C 54 144, 54 122, 62 102 C 70 78, 68 50, 60 24 Z',
    water: null,
    bunkers: [EllipseDef(cx: 42, cy: 148, rx: 11, ry: 8)],
    green: EllipseDef(cx: 78, cy: 154, rx: 20, ry: 13),
    flag: PointDef(x: 72, y: 136),
  ),
};

/// Liefert die Skizzen-Geometrie für die physische Lochnummer (1..9)
/// unabhängig davon, ob vorne (n) oder hinten (n+9) gespielt wird.
HoleSketchDef holeSketchForPhysicalNumber(int physicalN) =>
    holeSketchDefs[((physicalN - 1) % 9) + 1]!;
