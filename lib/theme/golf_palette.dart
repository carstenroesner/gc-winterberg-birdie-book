import 'package:flutter/material.dart';

/// Design-Tokens der bisherigen Vanilla-JS-App (css/styles.css), aus OKLCH
/// nach sRGB-Hex konvertiert (Björn Ottosson OKLab-Formel). Jeder Wert trägt
/// den ursprünglichen OKLCH-String als Kommentar zur Nachvollziehbarkeit.
///
/// Diese Farben ergänzen das Material-3-`ColorScheme` aus [AppTheme] – sie
/// werden vor allem für die Lochskizzen-Illustration (siehe
/// `hole_sketch_painter.dart`) sowie einzelne Akzent-/Statusfarben benötigt,
/// die sich nicht 1:1 in ein `ColorScheme.fromSeed` einordnen lassen.
class GolfPalette {
  GolfPalette._();

  static const Color bg = Color(0xFFF7F5EC); // oklch(97% 0.012 95)
  static const Color surface = Color(0xFFFCFCF9); // oklch(99% 0.004 95)
  static const Color ink = Color(0xFF132419); // oklch(24% 0.03 155)
  static const Color inkSoft = Color(0xFF556159); // oklch(48% 0.02 155)
  static const Color inkFaint = Color(0xFFA19E94); // oklch(70% 0.015 95)
  static const Color green = Color(0xFF0F4025); // oklch(33% 0.07 155)
  static const Color green2 = Color(0xFF225A39); // oklch(42% 0.08 155)
  static const Color fairway = Color(0xFFB7E5BF); // oklch(88% 0.07 150)
  static const Color rough = Color(0xFF4B8358); // oklch(56% 0.09 150)
  static const Color sand = Color(0xFFDDCCA9); // oklch(85% 0.05 85)
  static const Color gold = Color(0xFFD1A255); // oklch(74% 0.11 78)
  static const Color goldDeep = Color(0xFF9E6800); // oklch(56% 0.12 74)
  static const Color red = Color(0xFFC74B43); // oklch(58% 0.16 27)
  static const Color yellow = Color(0xFFE4C64F); // oklch(83% 0.14 95)
  static const Color line = Color(0xFFE0DED5); // oklch(90% 0.012 95)
  static const Color rowAlt = Color(0xFFF4F2EA); // oklch(96% 0.01 95)
  static const Color chip = Color(0xFFE3F4E6); // oklch(95% 0.025 150)
  static const Color danger = Color(0xFFC53637); // oklch(55% 0.18 25)
  static const Color water = Color(0xFF69AED5); // oklch(72% 0.09 235)

  // Zusätzliche, nur innerhalb der Lochskizzen-Illustration verwendete Töne
  // (aus holeSketchSVG() in js/app.js übernommen).
  static const Color fairwayStroke = Color(0xFF79A582); // oklch(68% 0.07 150)
  static const Color waterStroke = Color(0xFF3383AD); // oklch(58% 0.1 235)
  static const Color waterWave = Color(0xFFC9E3EC); // oklch(90% 0.03 220)
  static const Color waterGradInner = Color(0xFF7BC4DB); // oklch(78% 0.08 220)
  static const Color bunkerStroke = Color(0xFFA39068); // oklch(66% 0.06 85)
  static const Color greenFill = Color(0xFF94CF9F); // oklch(80% 0.09 150)
  static const Color greenStroke = Color(0xFF5C8E67); // oklch(60% 0.08 150)
  static const Color flagBaseDot = Color(0xFF2F5136); // oklch(40% 0.06 150)
  static const Color teeIvory = Color(0xFFF7F5EC); // oklch(97% 0.012 95)
  static const Color teeIvoryStroke = Color(0xFFA29F91); // oklch(70% 0.02 95)
}
