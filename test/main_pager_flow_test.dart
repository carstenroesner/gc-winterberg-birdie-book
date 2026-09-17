// Prüft den Haupt-Pager: Anzahl/Sichtbarkeit der Buchregister-Reiter je
// nach Rundenlänge, Instant-Jump per Tab-Tap (ohne Warten auf eine
// Swipe-Animation) und die Kontextzeile in der Kopfzeile.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gc_winterberg_birdie_book/screens/main_pager_screen.dart';
import 'package:gc_winterberg_birdie_book/services/locale_service.dart';
import 'package:gc_winterberg_birdie_book/services/rounds_service.dart';
import 'package:gc_winterberg_birdie_book/widgets/book_tab_rail.dart';

Widget _wrap(LocaleService locale, RoundsService rounds) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LocaleService>.value(value: locale),
      ChangeNotifierProvider<RoundsService>.value(value: rounds),
    ],
    child: const MaterialApp(home: MainPagerScreen()),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('18-Loch-Runde zeigt zwei Reiterleisten, 9-Loch nur eine', (tester) async {
    final locale = LocaleService();
    final rounds = RoundsService();
    await locale.load();
    await rounds.load();
    await rounds.createNewRound(); // Default 18 Loch

    await tester.pumpWidget(_wrap(locale, rounds));
    await tester.pumpAndSettle();

    expect(find.byType(BookTabRail), findsNWidgets(2));

    await rounds.setCurrentHoleCount(9);
    await tester.pumpAndSettle();

    expect(find.byType(BookTabRail), findsOneWidget);
  });

  testWidgets('Tippen auf einen Lochreiter springt sofort auf die Lochseite', (tester) async {
    final locale = LocaleService();
    final rounds = RoundsService();
    await locale.load();
    await rounds.load();
    await rounds.createNewRound();
    await rounds.setCurrentHoleCount(9);

    await tester.pumpWidget(_wrap(locale, rounds));
    await tester.pumpAndSettle();

    // Kontextzeile zeigt zu Beginn "Rundeneinstellungen".
    expect(find.text('Rundeneinstellungen'), findsWidgets);

    final rail = find.byType(BookTabRail).first;
    final tab5 = find.descendant(of: rail, matching: find.text('5'));
    expect(tab5, findsOneWidget);

    await tester.tap(tab5);
    // Nur EIN pump (kein pumpAndSettle) - jumpToPage() ist unanimiert,
    // im Gegensatz zum Wischen, das animiert.
    await tester.pump();

    expect(find.text('Bahn 5'), findsOneWidget);
  });

  testWidgets('Scorecard-Reiter landet auf der letzten Pager-Seite', (tester) async {
    final locale = LocaleService();
    final rounds = RoundsService();
    await locale.load();
    await rounds.load();
    await rounds.createNewRound();
    await rounds.setCurrentHoleCount(9);

    await tester.pumpWidget(_wrap(locale, rounds));
    await tester.pumpAndSettle();

    final rail = find.byType(BookTabRail).first;
    final scorecardTab = find.descendant(
      of: rail,
      matching: find.byIcon(Icons.table_chart_outlined),
    );
    await tester.tap(scorecardTab);
    await tester.pump();

    expect(find.text('Scorecard'), findsWidgets);
  });
}
