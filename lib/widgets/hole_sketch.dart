// Dünner Wrapper um HoleSketchPainter mit fester Seitenverhältnis-Box
// (150x190, wie im bisherigen `<svg width="150" height="190" ...>`).

import 'package:flutter/material.dart';

import '../content/hole_sketch_defs.dart';
import 'hole_sketch_painter.dart';

class HoleSketch extends StatelessWidget {
  final int physicalHoleNumber;

  const HoleSketch({super.key, required this.physicalHoleNumber});

  @override
  Widget build(BuildContext context) {
    final def = holeSketchForPhysicalNumber(physicalHoleNumber);
    return AspectRatio(
      aspectRatio: kSketchViewBoxWidth / kSketchViewBoxHeight,
      child: CustomPaint(
        painter: HoleSketchPainter(def),
        child: const SizedBox.expand(),
      ),
    );
  }
}
