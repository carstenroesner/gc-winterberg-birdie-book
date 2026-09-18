// Prüft PlayerService: Name ist beim ersten Start leer, wird gespeichert
// und beim nächsten Laden wieder vorbelegt (Nutzerwunsch, 18.09.2026, siehe
// PFLICHTENHEFT.md Abschnitt 8/18).

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gc_winterberg_birdie_book/services/player_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Name ist leer, wenn noch nichts gespeichert wurde', () async {
    final service = PlayerService();
    await service.load();
    expect(service.name, isEmpty);
  });

  test('setName persistiert den Namen und benachrichtigt Listener', () async {
    final service = PlayerService();
    await service.load();

    var notified = false;
    service.addListener(() => notified = true);

    await service.setName('Carsten Rösner');

    expect(service.name, 'Carsten Rösner');
    expect(notified, isTrue);

    final reloaded = PlayerService();
    await reloaded.load();
    expect(reloaded.name, 'Carsten Rösner');
  });

  test('setName trimmt Leerzeichen und entfernt den Namen bei leerer Eingabe', () async {
    final service = PlayerService();
    await service.load();
    await service.setName('  Carsten  ');
    expect(service.name, 'Carsten');

    await service.setName('   ');
    expect(service.name, isEmpty);

    final reloaded = PlayerService();
    await reloaded.load();
    expect(reloaded.name, isEmpty);
  });
}
