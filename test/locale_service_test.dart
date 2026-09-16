import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gc_winterberg_birdie_book/services/locale_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Default-Sprache ist Deutsch, wenn nichts gespeichert ist', () async {
    final service = LocaleService();
    await service.load();
    expect(service.lang, 'de');
    expect(service.t('newRound'), 'Neue Runde');
  });

  test('gespeicherte Sprache wird beim Laden übernommen', () async {
    SharedPreferences.setMockInitialValues({'gcwbb_lang': 'en'});
    final service = LocaleService();
    await service.load();
    expect(service.lang, 'en');
    expect(service.t('newRound'), 'New Round');
  });

  test('setLang persistiert und benachrichtigt Listener', () async {
    final service = LocaleService();
    await service.load();

    var notified = false;
    service.addListener(() => notified = true);

    await service.setLang('nl');
    expect(service.lang, 'nl');
    expect(notified, isTrue);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('gcwbb_lang'), 'nl');
  });

  test('t() fällt für unbekannten Key auf den Key selbst zurück', () async {
    final service = LocaleService();
    await service.load();
    expect(service.t('does_not_exist'), 'does_not_exist');
  });

  test('tFormat ersetzt Platzhalter wie {address}', () async {
    final service = LocaleService();
    await service.load();
    final result = service.tFormat('contactText', {
      'address': 'Musterstraße 1',
      'phone': '123',
      'email': 'a@b.de',
      'web': 'example.de',
    });
    expect(result, contains('Musterstraße 1'));
    expect(result, contains('123'));
    expect(result, isNot(contains('{address}')));
  });
}
