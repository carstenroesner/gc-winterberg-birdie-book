// Prüft, dass die Scorecard-Seite nur für Loch 2/11 echte Referenzdaten
// zeigt und für die übrigen Löcher bewusst "–" anzeigt (siehe
// PFLICHTENHEFT.md – bekannte, akzeptierte Datenlücke, nicht zu erfinden).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gc_winterberg_birdie_book/services/locale_service.dart';
import 'package:gc_winterberg_birdie_book/services/rounds_service.dart';
import 'package:gc_winterberg_birdie_book/widgets/scorecard_page.dart';

Widget _wrap(Widget child, LocaleService locale, RoundsService rounds) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LocaleService>.value(value: locale),
      ChangeNotifierProvider<RoundsService>.value(value: rounds),
    ],
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Loch 2 zeigt echte Werte, Loch 1 zeigt "–"', (tester) async {
    final locale = LocaleService();
    final rounds = RoundsService();
    await locale.load();
    await rounds.load();
    await rounds.createNewRound();
    await rounds.setCurrentHoleCount(9);

    await tester.pumpWidget(_wrap(const ScorecardPage(holeCount: 9), locale, rounds));
    await tester.pumpAndSettle();

    // Loch 2 (Par 5, HCP 11, Herren 450, Damen 406 auf der vorderen Neun).
    expect(find.text('5'), findsOneWidget); // Par von Loch 2
    expect(find.text('450'), findsOneWidget);
    expect(find.text('406'), findsOneWidget);

    // Für die übrigen Löcher (kein scorecard-Datensatz) muss "–" erscheinen -
    // mindestens für Par/HCP/Herren/Damen von Loch 1 zusammen 4x pro Zeile,
    // über 8 Löcher hinweg mehrfach vorhanden.
    expect(find.text('–'), findsWidgets);
  });

  testWidgets('Vorne/Hinten-Umschalter erscheint nur bei mehr als 9 Löchern', (tester) async {
    final locale = LocaleService();
    final rounds = RoundsService();
    await locale.load();
    await rounds.load();
    await rounds.createNewRound();
    await rounds.setCurrentHoleCount(9);

    await tester.pumpWidget(_wrap(const ScorecardPage(holeCount: 9), locale, rounds));
    await tester.pumpAndSettle();
    expect(find.byType(SegmentedButton<bool>), findsNothing);

    await rounds.setCurrentHoleCount(18);
    await tester.pumpWidget(_wrap(const ScorecardPage(holeCount: 18), locale, rounds));
    await tester.pumpAndSettle();
    expect(find.byType(SegmentedButton<bool>), findsOneWidget);
  });
}
