// Boot-Smoke-Test: App startet, zeigt kurz den Splash (Init-Gate) und
// wechselt danach zum Startbildschirm. Testet zugleich die
// Splash-Timer-Stolperfalle (siehe PFLICHTENHEFT.md / Standard Abschnitt 5):
// `tester.pumpAndSettle()` allein reicht nicht, `pump(_splashMinDuration)`
// muss zuerst laufen, sonst bleibt ein Timer offen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gc_winterberg_birdie_book/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App zeigt zunächst den Splash und danach den Startbildschirm',
      (tester) async {
    await tester.pumpWidget(const GcwbbApp());

    // Direkt nach dem ersten Frame: Splash sichtbar (Init noch nicht fertig).
    expect(find.byIcon(Icons.golf_course), findsOneWidget);

    // Splash-Mindestdauer abwarten (siehe main.dart: _splashMinDuration),
    // danach erst pumpAndSettle - sonst bleibt der Future.delayed-Timer offen.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.golf_course), findsNothing);
    expect(find.text('Neue Runde'), findsOneWidget);
    expect(find.text('Bestehende Runden'), findsOneWidget);
  });

  testWidgets('Neue Runde führt in den Hauptbildschirm (Rundeneinstellungen zuerst)',
      (tester) async {
    await tester.pumpWidget(const GcwbbApp());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Neue Runde'));
    await tester.pumpAndSettle();

    expect(find.text('Rundeneinstellungen'), findsOneWidget);
  });
}
