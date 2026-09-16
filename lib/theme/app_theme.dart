import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'golf_palette.dart';

/// Zentrales Theme der App (Standard-Vorgabe: Material 3, ein `ThemeData` in
/// `lib/theme/app_theme.dart`). Übernimmt die Farb-/Typo-Sprache der
/// bisherigen Vanilla-JS-App (siehe [GolfPalette]): warmes Creme als
/// Hintergrund, dunkles Grün als Primärfarbe, Gold als Akzent, Manrope als
/// Fließtext-Schrift, Cormorant Garamond für Überschriften/große Zahlen.
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: GolfPalette.green,
      brightness: Brightness.light,
      primary: GolfPalette.green,
      secondary: GolfPalette.goldDeep,
      surface: GolfPalette.surface,
      error: GolfPalette.danger,
    );

    final baseTextTheme = GoogleFonts.manropeTextTheme();
    final displayFont = GoogleFonts.cormorantGaramondTextTheme();

    final textTheme = baseTextTheme.copyWith(
      displayLarge: displayFont.displayLarge?.copyWith(fontWeight: FontWeight.w700),
      displayMedium: displayFont.displayMedium?.copyWith(fontWeight: FontWeight.w700),
      displaySmall: displayFont.displaySmall?.copyWith(fontWeight: FontWeight.w700),
      headlineLarge: displayFont.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
      headlineMedium: displayFont.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
      headlineSmall: displayFont.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
      titleLarge: displayFont.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: GolfPalette.bg,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: GolfPalette.bg,
        foregroundColor: GolfPalette.ink,
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: GolfPalette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: GolfPalette.line),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: GolfPalette.green,
          foregroundColor: GolfPalette.surface,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: GolfPalette.green,
          side: BorderSide(color: GolfPalette.green),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: GolfPalette.gold,
          selectedForegroundColor: GolfPalette.ink,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GolfPalette.rowAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: GolfPalette.line),
        ),
      ),
      dividerTheme: DividerThemeData(color: GolfPalette.line),
    );
  }
}
