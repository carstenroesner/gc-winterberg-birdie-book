// Prüft die Lochseite: Der Info-Button (i) neben der Lochnummer öffnet einen
// Dialog mit dem Charakteristik-Text der Bahn (seit 17.09.2026 nicht mehr
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

  testWidgets('Charakteristik-Text ist erst nach Tippen auf den Info-Button sichtbar',
      (tester) async {
    final locale = LocaleService();
    await locale.load();

    final holeText = holes[0].text; // Bahn 1
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

  testWidgets('Lochseite zeigt Par/HCP sowie Herren-/Damen-Distanzen', (tester) async {
    final locale = LocaleService();
    await locale.load();

    // Bahn 1: Par 4, HCP 3, Herren 397 m, Damen 364 m (vordere Neun).
    await tester.pumpWidget(_wrap(locale, const HolePage(n: 1)));
    await tester.pumpAndSettle();

    expect(find.text('4'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('397 m'), findsOneWidget);
    expect(find.text('364 m'), findsOneWidget);
  });
}
