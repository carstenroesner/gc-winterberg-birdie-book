// Prüft die Swipe-Aktionen (Versenden/Löschen) in "Bestehende Runden":
// nach Wischen nach links (Drag) erscheinen die beiden erwarteten Aktionen
// mit korrektem Label. flutter_slidable baut den Inhalt der Action-Pane
// erst, wenn sie tatsächlich geöffnet ist (nicht permanent im Baum) – die
// Geste muss daher wirklich simuliert werden. Die eigentliche
// Lösch-/PDF-Logik ist eigenständig in rounds_service_test.dart bzw.
// scorecard_pdf_service_test.dart abgedeckt.

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

  testWidgets('jede gespeicherte Runde trägt ein Slidable', (tester) async {
    final locale = LocaleService();
    final rounds = RoundsService();
    await locale.load();
    await rounds.load();
    await rounds.createNewRound();
    await rounds.createNewRound();

    await tester.pumpWidget(_wrap(locale, rounds));
    await tester.pumpAndSettle();

    expect(find.byType(Slidable), findsNWidgets(2));
  });

  testWidgets('Wischen nach links enthüllt Versenden- und Löschen-Aktion', (tester) async {
    final locale = LocaleService();
    final rounds = RoundsService();
    await locale.load();
    await rounds.load();
    await rounds.createNewRound();

    await tester.pumpWidget(_wrap(locale, rounds));
    await tester.pumpAndSettle();

    // Vor dem Wischen ist die Action-Pane noch nicht aufgebaut.
    expect(find.text('Versenden'), findsNothing);
    expect(find.text('Löschen'), findsNothing);

    await tester.drag(find.byType(Slidable), const Offset(-300, 0));
    await tester.pumpAndSettle();

    expect(find.text('Versenden'), findsOneWidget);
    expect(find.text('Löschen'), findsOneWidget);
  });
}
