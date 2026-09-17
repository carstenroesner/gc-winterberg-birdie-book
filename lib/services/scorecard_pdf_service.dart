// Wandelt die Scorecard einer Runde in ein PDF um und ruft die
// System-Weiterleitungsfunktion des Geräts auf (Versenden-Swipe-Aktion in
// "Bestehende Runden" – siehe Abschnitt 3.1/5 im Pflichtenheft). Nutzt die
// deklarative Widget-API des `pdf`-Pakets für das Layout und `printing` für
// den eigentlichen System-Share (WhatsApp/E-Mail/... je nach Betriebssystem
// bzw. Browser – auf Plattformen ohne Datei-Share fällt `printing`
// automatisch auf einen Datei-Download zurück).

import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../content/course_data.dart';
import '../models/round.dart';

class ScorecardPdfService {
  ScorecardPdfService._();

  /// Baut das PDF-Dokument für [round] und liefert die rohen Bytes zurück.
  static Future<Uint8List> buildPdf(Round round) async {
    final doc = pw.Document();

    final rows = <List<String>>[];
    var scoreSum = 0;
    var anyScore = false;

    for (var i = 1; i <= round.holeCount; i++) {
      final isBack = i > 9;
      final n = isBack ? i - 9 : i;
      final hole = holeForPhysicalNumber(i);
      final sc = hole.scorecard;
      final score = round.scores[Round.scoreKey(isBack: isBack, n: n)];
      if (score != null) {
        scoreSum += score;
        anyScore = true;
      }
      rows.add([
        '$i',
        sc == null ? '–' : '${sc.par}',
        sc == null ? '–' : '${isBack ? sc.hcp.back : sc.hcp.front}',
        sc == null ? '–' : '${isBack ? sc.herren.back : sc.herren.front}',
        sc == null ? '–' : '${isBack ? sc.damen.back : sc.damen.front}',
        score?.toString() ?? '–',
      ]);
    }

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                courseInfo.clubName,
                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 2),
              pw.Text('Scorecard', style: const pw.TextStyle(fontSize: 13)),
              pw.SizedBox(height: 16),
              pw.Text('Datum: ${_fmtDate(round.date)}'),
              pw.Text(
                round.holeCount == 9 ? '9-Loch-Runde' : '18-Loch-Runde',
              ),
              pw.SizedBox(height: 16),
              pw.Table.fromTextArray(
                headers: const ['Loch', 'Par', 'HCP', 'Herren', 'Damen', 'Score'],
                data: rows,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                cellStyle: const pw.TextStyle(fontSize: 10),
                cellAlignment: pw.Alignment.centerLeft,
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
                cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              ),
              pw.SizedBox(height: 12),
              if (anyScore)
                pw.Text(
                  'Gesamt: $scoreSum',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              pw.SizedBox(height: 28),
              pw.Text(
                '${courseInfo.clubName} · ${courseInfo.address} · ${courseInfo.web}',
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  /// Baut das PDF und öffnet die System-Weiterleitungsfunktion des Geräts
  /// dafür (Share-Sheet unter iOS/Android bzw. Web-Share/Download im
  /// Browser).
  static Future<void> shareRound(Round round) async {
    final bytes = await buildPdf(round);
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'gcwbb-scorecard-${_fileDate(round.date)}.pdf',
    );
  }

  static String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  static String _fileDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
