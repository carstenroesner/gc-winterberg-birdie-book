import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gc_winterberg_birdie_book/models/round.dart';
import 'package:gc_winterberg_birdie_book/services/rounds_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('startet ohne gespeicherte Runden', () async {
    final service = RoundsService();
    await service.load();
    expect(service.rounds, isEmpty);
    expect(service.currentRound, isNull);
    expect(service.currentHoleCount, 18); // Default laut holeCountFor()
  });

  test('createNewRound legt eine 18-Loch-Runde an und macht sie aktuell', () async {
    final service = RoundsService();
    await service.load();
    final round = await service.createNewRound();

    expect(round.holeCount, 18);
    expect(round.scores, isEmpty);
    expect(service.currentRoundId, round.id);
    expect(service.rounds.first.id, round.id);
  });

  test('setCurrentHoleCount ändert nur die aktuelle Runde', () async {
    final service = RoundsService();
    await service.load();
    await service.createNewRound();
    await service.setCurrentHoleCount(9);
    expect(service.currentHoleCount, 9);
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
}
