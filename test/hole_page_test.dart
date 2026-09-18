import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:gc_winterberg_birdie_book/services/locale_service.dart';
import 'package:gc_winterberg_birdie_book/widgets/hole_page.dart';

Widget _wrap(LocaleService locale, Widget child) {
  return ChangeNotifierProvider<LocaleService>.value(
    value: locale,
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  testWidgets('Lochseite zeigt Par/HCP sowie Herren-/Damen-Distanzen', (tester) async {
    final locale = LocaleService();
    await locale.load();

    await tester.pumpWidget(_wrap(locale, const HolePage(n: 1)));
    await tester.pumpAndSettle();

    expect(find.text('4'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('397 m'), findsOneWidget);
    expect(find.text('364 m'), findsOneWidget);
  });
}
