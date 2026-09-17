import 'package:flutter/material.dart';

import 'golf_palette.dart';

/// Zentrales Theme der App (Standard-Vorgabe: Material 3, ein `ThemeData` in
/// `lib/theme/app_theme.dart`). Übernimmt die Farb-/Typo-Sprache der
/// bisherigen Vanilla-JS-App (siehe [GolfPalette]): warmes Creme als
/// Hintergrund, dunkles Grün als Primärfarbe, Gold als Akzent, Manrope als
/// Fließtext-Schrift, Cormorant Garamond für Überschriften/große Zahlen.
///
/// Beide Schriften liegen als lokale Assets unter `assets/fonts/` und werden
/// über `pubspec.yaml` gebündelt (statt per `google_fonts`-Paket zur
/// Laufzeit von Googles CDN geladen zu werden) – das erste Deploy zeigte auf
/// mobilen Verbindungen einen sichtbaren Fallback-auf-Systemschrift-Moment,
/// solange der externe Font-Download noch lief.
class AppTheme {
  AppTheme._();

  static const String _bodyFont = 'Manrope';
  static const String _displayFontFamily = 'Cormorant Garamond';

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: GolfPalette.green,
      brightness: Brightness.light,
      primary: GolfPalette.green,
      secondary: GolfPalette.goldDeep,
      surface: GolfPalette.surface,
      error: GolfPalette.danger,
    );

    final baseTextTheme = Typography.material2021(platform: TargetPlatform.android)
        .black
        .apply(fontFamily: _bodyFont);

    TextStyle? display(TextStyle? style, FontWeight weight) =>
        style?.copyWith(fontFamily: _displayFontFamily, fontWeight: weight);

    final textTheme = baseTextTheme.copyWith(
      displayLarge: display(baseTextTheme.displayLarge, FontWeight.w700),
      displayMedium: display(baseTextTheme.displayMedium, FontWeight.w700),
      displaySmall: display(baseTextTheme.displaySmall, FontWeight.w700),
      headlineLarge: display(baseTextTheme.headlineLarge, FontWeight.w700),
      headlineMedium: display(baseTextTheme.headlineMedium, FontWeight.w700),
      headlineSmall: display(baseTextTheme.headlineSmall, FontWeight.w600),
      titleLarge: display(baseTextTheme.titleLarge, FontWeight.w600),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: GolfPalette.bg,
      fontFamily: _bodyFont,
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
