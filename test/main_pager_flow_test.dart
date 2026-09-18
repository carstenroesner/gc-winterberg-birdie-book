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
import 'package:gc_winterberg_birdie_book/services/weather_service.dart';
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
    // Kein echter Netzwerkaufruf in Tests (siehe weather_service.dart).
    weatherFetcher = () async => null;
  });

  testWidgets(
      '18-Loch-Runde zeigt zwei gefuellte Reiterleisten, 9-Loch nur links '
      'gefuellt (rechte Leiste bleibt aus Layout-Symmetriegruenden '
      'gerendert, aber leer)', (tester) async {
    final locale = LocaleService();
    final rounds = RoundsService();
    await locale.load();
    await rounds.load();
    await rounds.createNewRound(); // Default seit 18.09.2026: 9 Loch
    await rounds.setCurrentHoleCount(18);

    await tester.pumpWidget(_wrap(locale, rounds));
    await tester.pumpAndSettle();

    // Beide Reiterleisten sind immer im Widget-Baum (Layout-Symmetrie,
    // siehe main_pager_screen.dart) - im 18-Loch-Modus mit Inhalt.
    expect(find.byType(BookTabRail), findsNWidgets(2));
    final railsWith18 = tester.widgetList<BookTabRail>(find.byType(BookTabRail));
    expect(railsWith18.every((r) => r.items.isNotEmpty), isTrue);

    await rounds.setCurrentHoleCount(9);
    await tester.pumpAndSettle();

    // Weiterhin zwei Reiterleisten im Baum, aber die rechte ist jetzt leer
    // (keine Reiter) statt komplett zu verschwinden - sonst waere die
    // Bahnenkarte im 9-Loch-Modus asymmetrisch verschoben.
    expect(find.byType(BookTabRail), findsNWidgets(2));
    final railsWith9 = tester.widgetList<BookTabRail>(find.byType(BookTabRail));
    final leftRail = railsWith9.firstWhere((r) => r.side == BookTabSide.left);
    final rightRail = railsWith9.firstWhere((r) => r.side == BookTabSide.right);
    expect(leftRail.items, isNotEmpty);
    expect(rightRail.items, isEmpty);
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
