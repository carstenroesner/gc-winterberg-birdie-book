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
    'den 9-Bahnen-Platz des GC Winterberg: Bahnenübersicht mit Bahnenfoto, '
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
      'Namensfeld: einmal eingegeben, wird der Name dauerhaft gespeichert und künftig immer vorgeschlagen.',
    ],
  ),
  FeatureSection(
    title: '2. Rundeneinstellungen',
    points: [
      'Erster Schritt nach der Start-Auswahl, noch vor Bahn 1.',
      'Umschalter "9-Bahnen-Runde" / "18-Bahnen-Runde" (Default: 9-Bahnen-Runde).',
      'Bestimmt, wie viele Bahnseiten der Pager enthält; jederzeit während der Runde änderbar.',
    ],
  ),
  FeatureSection(
    title: '3. Hauptbildschirm und Bahnnavigation',
    points: [
      'Bahnen, Rundeneinstellungen und Scorecard als Seiten eines gemeinsamen Pagers – Navigation durch Wischen oder per Direktsprung über die Reiter.',
      'Jede Bahnseite zeigt ein echtes, bereinigtes Foto der Vor-Ort-Bahnentafel (Dogleg-Verlauf, Grün, Bunker, ggf. Wasser sowie die Distanztafel) statt einer Handskizze.',
      'Ein Info-Button neben der Bahnnummer öffnet den Charakteristik-Text groß in einem Dialog – die Bahnseite selbst bleibt dadurch aufgeräumt.',
      'Die Bahn-Charakteristik-Texte liegen auf Deutsch, Englisch und Niederländisch vor und folgen der oben gewählten App-Sprache.',
      'Links eine Reihe von Reitern für Bahn 1–9 (bzw. zusätzlich 10–18 bei 18-Bahnen-Runde) als Direktsprung-Navigation.',
      'Bahn n und Bahn n+9 teilen sich dasselbe Bahnenbild, unterscheiden sich durch Abschlag und Distanz.',
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
      'Automatisch generierte Scorecard mit den Daten der Winterberger Bahnen, als letzter Reiter des Pagers.',
      'Bei 18-Bahnen-Runde ein Vorne/Hinten-Umschalter, bei 9-Bahnen-Runde direkte Anzeige der 9 Bahnen.',
      'Score-Eingabe je Bahn wird pro Runde lokal gespeichert.',
      'Par/HCP/Distanz-Werte liegen für alle 9 Bahnen vollständig vor (Quelle: Platzausschilderung).',
      'Datum der Runde sowie – sofern beim Anlegen der Runde erfolgreich abgerufen – die aktuellen Wetterbedingungen am Platz werden dauerhaft mit der Runde gespeichert.',
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
  FeatureSection(
    title: '7. Automatisierte Tests',
    points: [
      'Jede Änderung wird vor dem Deploy durch echte flutter-test-Tests abgesichert, die bei jedem Push automatisch in der CI laufen (Deploy stoppt bei Rot).',
      'Abgedeckt sind u. a.: App-Start, Lochskizzen-Definitionen, Bahnseite inkl. Info-Button-Dialog, Scorecard-Werte, Schläger-Verwaltung inkl. Cancel-Regression, Sprachumschaltung, Pager-Navigation (9/18-Bahnen, Direktsprung/Wischen) und der Problem-melden-Dialog.',
      'Die ausführliche Test-Übersicht mit allen Einzelfällen steht im Pflichtenheft (Abschnitt 16) im GitHub-Repository.',
    ],
  ),
];

const List<String> featureOverviewKnownLimitations = [
  'Das Vereinslogo ist bislang nur in niedriger Auflösung (70×70 px) verfügbar – App-Icons sind entsprechend nicht optimal scharf.',
  'Die einzelnen Entfernungsmarkierungen im Fairway auf den Bahnenbildern (kleine farbige Punkte mit Zahlen) stammen unverändert aus dem Originalfoto und wurden nicht durch Vektorgrafik ersetzt – nur die beiden Infotafeln (Bahn/Par/HCP sowie Herren/Damen) wurden neu gerendert.',
  'Die Schläger-Verwaltung erlaubt aktuell nur eine Sammel-Bearbeitung (Bulk-Edit), keinen Dialog pro einzelnem Schläger.',
  'Es gibt noch keine "schwebende" Schläger-Auswahl direkt im Hauptbildschirm – Schläger bleiben vorerst ein eigener Bildschirm.',
  'Das Versenden der PDF-Scorecard nutzt die System-Weiterleitungsfunktion des Geräts (Web-Share-API bzw. natives Share-Sheet). Auf Plattformen/Browsern ohne Datei-Share (z. B. viele Desktop-Browser) wird die PDF-Datei stattdessen automatisch heruntergeladen.',
];
