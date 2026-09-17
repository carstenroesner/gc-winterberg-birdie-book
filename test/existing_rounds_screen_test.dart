// Prüft die Swipe-Aktionen (Versenden/Löschen) in "Bestehende Runden":
// jede Runde ist in ein Slidable gewrappt und trägt die beiden erwarteten
// Aktionen. Die eigentliche Wisch-Geste wird hier bewusst NICHT simuliert
// (fragiler Drag-Gesture-Test ohne lokale Flutter-Tooling schwer
// verifizierbar) – stattdessen wird geprüft, dass die Aktionen mit
// korrektem Label im Widget-Baum vorhanden sind. Die eigentliche
// Lösch-/PDF-Logik ist in rounds_service_test.dart bzw.
// scorecard_pdf_service_test.dart eigenständig (und ohne Gesture-Risiko)
// abgedeckt.

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gc_winterberg_birdie_book/screens/existing_rounds_screen.dart';
import 'package:gc_winterberg_birdie_book/services/locale_service.dart';
import 'package:gc_winterberg_birdie_book/services/rounds_service.dart';

Widget _wrap(LocaleService locale, RoundsService rounds) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LocaleService>.value(value: locale),
      ChangeNotifierProvider<RoundsService>.value(value: rounds),
    ],
    child: const MaterialApp(home: ExistingRoundsScreen()),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('jede gespeicherte Runde trägt ein Slidable mit Versenden-/Löschen-Aktion',
      (tester) async {
    final locale = LocaleService();
    final rounds = RoundsService();
    await locale.load();
    await rounds.load();
    await rounds.createNewRound();
    await rounds.createNewRound();

    await tester.pumpWidget(_wrap(locale, rounds));
    await tester.pumpAndSettle();

    expect(find.byType(Slidable), findsNWidgets(2));
    expect(find.text('Versenden'), findsNWidgets(2));
    expect(find.text('Löschen'), findsNWidgets(2));
  });
}
