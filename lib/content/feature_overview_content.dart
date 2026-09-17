// Inhalte für den In-App-"Funktionsumfang"-Screen (Standard-⋮-Menü, Punkt 1).
// Fachlich deckungsgleich mit PFLICHTENHEFT.md, Abschnitt 3 (Navigations-
// und Bildschirmkonzept) zu halten – bei jeder funktionalen Änderung beide
// Stellen gemeinsam pflegen. Die Nummerierung der Sections hier folgt den
// Unterabschnitten 3.1–3.5 sowie dem ⋮-Menü aus Abschnitt 3.3 des
// Pflichtenhefts.

class FeatureSection {
  final String title;
  final List<String> points;

  const FeatureSection({required this.title, required this.points});
}

const String featureOverviewIntro =
    'GC Winterberg Birdie Book (GCWBB) ist das digitale "Birdie Book" für '
    'den 9-Loch-Platz des GC Winterberg: Lochübersicht mit Skizze, '
    'Schlägerwahl, Scorecard und Vereinsinfos während der Runde. Diese '
    'Seite listet den aktuellen Funktionsumfang – ausführlicher und mit '
    'Entscheidungshistorie im Pflichtenheft im GitHub-Repository.';

const List<FeatureSection> featureOverviewSections = [
  FeatureSection(
    title: '1. Startbildschirm',
    points: [
      'Wahl zwischen "Neue Runde" und "Bestehende Runden".',
      '"Bestehende Runden" zeigt eine Verlaufsliste bereits gespeicherter Runden zur Auswahl.',
      'Jede gespeicherte Runde lässt sich nach links wischen, um sie zu löschen oder als PDF-Scorecard über die System-Weiterleitungsfunktion des Geräts zu versenden (z. B. WhatsApp oder E-Mail).',
      'Sprachauswahl (Deutsch/Englisch/Niederländisch) per Flaggen-Zeile.',
    ],
  ),
  FeatureSection(
    title: '2. Rundeneinstellungen',
    points: [
      'Erster Schritt nach der Start-Auswahl, noch vor Loch 1.',
      'Umschalter "9-Loch-Runde" / "18-Loch-Runde" (Default: 18-Loch-Runde).',
      'Bestimmt, wie viele Lochseiten der Pager enthält; jederzeit während der Runde änderbar.',
    ],
  ),
  FeatureSection(
    title: '3. Hauptbildschirm und Lochnavigation',
    points: [
      'Löcher, Rundeneinstellungen und Scorecard als Seiten eines gemeinsamen Pagers – Navigation durch Wischen oder per Direktsprung über die Reiter.',
      'Jede Lochseite zeigt eine individuelle Skizze der Bahn (Dogleg-Verlauf, Grün, Bunker, ggf. Wasser) sowie den Charakteristik-Text.',
      'Links eine Reihe von Reitern für Loch 1–9 (bzw. zusätzlich 10–18 bei 18-Loch-Runde) als Direktsprung-Navigation.',
      'Loch n und Loch n+9 teilen sich dieselbe Bahn-Skizze, unterscheiden sich durch Abschlag und Distanz.',
    ],
  ),
  FeatureSection(
    title: '4. Schläger',
    points: [
      'Liste der Golfschläger, vorbelegt mit einem Standard-Satz (12 Schläger).',
      'Schläger können hinzugefügt, editiert (Name) oder entfernt werden.',
      'Je Schläger ein editierbarer Distanzbereich, vorbelegt mit Richtwerten für hohes Handicap.',
    ],
  ),
  FeatureSection(
    title: '5. Scorecard',
    points: [
      'Automatisch generierte Scorecard mit den Daten der Winterberger Löcher, als letzter Reiter des Pagers.',
      'Bei 18-Loch-Runde ein Vorne/Hinten-Umschalter, bei 9-Loch-Runde direkte Anzeige der 9 Löcher.',
      'Score-Eingabe je Loch wird pro Runde lokal gespeichert.',
      'Par/HCP/Distanz-Werte liegen für alle 9 Bahnen vollständig vor (Quelle: Platzausschilderung).',
    ],
  ),
  FeatureSection(
    title: '6. Menü: Funktionsumfang, Problem melden, Über diese App',
    points: [
      'Drei-Punkte-Menü in der Kopfzeile mit den Einträgen Funktionsumfang, Schläger, Problem melden und Über diese App.',
      'Funktionsumfang: diese Seite, jederzeit einsehbar.',
      'Problem melden: Dialog mit Umschalter "Problem"/"Anregung", öffnet eine vorausgefüllte GitHub-Issue-Seite im Browser – kein Zugriffstoken in der App.',
      'Über diese App: Kurzinfo zur App inklusive der bisherigen Kontaktdaten des Vereins (Adresse, Telefon, E-Mail).',
    ],
  ),
];

const List<String> featureOverviewKnownLimitations = [
  'Das Vereinslogo ist bislang nur in niedriger Auflösung (70×70 px) verfügbar – App-Icons sind entsprechend nicht optimal scharf.',
  'Der Stil der Lochskizzen ist noch nicht final entschieden; der aktuelle Stil ist ein 1:1-Port der bisherigen Version, ein Redesign wird separat vorbereitet.',
  'Die Schläger-Verwaltung erlaubt aktuell nur eine Sammel-Bearbeitung (Bulk-Edit), keinen Dialog pro einzelnem Schläger.',
  'Es gibt noch keine "schwebende" Schläger-Auswahl direkt im Hauptbildschirm – Schläger bleiben vorerst ein eigener Bildschirm.',
  'Das Versenden der PDF-Scorecard nutzt die System-Weiterleitungsfunktion des Geräts (Web-Share-API bzw. natives Share-Sheet). Auf Plattformen/Browsern ohne Datei-Share (z. B. viele Desktop-Browser) wird die PDF-Datei stattdessen automatisch heruntergeladen.',
];
