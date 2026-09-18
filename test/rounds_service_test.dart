import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gc_winterberg_birdie_book/models/round.dart';
import 'package:gc_winterberg_birdie_book/services/rounds_service.dart';
import 'package:gc_winterberg_birdie_book/services/weather_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    // Kein echter Netzwerkaufruf in Tests (siehe weather_service.dart);
    // einzelne Tests überschreiben dies gezielt wieder.
    weatherFetcher = () async => null;
  });

  test('startet ohne gespeicherte Runden', () async {
    final service = RoundsService();
    await service.load();
    expect(service.rounds, isEmpty);
    expect(service.currentRound, isNull);
    expect(service.currentHoleCount, 9); // Default laut holeCountFor()
  });

  test('createNewRound legt eine 9-Loch-Runde an und macht sie aktuell', () async {
    final service = RoundsService();
    await service.load();
    final round = await service.createNewRound();

    expect(round.holeCount, 9);
    expect(round.scores, isEmpty);
    expect(service.currentRoundId, round.id);
    expect(service.rounds.first.id, round.id);
  });

  test('setCurrentHoleCount ändert nur die aktuelle Runde', () async {
    final service = RoundsService();
    await service.load();
    await service.createNewRound();
    await service.setCurrentHoleCount(18);
    expect(service.currentHoleCount, 18);
  });

  test('setScore verwendet das Schlüsselformat front-<n>/back-<n>', () async {
    final service = RoundsService();
    await service.load();
    await service.createNewRound();

    await service.setScore(isBack: false, n: 2, score: 5);
    await service.setScore(isBack: true, n: 2, score: 6);

    final scores = service.currentRound!.scores;
    expect(scores[Round.scoreKey(isBack: false, n: 2)], 5);
    expect(scores[Round.scoreKey(isBack: true, n: 2)], 6);
  });

  test('setScore mit null entfernt den Eintrag wieder', () async {
    final service = RoundsService();
    await service.load();
    await service.createNewRound();
    await service.setScore(isBack: false, n: 3, score: 4);
    await service.setScore(isBack: false, n: 3, score: null);

    expect(service.currentRound!.scores.containsKey('front-3'), isFalse);
  });

  test('selectRound wechselt die aktuelle Runde und persistiert', () async {
    final service = RoundsService();
    await service.load();
    final r1 = await service.createNewRound();
    final r2 = await service.createNewRound();
    expect(service.currentRoundId, r2.id);

    await service.selectRound(r1.id);
    expect(service.currentRoundId, r1.id);

    final reloaded = RoundsService();
    await reloaded.load();
    expect(reloaded.currentRoundId, r1.id);
    expect(reloaded.rounds.length, 2);
  });

  test('deleteRound entfernt eine Runde endgültig und persistiert das', () async {
    final service = RoundsService();
    await service.load();
    final r1 = await service.createNewRound();
    final r2 = await service.createNewRound();

    await service.deleteRound(r1.id);

    expect(service.rounds.length, 1);
    expect(service.rounds.first.id, r2.id);

    final reloaded = RoundsService();
    await reloaded.load();
    expect(reloaded.rounds.length, 1);
    expect(reloaded.rounds.first.id, r2.id);
  });

  test('deleteRound der aktuellen Runde hebt die Auswahl auf', () async {
    final service = RoundsService();
    await service.load();
    final round = await service.createNewRound();
    expect(service.currentRoundId, round.id);

    await service.deleteRound(round.id);

    expect(service.currentRoundId, isNull);
    expect(service.currentRound, isNull);
  });

  test('createNewRound hinterlegt bei erfolgreichem Wetterabruf die Werte an der Runde',
      () async {
    weatherFetcher =
        () async => const WeatherReading(tempC: 18.4, code: 1, windKph: 9.2);

    final service = RoundsService();
    await service.load();
    final round = await service.createNewRound();
    // Der Abruf läuft nicht-blockierend im Hintergrund (siehe
    // RoundsService._fetchWeatherFor); mit dem synchronen Fake-Fetcher oben
    // ist er nach einem Mikrotask-Durchlauf bereits fertig.
    await Future<void>.delayed(Duration.zero);

    expect(round.weatherTempC, isNull); // Rückgabewert ist der Stand vor dem Abruf.
    final updated = service.rounds.firstWhere((r) => r.id == round.id);
    expect(updated.weatherTempC, 18.4);
    expect(updated.weatherCode, 1);
    expect(updated.weatherWindKph, 9.2);
  });

  test('createNewRound lässt die Runde ohne Wetterdaten, wenn der Abruf fehlschlägt',
      () async {
    weatherFetcher = () async => null;

    final service = RoundsService();
    await service.load();
    final round = await service.createNewRound();
    await Future<void>.delayed(Duration.zero);

    final updated = service.rounds.firstWhere((r) => r.id == round.id);
    expect(updated.weatherTempC, isNull);
    expect(updated.weatherCode, isNull);
  });
}
