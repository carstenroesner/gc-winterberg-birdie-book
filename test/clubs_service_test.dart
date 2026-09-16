import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gc_winterberg_birdie_book/content/default_clubs.dart';
import 'package:gc_winterberg_birdie_book/services/clubs_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('lädt den Standardsatz (12 Schläger), wenn nichts gespeichert ist', () async {
    final service = ClubsService();
    await service.load();
    expect(service.clubs.length, 12);
    expect(service.clubs.first.id, defaultClubs.first.id);
  });

  test('startEdit erzeugt eine unabhängige Arbeitskopie', () async {
    final service = ClubsService();
    await service.load();
    service.startEdit();
    expect(service.editMode, isTrue);
    expect(service.editBuffer.length, service.clubs.length);

    service.updateBufferName(0, 'Geändert');
    // Die Originalliste bleibt unberührt, solange nicht gespeichert wurde.
    expect(service.clubs.first.name, isNot('Geändert'));
    expect(service.editBuffer.first.name, 'Geändert');
  });

  test('cancelEdit verwirft alle Änderungen (kritischer Regressionstest)', () async {
    final service = ClubsService();
    await service.load();
    final originalNames = service.clubs.map((c) => c.name).toList();

    service.startEdit();
    service.updateBufferName(0, 'Sollte verworfen werden');
    service.addBlankToBuffer();
    service.removeFromBuffer(1);
    service.cancelEdit();

    expect(service.editMode, isFalse);
    expect(service.clubs.map((c) => c.name).toList(), originalNames);
  });

  test('saveEdit übernimmt Änderungen, entfernt Zeilen ohne Namen, persistiert', () async {
    final service = ClubsService();
    await service.load();

    service.startEdit();
    service.updateBufferName(0, '  Driver XL  ');
    service.addBlankToBuffer(); // Zeile ohne Namen -> muss beim Speichern wegfallen
    await service.saveEdit();

    expect(service.editMode, isFalse);
    expect(service.clubs.first.name, 'Driver XL');
    expect(service.clubs.any((c) => c.name.trim().isEmpty), isFalse);

    // Persistenz prüfen: neue Instanz lädt denselben Stand.
    final reloaded = ClubsService();
    await reloaded.load();
    expect(reloaded.clubs.first.name, 'Driver XL');
  });

  test('updateBufferMin/Max können auf null gesetzt werden (z. B. Putter)', () async {
    final service = ClubsService();
    await service.load();
    service.startEdit();
    service.updateBufferMin(0, null);
    service.updateBufferMax(0, null);
    expect(service.editBuffer.first.min, isNull);
    expect(service.editBuffer.first.max, isNull);
  });
}
