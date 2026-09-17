// Prüft, dass die Scorecard-Seite für alle 9 Bahnen echte Referenzdaten
// (Par/HCP/Herren/Damen) zeigt – seit dem vollständigen Erfassen der
// Platzausschilderung (17.09.2026, siehe PFLICHTENHEFT.md) liegen diese
// Werte für alle Bahnen vor, nicht mehr nur für Loch 2/11.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gc_winterberg_birdie_book/content/course_data.dart';
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

  test('alle 9 Bahnen haben einen erfassten Scorecard-Datensatz', () {
    for (final hole in holes) {
      expect(hole.scorecard, isNotNull, reason: 'Loch ${hole.n} sollte Referenzdaten haben');
    }
  });

  testWidgets('Scorecard zeigt für Loch 1 und Loch 9 echte Werte (keine Platzhalter)',
      (tester) async {
    final locale = LocaleService();
    final rounds = RoundsService();
    await locale.load();
    await rounds.load();
    await rounds.createNewRound();
    await rounds.setCurrentHoleCount(9);

    await tester.pumpWidget(_wrap(const ScorecardPage(holeCount: 9), locale, rounds));
    await tester.pumpAndSettle();

    // Loch 1 (Par 4, HCP 3, Herren 397, Damen 364) und Loch 9 (Par 4, HCP 15,
    // Herren 259, Damen 247) auf der vorderen Neun.
    expect(find.text('397'), findsOneWidget);
    expect(find.text('364'), findsOneWidget);
    expect(find.text('259'), findsOneWidget);
    expect(find.text('247'), findsOneWidget);

    // Die Referenzspalten (Par/HCP/Herren/Damen) zeigen für keine der 9
    // Bahnen mehr "–" - nur noch das leere Score-Eingabefeld hat "–" als
    // Platzhalter-Hint.
    final scoreFields = find.byType(TextField);
    expect(scoreFields, findsNWidgets(9));
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
