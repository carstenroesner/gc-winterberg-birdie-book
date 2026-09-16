// Kritischer Regressionstest auf Widget-Ebene: Im Bearbeitungsmodus
// vorgenommene Änderungen dürfen nach "Abbrechen" NICHT übernommen werden
// (siehe auch clubs_service_test.dart für die Service-Ebene).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gc_winterberg_birdie_book/screens/clubs_screen.dart';
import 'package:gc_winterberg_birdie_book/services/clubs_service.dart';
import 'package:gc_winterberg_birdie_book/services/locale_service.dart';

Widget _wrap(LocaleService locale, ClubsService clubs) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LocaleService>.value(value: locale),
      ChangeNotifierProvider<ClubsService>.value(value: clubs),
    ],
    child: const MaterialApp(home: ClubsScreen()),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Cancel verwirft Namensänderung und neu hinzugefügte Zeile', (tester) async {
    final locale = LocaleService();
    final clubs = ClubsService();
    await locale.load();
    await clubs.load();

    await tester.pumpWidget(_wrap(locale, clubs));
    await tester.pumpAndSettle();

    expect(find.text('Driver'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    // Namen des ersten Schlägers ändern.
    final nameField = find.widgetWithText(TextField, 'Bezeichnung').first;
    await tester.enterText(nameField, 'Driver Pro');
    await tester.pumpAndSettle();

    // Eine neue Zeile hinzufügen (Button liegt unterhalb der 12 Zeilen,
    // ListView baut ihn erst nach dem Scrollen).
    await tester.scrollUntilVisible(
      find.text('Schläger hinzufügen'),
      200.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Schläger hinzufügen'));
    await tester.pumpAndSettle();
    expect(clubs.editBuffer.length, 13);

    // Abbrechen.
    await tester.tap(find.text('Abbrechen'));
    await tester.pumpAndSettle();

    expect(clubs.editMode, isFalse);
    expect(clubs.clubs.length, 12);
    expect(clubs.clubs.first.name, 'Driver');

    // Nach dem Scrollen zum Hinzufügen-Button oben ist die Liste noch nicht
    // wieder nach oben gescrollt - erst zurückscrollen, dann prüfen.
    await tester.scrollUntilVisible(
      find.text('Driver'),
      -200.0,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Driver'), findsOneWidget);
    expect(find.text('Driver Pro'), findsNothing);
  });

  testWidgets('Save übernimmt Namensänderung dauerhaft', (tester) async {
    final locale = LocaleService();
    final clubs = ClubsService();
    await locale.load();
    await clubs.load();

    await tester.pumpWidget(_wrap(locale, clubs));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    final nameField = find.widgetWithText(TextField, 'Bezeichnung').first;
    await tester.enterText(nameField, 'Driver Pro');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Speichern'));
    await tester.pumpAndSettle();

    expect(clubs.clubs.first.name, 'Driver Pro');
    expect(find.text('Driver Pro'), findsOneWidget);
  });
}
