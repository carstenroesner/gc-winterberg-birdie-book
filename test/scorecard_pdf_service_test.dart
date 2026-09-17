// Prüft, dass ScorecardPdfService für 9- und 18-Loch-Runden ein gültiges
// PDF erzeugt (Magic-Bytes-Header "%PDF"), sowohl mit als auch ohne
// erfasste Scores. Reine Dart-Logik (kein Flutter-Widget-Test nötig), da
// das `pdf`-Paket unabhängig von Flutter-Bindings läuft.

import 'package:flutter_test/flutter_test.dart';

import 'package:gc_winterberg_birdie_book/models/round.dart';
import 'package:gc_winterberg_birdie_book/services/scorecard_pdf_service.dart';

void main() {
  Round buildRound({required int holeCount, Map<String, int> scores = const {}}) {
    return Round(
      id: 'r1',
      date: DateTime(2026, 9, 17),
      holeCount: holeCount,
      scores: scores,
    );
  }

  test('erzeugt ein gültiges PDF für eine 18-Loch-Runde mit Scores', () async {
    final round = buildRound(
      holeCount: 18,
      scores: {
        Round.scoreKey(isBack: false, n: 2): 5,
        Round.scoreKey(isBack: true, n: 2): 6,
      },
    );

    final bytes = await ScorecardPdfService.buildPdf(round);

    expect(bytes.isNotEmpty, isTrue);
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });

  test('erzeugt ein gültiges PDF für eine 9-Loch-Runde ohne Scores', () async {
    final round = buildRound(holeCount: 9);

    final bytes = await ScorecardPdfService.buildPdf(round);

    expect(bytes.isNotEmpty, isTrue);
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}
