// Prüft die Lochseite: Der Tipp-Button (Glühbirnen-Symbol, seit 18.09.2026
// statt des vorherigen (i)-Info-Icons, siehe PFLICHTENHEFT.md Abschnitt 18)
// neben der Lochnummer öffnet einen Dialog mit dem Charakteristik-Text der
// Bahn in der aktuell gewählten Sprache (seit 17.09.2026 nicht mehr
// dauerhaft auf der Seite sichtbar, siehe PFLICHTENHEFT.md Abschnitt 15) und
// lässt sich wieder schließen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gc_winterberg_birdie_book/content/course_data.dart';
import 'package:gc_winterberg_birdie_book/services/locale_service.dart';
import 'package:gc_winterberg_birdie_book/widgets/hole_page.dart';

Widget _wrap(LocaleService locale, Widget child) {
  return ChangeNotifierProvider<LocaleService>.value(
    value: locale,
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Charakteristik-Text ist erst nach Tippen auf den Tipp-Button sichtbar',
      (tester) async {
    final locale = LocaleService();
    await locale.load();

    final holeText = holes[0].textFor('de'); // Bahn 1
    await tester.pumpWidget(_wrap(locale, const HolePage(n: 1)));
    await tester.pumpAndSettle();

    expect(find.text(holeText), findsNothing);

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    expect(find.text(holeText), findsOneWidget);

    await tester.tap(find.text(locale.t('close')));
    await tester.pumpAndSettle();

    expect(find.text(holeText), findsNothing);
  });

  testWidgets('Charakteristik-Text erscheint in der aktuell gewählten Sprache (EN)',
      (tester) async {
    final locale = LocaleService();
    await locale.load();
    await locale.setLang('en');

    final holeTextEn = holes[0].textFor('en');
    await tester.pumpWidget(_wrap(locale, const HolePage(n: 1)));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    expect(find.text(holeTextEn), findsOneWidget);
  });

  testWidgets('Lochseite zeigt Par/HCP sowie Herren-/Damen-Distanzen', (tester) async {
    final locale = LocaleService();
    await locale.load();

    // Bahn 1: Par 4, HCP 3, Herren 397 m, Damen 364 m (vordere Neun).
    await tester.pumpWidget(_wrap(locale, const HolePage(n: 1)));
    await tester.pumpAndSettle();

    // Par/HCP werden als zusammengesetzter Text.rich ("Par 4", "HCP 3")
    // gerendert, daher hier mit findRichText/textContaining statt find.text.
    expect(find.textContaining('Par 4', findRichText: true), findsOneWidget);
    expect(find.textContaining('HCP 3', findRichText: true), findsOneWidget);
    expect(find.text('397 m'), findsOneWidget);
    expect(find.text('364 m'), findsOneWidget);
  });
}
