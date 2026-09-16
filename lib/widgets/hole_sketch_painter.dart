// CustomPainter-Nachbau von `holeSketchSVG()` aus js/app.js (Zeilen
// 170-222) – exakt dieselbe Layer-Reihenfolge und Geometrie, nur als
// Flutter-`Canvas`-Zeichnung statt SVG-String. Die Pfad-Strings selbst
// kommen unverändert aus lib/content/hole_sketch_defs.dart und werden
// zur Laufzeit mit `path_drawing` geparst – so bleibt die Fairway-Kontur
// geometrisch identisch zum Original, ohne sie manuell in
// Path.cubicTo-Aufrufe zu übersetzen.
//
// Bewusst unverändert 1:1 portierter Stil (siehe hole_sketch_defs.dart) –
// ein späteres Redesign betrifft nur diese Datei, nicht die Geometrie-Daten.

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../models/hole_sketch_def.dart';
import '../theme/golf_palette.dart';

/// Referenz-Koordinatensystem, identisch zum `viewBox="0 0 180 230"` der
/// bisherigen SVG-Skizzen.
const double kSketchViewBoxWidth = 180;
const double kSketchViewBoxHeight = 230;

class HoleSketchPainter extends CustomPainter {
  final HoleSketchDef def;

  HoleSketchPainter(this.def);

  // Feste "Rough"-Punktwolke links/rechts/oben, unabhängig vom Loch
  // (identisch zu den <circle>-Elementen in holeSketchSVG()).
  static const List<_Dot> _roughDots = [
    _Dot(44, 30, 7),
    _Dot(38, 26, 4.5),
    _Dot(36, 55, 5),
    _Dot(32, 85, 7),
    _Dot(26, 81, 4),
    _Dot(34, 115, 6),
    _Dot(40, 145, 6),
    _Dot(36, 170, 5),
    _Dot(40, 195, 6),
    _Dot(34, 199, 4),
    _Dot(130, 30, 6),
    _Dot(138, 55, 5),
    _Dot(144, 51, 4),
    _Dot(142, 85, 6),
    _Dot(140, 115, 7),
    _Dot(146, 111, 4.2),
    _Dot(134, 145, 7),
    _Dot(138, 170, 5),
    _Dot(132, 195, 5),
    _Dot(100, 10, 6),
    _Dot(70, 10, 6),
  ];

  static const List<List<double>> _bunkerDotOffsets = [
    [-0.5, 0.1],
    [-0.15, -0.4],
    [0.25, 0.3],
    [0.5, -0.15],
    [0.05, 0.45],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / kSketchViewBoxWidth, size.height / kSketchViewBoxHeight);

    final fairwayPath = parseSvgPathData(def.fairwayPath);
    final tee = _teeFromPathStart(def.fairwayPath);

    _paintRoughDots(canvas);
    _paintFairway(canvas, fairwayPath);
    _paintMowStripes(canvas, fairwayPath);
    if (def.water != null) _paintWater(canvas, def.water!);
    for (final bunker in def.bunkers) {
      _paintBunker(canvas, bunker);
    }
    _paintGreen(canvas, def.green);
    _paintFlagBaseDot(canvas, def.flag);
    _paintTeeMarkers(canvas, tee);
    _paintFlag(canvas, def.flag);

    canvas.restore();
  }

  void _paintRoughDots(Canvas canvas) {
    final paint = Paint()
      ..color = GolfPalette.rough.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    for (final d in _roughDots) {
      canvas.drawCircle(Offset(d.x, d.y), d.r, paint);
    }
  }

  void _paintFairway(Canvas canvas, Path fairwayPath) {
    final fill = Paint()
      ..color = GolfPalette.fairway
      ..style = PaintingStyle.fill;
    canvas.drawPath(fairwayPath, fill);
    final stroke = Paint()
      ..color = GolfPalette.fairwayStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(fairwayPath, stroke);
  }

  void _paintMowStripes(Canvas canvas, Path fairwayPath) {
    canvas.save();
    canvas.clipPath(fairwayPath);
    final paint = Paint()
      ..color = GolfPalette.rough.withValues(alpha: 0.1)
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;
    for (double y = -60; y < 280; y += 42) {
      canvas.drawLine(Offset(-20, y), Offset(200, y - 60), paint);
    }
    canvas.restore();
  }

  void _paintWater(Canvas canvas, EllipseDef water) {
    final rect = Rect.fromCenter(
      center: Offset(water.cx, water.cy),
      width: water.rx * 2,
      height: water.ry * 2,
    );
    final gradient = RadialGradient(
      center: const Alignment(-0.2, -0.4), // ~ cx 40% cy 30% des BoundingBox
      radius: 0.8,
      colors: [GolfPalette.waterGradInner, GolfPalette.water],
    );
    final fill = Paint()..shader = gradient.createShader(rect);
    canvas.drawOval(rect, fill);
    final stroke = Paint()
      ..color = GolfPalette.waterStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawOval(rect, stroke);

    final wavePaint = Paint()
      ..color = GolfPalette.waterWave.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    final cx = water.cx, cy = water.cy, rx = water.rx, ry = water.ry;
    final wave1 = Path()
      ..moveTo(cx - rx * 0.55, cy - ry * 0.15)
      ..cubicTo(
        cx - rx * 0.2, cy - ry * 0.4,
        cx + rx * 0.15, cy - ry * 0.4,
        cx + rx * 0.5, cy - ry * 0.1,
      );
    final wave2 = Path()
      ..moveTo(cx - rx * 0.4, cy + ry * 0.2)
      ..cubicTo(
        cx - rx * 0.1, cy,
        cx + rx * 0.25, cy,
        cx + rx * 0.55, cy + ry * 0.25,
      );
    canvas.drawPath(wave1, wavePaint);
    canvas.drawPath(wave2, wavePaint);
  }

  void _paintBunker(Canvas canvas, EllipseDef bunker) {
    final rect = Rect.fromCenter(
      center: Offset(bunker.cx, bunker.cy),
      width: bunker.rx * 2,
      height: bunker.ry * 2,
    );
    final fill = Paint()
      ..color = GolfPalette.sand
      ..style = PaintingStyle.fill;
    canvas.drawOval(rect, fill);
    final stroke = Paint()
      ..color = GolfPalette.bunkerStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawOval(rect, stroke);

    final arcPaint = Paint()
      ..color = GolfPalette.bunkerStroke.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final arcStart = Offset(bunker.cx - bunker.rx * 0.6, bunker.cy - bunker.ry * 0.3);
    final arcEnd = Offset(bunker.cx + bunker.rx * 0.6, bunker.cy - bunker.ry * 0.2);
    final arcPath = Path()
      ..moveTo(arcStart.dx, arcStart.dy)
      ..arcToPoint(
        arcEnd,
        radius: Radius.elliptical(bunker.rx * 0.8, bunker.ry * 0.6),
        clockwise: true,
      );
    canvas.drawPath(arcPath, arcPaint);

    final dotPaint = Paint()
      ..color = GolfPalette.bunkerStroke.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;
    for (final o in _bunkerDotOffsets) {
      canvas.drawCircle(
        Offset(bunker.cx + o[0] * bunker.rx, bunker.cy + o[1] * bunker.ry),
        0.9,
        dotPaint,
      );
    }
  }

  void _paintGreen(Canvas canvas, EllipseDef green) {
    final haloRect = Rect.fromCenter(
      center: Offset(green.cx, green.cy),
      width: green.rx * 2 * 1.25,
      height: green.ry * 2 * 1.25,
    );
    canvas.drawOval(
      haloRect,
      Paint()
        ..color = GolfPalette.rough.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );

    final rect = Rect.fromCenter(
      center: Offset(green.cx, green.cy),
      width: green.rx * 2,
      height: green.ry * 2,
    );
    canvas.drawOval(
      rect,
      Paint()
        ..color = GolfPalette.greenFill
        ..style = PaintingStyle.fill,
    );
    canvas.drawOval(
      rect,
      Paint()
        ..color = GolfPalette.greenStroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _paintFlagBaseDot(Canvas canvas, PointDef flag) {
    canvas.drawCircle(
      Offset(flag.x - 4, flag.y + 15),
      1.3,
      Paint()..color = GolfPalette.flagBaseDot,
    );
  }

  void _paintTeeMarkers(Canvas canvas, Offset tee) {
    final goldRect = Rect.fromCenter(
      center: Offset(tee.dx - 6, tee.dy - 2),
      width: 2.6 * 2,
      height: 1.7 * 2,
    );
    canvas.drawOval(goldRect, Paint()..color = GolfPalette.gold);

    final ivoryRect = Rect.fromCenter(
      center: Offset(tee.dx + 6, tee.dy - 2),
      width: 2.6 * 2,
      height: 1.7 * 2,
    );
    canvas.drawOval(ivoryRect, Paint()..color = GolfPalette.teeIvory);
    canvas.drawOval(
      ivoryRect,
      Paint()
        ..color = GolfPalette.teeIvoryStroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
  }

  void _paintFlag(Canvas canvas, PointDef flag) {
    canvas.drawLine(
      Offset(flag.x, flag.y + 22),
      Offset(flag.x, flag.y),
      Paint()
        ..color = GolfPalette.ink
        ..strokeWidth = 1.5,
    );
    final pennant = Path()
      ..moveTo(flag.x, flag.y)
      ..lineTo(flag.x + 14, flag.y + 5)
      ..lineTo(flag.x, flag.y + 10)
      ..close();
    canvas.drawPath(pennant, Paint()..color = GolfPalette.red);
  }

  /// Liest den Tee-Punkt aus dem `M x y`-Beginn des Fairway-Pfads – analog
  /// zum Regex `/^M\s*([\d.]+)[\s,]+([\d.]+)/` in js/app.js.
  static Offset _teeFromPathStart(String svgPath) {
    final match = RegExp(r'^\s*M\s*([\d.]+)[\s,]+([\d.]+)').firstMatch(svgPath);
    if (match == null) return const Offset(90, 18);
    return Offset(
      double.parse(match.group(1)!),
      double.parse(match.group(2)!),
    );
  }

  @override
  bool shouldRepaint(covariant HoleSketchPainter oldDelegate) =>
      oldDelegate.def != def;
}

class _Dot {
  final double x;
  final double y;
  final double r;

  const _Dot(this.x, this.y, this.r);
}
