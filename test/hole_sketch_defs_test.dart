// Prüft, dass alle 9 Fairway-Pfadstrings aus hole_sketch_defs.dart
// fehlerfrei durch path_drawing geparst werden können (höchstes Risiko der
// Migration, siehe PFLICHTENHEFT.md – 1:1-Port der SVG-Pfade in Flutter
// Path-Objekte über `parseSvgPathData`).

import 'package:flutter_test/flutter_test.dart';
import 'package:path_drawing/path_drawing.dart';

import 'package:gc_winterberg_birdie_book/content/hole_sketch_defs.dart';

void main() {
  test('alle 9 Lochskizzen sind im Datensatz vorhanden', () {
    expect(holeSketchDefs.length, 9);
    for (var n = 1; n <= 9; n++) {
      expect(holeSketchDefs.containsKey(n), isTrue, reason: 'Loch $n fehlt');
    }
  });

  test('alle Fairway-Pfadstrings parsen fehlerfrei und ergeben eine Fläche', () {
    for (final entry in holeSketchDefs.entries) {
      final path = parseSvgPathData(entry.value.fairwayPath);
      final bounds = path.getBounds();
      expect(bounds.width, greaterThan(0), reason: 'Loch ${entry.key}: leere Breite');
      expect(bounds.height, greaterThan(0), reason: 'Loch ${entry.key}: leere Höhe');
    }
  });

  test('holeSketchForPhysicalNumber mappt vordere und hintere Neun auf dieselbe Bahn', () {
    for (var n = 1; n <= 9; n++) {
      expect(
        holeSketchForPhysicalNumber(n),
        same(holeSketchForPhysicalNumber(n + 9)),
      );
    }
  });
}
