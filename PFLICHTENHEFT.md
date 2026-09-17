# Pflichtenheft: GC Winterberg Birdie Book (GCWBB)

**Status: Vollständige Migration auf Flutter/Dart abgeschlossen (16.09.2026) – neuer, für alle Apps verbindlicher App-Entwicklungsstandard (siehe Abschnitt 14) umgesetzt, live und verifiziert unter https://carstenroesner.github.io/gc-winterberg-birdie-book/. Die bisherige Vanilla-JS-Version (Version 0.1, siehe Abschnitt 9, sowie die in Abschnitt 10 spezifizierte Erweiterung vom 15.09.2026) ist damit abgelöst.**
Dieses Dokument wird weiterhin Stück für Stück ergänzt, insbesondere um die noch offenen Punkte aus Abschnitt 6 sowie den Migrationsfortschritt aus Abschnitt 14. Es liegt seit der Migration im Repo-Root als `PFLICHTENHEFT.md` (zuvor `claude/pflichtenheft-gcwbb.md`) und ist zusätzlich über das ⋮-Menü der App unter „Funktionsumfang" fachlich deckungsgleich einsehbar.

Stand: 16.09.2026

---

## 1. Zweck und Rahmen

GCWBB ist eine Begleit-App für den 9-Loch-Golfplatz des GC Winterberg. Sie dient dem Spieler als digitales "Birdie Book": Übersicht über die Löcher (als Skizze), Schlägerwahl, Scorecard und allgemeine Vereinsinfos während einer Runde.

- **App-Name:** GC Winterberg Birdie Book
- **Kurzname:** GCWBB
- **Verein/Platz:** GC Winterberg, 9-Loch-Platz
- **Logo:** Golfclub-Logo wird verwendet. Nutzungsrecht liegt laut Auskunft des Auftraggebers vor. Datei liegt vor (siehe Abschnitt 5).
- **Platz-Kenndaten** (Adresse/Kontakt/Greenfee/Abschlag-Namen: golfclub-winterberg.de/9-loch-turnierplatz, siehe 5b; Course Rating/Slope/Par: offizielle Vorgabewirksame-Tabelle des Vereins, siehe 5c): Greenfee ab 30 €. Adresse: In der Büre 20, 59955 Winterberg. Telefon 02981 1770, E-Mail info@golfclub-winterberg.de. Der 9-Loch-Platz wird durch zwei unterschiedliche Abschlag-Sätze wie ein 18-Loch-Kurs gespielt: Herren-Abschlag „Schanze" (gelb) – CR 70,9 / Slope 135 / Par 70; Damen-Abschlag „Bob" (rot) – CR 73,6 / Slope 134 / Par 70. *(Hinweis: Die Website nennt abweichend CR 70,3 / Slope 132 ohne Zuordnung zu einem Abschlag – vermutlich ein älterer oder gerundeter Wert; für die App werden die Werte aus der offiziellen Vorgabewirksamen-Tabelle als maßgeblich angenommen, bis der Verein das bestätigt.)*

## 2. Plattform & Technische Rahmenbedingungen

- **Strategie:** Flutter Web als Progressive Web App (PWA), kostenlos über GitHub Pages deploybar, plattformunabhängig im Browser nutzbar. **Seit 16.09.2026 verbindlich** (siehe Abschnitt 14) – löst die bisherige Vanilla-HTML/CSS/JS-Version ab. Eine native iOS-App ist kein Bestandteil dieses Projekts.
- **Technologie-Basis:** Flutter/Dart, Material 3 (`useMaterial3: true`), `provider` für State-Management – nach dem für alle Apps von Carsten Rösner geltenden App-Entwicklungsstandard (Referenz-Implementierung: `spraytattoo_katalog`). *(Die hier zuvor genannte Swift-Basis war eine frühe, nie umgesetzte Planungsnotiz aus der Projekt-Startphase und ist mit der Flutter-Migration hinfällig.)*
- **Repository:** Öffentliches GitHub-Repository unter dem Account **carstenroesner** (gleicher Account wie die App „Spray Vorlagen"/spraytattoo_katalog, ebenfalls öffentlich – seit 15.09.2026, siehe Abschnitt 9): [github.com/carstenroesner/gc-winterberg-birdie-book](https://github.com/carstenroesner/gc-winterberg-birdie-book).
- **Build/CI:** Automatisierter GitHub-Actions-Workflow (`.github/workflows/deploy-web.yml`, siehe Abschnitt 14) – Flutter-Channel `stable` (nie fest gepinnt), `flutter test` als deploy-blockierendes Gate, Deploy über GitHub Pages mit Actions als Quelle (löst das bisherige statische Branch-Serving ab).

## 3. Navigations- und Bildschirmkonzept

### 3.1 Startbildschirm (Auswahl)

Beim App-Start wählt der Nutzer zwischen zwei Optionen:

1. **„Neue Runde"** → es erscheint zunächst der neue Bildschirm **„Rundeneinstellungen"** (siehe 3.1a), danach der Hauptbildschirm **ohne** Dateninhalte (leerer Zustand).
2. **„Bestehende Runden"** → der Nutzer wählt zunächst aus einer **Verlaufsliste** mehrerer gespeicherter Runden die gewünschte Runde aus; danach erscheint ebenfalls zunächst „Rundeneinstellungen" (siehe 3.1a), anschließend der Hauptbildschirm mit den zugehörigen Daten.

**Swipe-Aktionen (seit 17.09.2026):** Jede Runde in der Verlaufsliste lässt sich nach links wischen; dabei erscheinen zwei Aktionen:
- **Versenden**: erzeugt die Scorecard der Runde als PDF und ruft die System-Weiterleitungsfunktion des Geräts auf (Share-Sheet unter iOS/Android, z. B. WhatsApp oder E-Mail; im Browser die Web-Share-API bzw. ein Datei-Download als Fallback, falls der Browser keinen Datei-Share unterstützt).
- **Löschen**: löscht die Runde nach Sicherheitsabfrage endgültig.

### 3.1a Rundeneinstellungen (umgesetzt am 15.09.2026, vormals Abschnitt 10)

Erster Schritt nach der Start-Auswahl, noch vor Loch 1. Aktuell enthaltene Einstellung:

- **Toggle „9-Loch-Runde" / „18-Loch-Runde"** (Default: 18-Loch-Runde). Bestimmt, wie viele Lochseiten der Pager (3.2) enthält und ob die rechte Lochliste angezeigt wird. Der Toggle ist **jederzeit während der Runde änderbar**, auch nach bereits erfassten Scores (bewusste Vereinfachung, siehe „Getroffene Annahmen" unter 10).
- Weitere Einstellungen sind derzeit nicht vorgesehen; Ergänzungen sind offen (siehe 10, „Noch offene Detailfragen").

### 3.2 Hauptbildschirm (Lochansicht, „Buchregister"-Design seit 15.09.2026)

- Löcher, Rundeneinstellungen (3.1a) und Scorecard (3.5) sind Seiten eines gemeinsamen **horizontalen Pagers**: Rundeneinstellungen → Loch 1 → … → Loch 9 (bzw. Loch 18 bei 18-Loch-Runde) → Scorecard. Navigation durch **Wischen** nach links/rechts (animiert) oder per Reiter-Direktsprung (siehe unten, ohne Scroll-Animation – wie das Aufschlagen einer Buchseite über einen Register-Reiter).
- Zeigt je Lochseite eine **individuelle, handgezeichnet wirkende Skizze** der jeweiligen Bahn (Dogleg-Verlauf, Grün/Fahne, Bunker, ggf. Wasser – 9 eigenständige Motive, siehe 10.5), sowie den Charakteristik-Text aus 4a.
- **Links** am Bildschirmrand: vertikale Reihe von **Reitern** – oben ein Reiter für die Rundeneinstellungen (Zahnrad-Symbol), darunter Loch 1–9 (vordere Neun) als Direktsprung-Navigation; bei **9-Loch-Runde** zusätzlich ganz unten der Scorecard-Reiter (siehe unten).
- **Rechts** am Bildschirmrand: bei **18-Loch-Runde** weitere Reiter für Loch 10–18 (hintere Neun), ganz unten der Scorecard-Reiter; bei **9-Loch-Runde** wird die gesamte rechte Spalte **ausgeblendet** (3.1a).
- **Reiter-Optik („physisches Buch", 15.09.2026):** Jeder Reiter ist eine eigenständige, an der Außenkante abgerundete Fläche mit leichtem Schlagschatten, die wie ein aus dem Buch herausragendes Register wirkt; der aktive Reiter hebt sich farblich ab (Gold) und ragt sichtbar weiter heraus.
- Da es sich um einen 9-Loch-Platz handelt, teilen sich Loch *n* und Loch *n+9* dieselbe Bahn-Skizze; sie unterscheiden sich ausschließlich durch **Abschlag** und **Distanz**.

### 3.3 Kopfbereich-Menü (seit 15.09.2026, ersetzt das frühere Fußmenü; Inhalt seit 16.09.2026 an den App-Entwicklungsstandard angepasst, siehe Abschnitt 14)

Das bisherige Fußmenü (Löcher/Schläger/Scorecard/Sonstiges) wurde entfernt – Löcher und Scorecard sind jetzt über die Reiter (3.2) erreichbar. Im Kopfbereich befindet sich zusätzlich zum Neue-Runde-Symbol ein **Drei-Punkte-Menü-Symbol (⋮)**, das dem im App-Entwicklungsstandard vorgeschriebenen Standard-Menü entspricht – mit genau vier Einträgen statt der zuvor lose unter „Sonstiges" gesammelten Punkte:

- **Funktionsumfang** (neu, seit 16.09.2026) – öffnet einen eigenen Bildschirm mit dem aktuellen Funktionsumfang, fachlich deckungsgleich mit diesem Dokument.
- **Schläger** – Liste der möglichen Golfschläger (Standard-Satz); bleibt ein eigener, über das Menü erreichbarer Bildschirm. Die weiterhin gewünschte „schwebende" Schläger-Auswahl direkt im Hauptbildschirm (siehe 11.5) ist davon unabhängig und bleibt ein offener Ausbaupunkt.
- **Problem melden** – Dialog mit Umschalter Problem/Anregung, öffnet eine vorausgefüllte GitHub-Issue-Seite im Browser (unverändert aus 10.6, jetzt eigener Standard-Menüpunkt statt Unterpunkt von „Kontakt").
- **Über diese App** – Kurzinfo zur App; die bisherigen „Kontakt"-Inhalte (Adresse/Telefon/E-Mail) sind hier eingefaltet statt eines eigenen Menüpunkts (Entscheidung im Rahmen der Migration, siehe Abschnitt 14 – Nutzer hat die vom Standard vorgegebene 4er-Aufteilung bestätigt).

Die eigenständige „Sonstiges"-Seite entfällt damit; jeder Menüpunkt führt direkt zu seinem eigenen Bildschirm bzw. Dialog. **Sprache** ist kein Menüpunkt mehr – sie sitzt bereits seit Abschnitt 12 als Flaggen-Auswahl auf der Startseite.

Am Fuß des Hauptbildschirms weiterhin in kleiner Schrift:
„made with ♥ in Winterberg"

### 3.4 Bereich „Schläger"

Anzeige einer Liste der Golfschläger, vorbelegt mit dem **Standard-Satz** (12 Schläger, siehe 4b). Der Nutzer kann:

- weitere Schläger **hinzufügen**,
- seine Schläger (Name/Bezeichnung) **editieren** bzw. entfernen,
- pro Schläger einen **Distanzbereich** (wie weit er den Schläger typischerweise schlägt) **erfassen und editieren**.

Der Distanzbereich ist je Schläger mit einem Default-Wert vorbelegt (Richtwerte für einen Golfer mit hohem Handicap/HCP ~36, siehe 4b) und wird vom Nutzer im Lauf der Zeit an die eigene Spielstärke angepasst.

**Geplante Weiterentwicklung (angekündigt 15.09.2026, noch nicht umgesetzt):** Der Nutzer möchte die Schläger-Auswahl künftig **schwebend im Hauptbildschirm** sehen (statt als eigener Bildschirm über das ⋮-Menü) – Details dazu folgen in einer späteren Runde (siehe 11).

### 3.5 Bereich „Scorecard"

Automatisch generierte Golf-Scorecard mit den Daten der Winterberger Löcher – als eigener **Reiter** (3.2) am Ende der jeweils aktiven Spalte: unter Loch 9, wenn die Runde als 9-Loch-Runde eingestellt ist, unter Loch 18 bei einer 18-Loch-Runde (Wunsch des Nutzers vom 15.09.2026). Bei **18-Loch-Runde** zeigt ein Vorne/Hinten-Umschalter wahlweise die vordere oder hintere Neun; bei **9-Loch-Runde** entfällt dieser Umschalter, es werden direkt die 9 Löcher angezeigt. Konkrete Inhalte (Par, Index/Handicap-Vorgabe, Distanzen je Abschlag usw.) liegen laut Auftraggeber noch nicht vollständig vor und werden nachgereicht (siehe Abschnitt 6, Punkt 3/4).

## 4. Daten & Assets

| Asset | Status |
|---|---|
| Golfclub-Logo | vorhanden (Projekt-Datei `GCWLogo70x70.png.webp`) |
| Lochbild Loch 1 | Referenzgrafik von der Vereins-Website vorhanden (siehe 4a); eigenes Foto steht noch aus |
| Lochbilder Loch 2–9 | vorhanden (Projekt-Dateien Loch2.jpeg–Loch9.jpeg), zusätzlich Referenzgrafiken der Website (4a) |
| Charakteristik-Texte je Loch | vorhanden, siehe 4a (Quelle: Vereins-Website) |
| Distanzen/Abschläge je Loch (vorne 9 + hinten 9) | teilweise offen – Website liefert keine Tabelle; aus Vor-Ort-Ausschilderung (Beispiel Loch 2, siehe 5a) ableitbar, sofern Fotos aller 9 Tafeln vorliegen |
| Scorecard-Inhalte (Par, Index, HCP-Vorgabe) | teilweise offen – Course Rating/Slope/Par je Abschlag für den Gesamtplatz jetzt bekannt (siehe Abschnitt 1 und 5c); Werte je Loch weiterhin über Ausschilderung/Verein zu beschaffen |
| Vorgabewirksame Tabelle (DGV-STV → DGV-SPV, Gelb Herren/Rot Damen) | vorhanden (vom Nutzer als Bild bereitgestellt, siehe 5c) |
| Schläger-Standardsatz (Inhalt + Default-Distanzbereiche) | vorhanden, siehe 4b |
| Inhalte „Über" | Basisdaten jetzt vorhanden (Adresse, Kontakt, Course Rating/Slope, Greenfee, Abschlag-Namen „Schanze"/„Bob" – siehe Abschnitt 1); vorherige App als Vorbild weiterhin offen |
| Inhalte „Kontakt" | Basisdaten jetzt vorhanden (Telefon, E-Mail, Adresse – siehe Abschnitt 1); seit 16.09.2026 in „Über diese App" eingefaltet statt eigener Menüpunkt (siehe 3.3, 14) |

## 4a. Loch-Charakteristiken (Quelle: golfclub-winterberg.de/9-loch-turnierplatz)

Die Vereins-Website beschreibt jede Bahn narrativ und zeigt dazu eine kleine Referenzgrafik (Bahnskizze als GIF). Diese Texte/Grafiken dienen als Vorbild für die in-App-Inhalte je Loch; eine tabellarische Scorecard mit Par/HCP/Distanzen liefert die Website nicht.

| Bahn | Kurztitel | Charakteristik (Website-Originaltext) | Referenzgrafik |
|---|---|---|---|
| 1/10 | Abschlag am Clubhaus | „Ein guter Abschlag zur linken Seite des Fairway ist wichtig, denn auf der rechten könnte der Ball sonst im Teich landen. Der zweite Schlag muss lang genug sein, um Carry aufs Grün zu kommen … Am sichersten ist es, den Ball kurz aufkommen zu lassen, dass er zum Grün rollt." | [Grafik](https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn1_03160c67a6-153x300.gif) |
| 2/11 | Ein klassisches Par 5 | „Dieses Doppel-Dogleg ist mit zwei Schlägen kaum zu bewältigen … kleinstes Grün des Platzes … Abschlag muss vor dem Wassergraben liegen, der zweite rechts vom Fairway-Bunker." | [Grafik](https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn2_798ba9e2ba-145x300.gif) |
| 3/12 | Kurze Distanz | „Das kürzeste Loch auf dem Platz. Mittleres bis kurzes Eisen empfohlen. Genauigkeit wichtig, da die Distanz zur Ausgrenze sehr kurz ist." | [Grafik](https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn3_8d81eb7245-157x300.gif) |
| 4/13 | Das Wasser überbrücken | „Abschlag sehr nach links halten, da das Fairway rechts schräg wird. Langer zweiter Schlag nötig, um das Wasser vor dem Grün zu überbrücken." | [Grafik](https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn4_d8eedc6d3f-147x300.gif) |
| 5/14 | Es geht bergauf | „Bergauf. Beim Abschlag links halten, da rechts der tiefste Bunker des Platzes liegt." | [Grafik](https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn5_2ee2031a40-157x300.gif) |
| 6/15 | Sechstes und Längstes | „Längste Bahn des Platzes. Abschlag muss vor dem Graben liegen. Zwei gute, genaue Schläge nötig; Grün von zwei großen Bunkern verteidigt." | [Grafik](https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn6_4069a413a5-160x300.gif) |
| 7/16 | 400 Meter – 4 Schläge | „Schwierigstes Loch des Platzes, ca. 400 m. Erster Schlag idealerweise schräg in die linke Fairway-Hälfte. Nach ca. 225 m liegt ein Graben. Grün von zwei Bunkern geschützt." | [Grafik](https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn7_27d9cd6e84-157x300.gif) |
| 8/17 | Hier geht's bergauf | „183 m den Berg hinauf. Abschlag sehr gerade und lang genug. Rechts und links des Grüns große Bunker. Grün mit großer Stufe (McKenzie-Grün)." | [Grafik](https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn8_34e02e8bf2-158x300.gif) |
| 9/18 | Gefährlicher Pot-Bunker | „Kürzeste und sehr enge Par-4-Bahn. Mittleres bis langes Eisen zum ersten Schlag, kurzes Eisen bis zum Grün. Schlag nach rechts halten, da links ein kleiner Pot-Bunker gefährlich werden kann." | [Grafik](https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn9_a948a14a2f-148x300.gif) |

*Hinweis: Die Referenzgrafiken sind kleine Vorschaubilder (GIF, ca. 150×300 px) der Vereins-Website und konnten in dieser Session nicht automatisiert heruntergeladen/angezeigt werden (Website nicht auf der Zugriffs-Freigabeliste). Für die tatsächliche Asset-Erstellung sollten sie manuell heruntergeladen oder beim Verein angefragt werden.*

## 4b. Schläger-Standardsatz mit Default-Distanzbereichen

Standard-Satz (12 Schläger, wie in Punkt 5 vorgeschlagen und bestätigt): Driver, 3-Holz, Hybrid, Eisen 4–9, Pitching Wedge, Sand Wedge, Putter. Der Nutzer kann weitere Schläger hinzufügen und jeden Schläger (Name, Distanzbereich) editieren.

Die Distanzbereiche sind mit Richtwerten für einen Golfer mit **hohem Handicap (ca. HCP 30–36, „Anfänger"-Kategorie)** vorbelegt, recherchiert anhand gängiger Schlagweiten-Tabellen (Quelle siehe 5d). Es sind bewusst **Bereiche** (nicht einzelne Werte), da die tatsächliche Schlagweite je nach Schlag streut:

| Schläger | Default-Distanzbereich (Herren, hohes HCP) |
|---|---|
| Driver | 170–200 m |
| 3-Holz | 155–185 m |
| Hybrid | 140–170 m |
| Eisen 4 | 125–145 m |
| Eisen 5 | 120–140 m |
| Eisen 6 | 110–130 m |
| Eisen 7 | 100–120 m |
| Eisen 8 | 90–110 m |
| Eisen 9 | 80–100 m |
| Pitching Wedge | 70–90 m |
| Sand Wedge | 50–70 m |
| Putter | kein Distanzbereich (Einsatz auf dem Grün) |

*Hinweis: Dies sind nur App-Startwerte zur Orientierung, keine für Winterberg spezifischen Messwerte. Für Damen liegen aus derselben Quelle vergleichbare (niedrigere) Werte vor, falls geschlechtsspezifische Defaults gewünscht sind (offener Punkt, siehe 5d). Der Nutzer passt die Werte ohnehin an seine reale Spielstärke an.*

## 5. Getroffene Entscheidungen (aus Rückfragen)

- Plattform: **Flutter Web als PWA** (seit 16.09.2026, zuvor Vanilla-JS-PWA; siehe Abschnitt 14)
- Logo: liegt seit 14.09.2026 als Projekt-Datei vor (`GCWLogo70x70.png.webp`)
- „Bestehende Runden": **Verlaufsliste** mehrerer gespeicherter Runden zur Auswahl
- Git-Hosting: **GitHub, öffentliches Repository** (seit 15.09.2026, siehe 10.6-Update)
- Schläger-Standardsatz (12 Schläger, siehe 4b) **bestätigt als Default**; Nutzer kann Schläger **hinzufügen/editieren**, inkl. editierbarem **Distanzbereich** pro Schläger (Default-Werte siehe 4b)
- Mitspieler/Score-Erfassung: **zunächst nur ein Spieler** (der Nutzer selbst); Mitspieler-Erfassung ist kein Teil des ersten Funktionsumfangs
- Datenspeicherung: **zunächst rein lokal** auf dem Gerät; **iCloud-Synchronisation** ist als spätere Ausbaustufe erwünscht
- Sprachen: **Deutsch, Englisch, Niederländisch**, umschaltbar per Flaggen-Auswahl auf der Startseite (seit Abschnitt 12)
- App-Icon: **identisch zum Vereinslogo**
- ⋮-Menü: **4 Standard-Einträge** (Funktionsumfang, Schläger, Problem melden, Über diese App inkl. Kontakt) statt der bisherigen „Sonstiges"-Sammelseite (siehe 3.3, 14)
- Lochskizzen-Stil: bisherige Geometrie/Optik wird **1:1 nach Flutter portiert**, eine mögliche Neugestaltung (siehe Abschnitt 13) bleibt ein separater, noch nicht entschiedener Folgeschritt (siehe 14)
- Runden verwalten (seit 17.09.2026): **Swipe nach links** auf einer gespeicherten Runde blendet **Versenden** (Scorecard als PDF über die System-Weiterleitungsfunktion) und **Löschen** (mit Sicherheitsabfrage) ein; PDF-Erzeugung über das `pdf`-Paket, Versand über `printing` (`Printing.sharePdf`), Swipe-Geste über `flutter_slidable` (siehe 14)

## 5a. Beispieldesigns (Entwurf)

Am 14.09.2026 wurde ein erster Satz beispielhafter Bildschirm-Designs erstellt (Artefakt „GCWBB App-Designs", 5 Screens: Start, Hauptbildschirm/Loch, Schläger, Scorecard, Sonstiges). Farb-/Typo-System wurde aus dem Vereinslogo abgeleitet (Grün/Gold/Creme). Die Lochskizze im Hauptbildschirm ist bewusst ein generischer Platzhalter-Stil, bis die echten Lochformen aus den Referenzfotos nachgebaut werden.

**Wichtiger Fund:** Das Foto von Loch 2 (Projekt-Datei `Loch2.jpeg`) zeigt, dass die Ausschilderung vor Ort bereits alle für die Scorecard nötigen Daten pro Bahn enthält: Par, HCP (getrennt für vordere/hintere Neun), sowie Distanzen für Herren- und Damen-Abschlag auf beiden Bahnen (Beispiel Bahn 2/11: Par 5, HCP 11/12, Herren 450 m/438 m, Damen 406 m/395 m). Das deckt vermutlich einen Großteil der unter Punkt 6.3/6.5 offenen Distanz- und Scorecard-Daten ab, sofern entsprechende Fotos aller 9 Tafeln vorliegen bzw. nachgereicht werden.

## 5b. Auswertung der Vereins-Website als Vorbild (14.09.2026)

Auf Wunsch wurde https://golfclub-winterberg.de/9-loch-turnierplatz/ als Quelle für Loch-Vorbilder und Anzeige-Inhalte ausgewertet (Ergebnis in Abschnitt 4a sowie die Platz-Kenndaten in Abschnitt 1). Kernergebnisse:

- Allgemeine Platzdaten (Greenfee, Adresse, Kontakt, Abschlag-Namen) jetzt bekannt.
- Für jede der 9 Bahnen liegt ein kurzer, redaktioneller Charakteristik-Text sowie eine kleine Referenzgrafik (GIF) vor – geeignet als inhaltliches und gestalterisches Vorbild für die Lochansicht (Abschnitt 3.2) und ggf. als Grundlage für „Über".
- Die Website liefert **keine** tabellarische Scorecard (kein Par/HCP/Distanz-Raster je Loch) – dieser Teil von Punkt 6.3/6.4 bleibt offen und muss weiterhin über die Vor-Ort-Ausschilderung (vgl. 5a) oder direkte Auskunft des Vereins beschafft werden.

## 5c. Offizielle Vorgabewirksame Tabelle (vom Nutzer bereitgestellt, 14.09.2026)

Der Nutzer hat ein Foto der offiziellen Vorgabewirksamen-Tabelle (DGV-Format) des GC Winterberg bereitgestellt. Sie zeigt die Umrechnung von Stammvorgabe (DGV-STV) auf Spielvorgabe (DGV-SPV) getrennt nach Abschlag/Geschlecht sowie die maßgeblichen Platz-Kennzahlen für den Gesamtplatz (18-Loch-Wertung, da der 9-Loch-Platz zweimal mit unterschiedlichen Abschlägen gespielt wird):

| | Gelb Herren | Rot Damen |
|---|---|---|
| Course Rating (CR) | 70,9 | 73,6 |
| Slope | 135 | 134 |
| Par | 70 | 70 |

Diese Werte ersetzen/präzisieren die zuvor von der Website übernommenen, abweichenden Angaben (CR 70,3 / Slope 132, siehe 5b) – vermutlich, weil die Website einen älteren oder gerundeten Gesamtwert ohne Abschlag-Zuordnung zeigte. Die vollständige DGV-STV→DGV-SPV-Konvertierungstabelle (Vorgabeklassen +4,0 bis 36,0, je Abschlag) liegt als Bild vor und kann bei Bedarf für eine Vorgabewirksame-Rundenfunktion (Berechnung der Spielvorgabe/Course Handicap direkt in der App) genutzt werden – siehe offener Punkt 13 in Abschnitt 6.

## 5d. Quelle für Schläger-Distanzbereiche (14.09.2026)

Für die Default-Distanzbereiche in 4b wurde recherchiert, welche Schlagweiten für einen Golfer mit hohem Handicap (Kategorie „High Handicap/Anfänger", die vom Nutzer genannte Referenz „HCP 36" liegt in dieser Kategorie) üblich sind. Quelle: [Average Golf Club Distances For High, Middle And Low HCP in METERS – Clevergolfer](https://www.clevergolfer.com/blog/average-golf-club-distances-for-high-middle-and-low-handicap-in-meters) (Werte für Herren, „High Handicap"-Kategorie, dort auf einzelne Meterwerte statt Bereiche angegeben; für die App wurde daraus je Schläger ein plausibler Bereich gebildet, siehe 4b). Es handelt sich um allgemeine Richtwerte, keine für den Nutzer oder den Platz Winterberg spezifisch gemessenen Daten.

## 6. Offene Punkte / noch zu klärende Fragen

Diese Punkte sollten vor bzw. spätestens bei Ausführungsstart geklärt sein:

1. ~~**Logo-Datei**~~ – erledigt (liegt vor).
2. **Loch-1-Bild in hoher Auflösung** – eigenes Foto steht noch aus (Website-Referenzgrafik als Übergangslösung vorhanden, siehe 4a).
3. ~~**Genaue Distanz-/Abschlagdaten** je Loch~~ – **geklärt:** Datenquelle ist die Scorecard/Ausschilderung vor Ort an jedem Loch (vgl. Beispiel Loch 2 in 5a). Noch zu tun: Fotos der übrigen 8 Tafeln (Loch 1, 3–9) nachreichen, damit alle Distanz-/Par-/HCP-Werte erfasst werden können.
4. **Scorecard-Inhalte je Loch** – welche Spalten/Werte genau (Par, Stableford-Index, Vorgabe-relevante Felder je Loch)? Course Rating/Slope/Par je Abschlag für den Gesamtplatz sind jetzt bekannt (siehe 5c), Werte pro Loch fehlen noch.
5. ~~**Schläger-Standardsatz**~~ – **geklärt:** Vorschlag bestätigt als Default; Nutzer kann Schläger hinzufügen/editieren, inkl. editierbarem Distanzbereich je Schläger (siehe 3.4, 4b, 5d).
6. **Inhalte „Über" und „Kontakt"** – Basisdaten jetzt vorhanden (Adresse, Telefon, E-Mail, Course Rating/Slope, Greenfee, Abschlag-Namen, siehe Abschnitt 1); seit 16.09.2026 in einem gemeinsamen „Über diese App"-Dialog zusammengeführt (siehe 3.3).
7. ~~**Skizzenerstellung**~~ – **geklärt/umgesetzt (15.09.2026):** Stilvorgabe kam vom Nutzer als handgezeichnete Referenzskizze (siehe 10.5); 9 individuelle SVG-Skizzen (eine je Bahn, vordere/hintere Neun teilen sich dieselbe Form) sind implementiert und 1:1 nach Flutter portiert (siehe 14). Eine mögliche Neugestaltung (Abschnitt 13) bleibt ein offener, unabhängiger Folgeschritt.
8. ~~**Mitspieler/Score-Erfassung**~~ – **geklärt:** Zunächst nur ein Spieler (der Nutzer selbst); Mitspieler-Erfassung ist erstmal nicht Teil des Funktionsumfangs.
9. ~~**Datenspeicherung**~~ – **geklärt:** Zunächst rein lokal auf dem Gerät; iCloud-Synchronisation als spätere Ausbaustufe erwünscht.
10. ~~**Sprache(n)**~~ – **geklärt:** Deutsch, Englisch und Niederländisch, per Flaggen-Auswahl auf der Startseite umschaltbar.
11. ~~**GitHub-Account/Organisation**~~ – **erledigt:** Account carstenroesner, Repo `gc-winterberg-birdie-book` (öffentlich), siehe Abschnitt 2 und 9.
12. ~~**App-Icon**~~ – **geklärt:** identisch zum Vereinslogo.
13. ~~**Vorgabewirksame Runden/Course Handicap**~~ – **geklärt:** nicht im ersten Funktionsumfang, auf **Backlog** verschoben (siehe Abschnitt 8).
14. **Logo-Auflösung** – die vorliegende Logo-Datei ist nur 70×70 px groß; für scharfe App-Icons (bis 512×512) und ein hochwertiges Erscheinungsbild wird eine höher aufgelöste Version benötigt (Vektor/SVG oder mind. 1024×1024 px), falls verfügbar. Weiterhin offen nach der Flutter-Migration.
15. **GitHub-Pages-Deploy-Quelle** (neu, 16.09.2026) – muss in den Repo-Einstellungen von „Deploy from branch" auf „GitHub Actions" umgestellt werden, da der neue Workflow (Abschnitt 14) über `actions/deploy-pages` statt über statisches Branch-Serving ausliefert. Umsetzung Teil von Abschnitt 14/Schritt „Push & Live-Verifikation".

## 7. Nächste Schritte

Weitere Klärung der noch offenen Punkte aus Abschnitt 6 (insbesondere Loch-1-Bild, restliche Distanz-/Par-/HCP-Daten, Logo-Auflösung), danach Weiterentwicklung entlang dieser Klärungen sowie der in Abschnitt 14 beschriebenen Flutter-Migration.

## 8. Backlog (spätere Ausbaustufen)

Ideen und Anforderungen, die bewusst **nicht** Teil des ersten Funktionsumfangs sind, aber für spätere Versionen vorgemerkt werden:

- **Vorgabewirksame Runden / automatische Course-Handicap-Berechnung** – Nutzung der Vorgabewirksamen Tabelle (5c), um aus der Stammvorgabe automatisch die Spielvorgabe je Abschlag zu berechnen (vgl. ehem. Punkt 13).
- **iCloud-Synchronisation** der Rundendaten zwischen Geräten (vgl. Punkt 9; Start erfolgt zunächst rein lokal).
- **Mitspieler/Score-Erfassung** für mehrere Spieler in einer Runde (vgl. Punkt 8; Start erfolgt zunächst mit nur einem Spieler).
- **Schwebende Schläger-Auswahl** direkt im Hauptbildschirm statt eigenem Menü-Bildschirm (siehe 3.4, 11.5).
- **Neugestaltung der Lochskizzen** (siehe Abschnitt 13) – vier Stil-Entwürfe für Loch 2 liegen als Design-Canvas vor, Entscheidung über die Richtung steht noch aus; mit der sauberen Trennung von Geometrie (`lib/models/hole_sketch_def.dart`, `lib/content/hole_sketch_defs.dart`) und Zeichen-Layer (`lib/widgets/hole_sketch_painter.dart`) seit der Flutter-Migration (Abschnitt 14) ist eine spätere Umsetzung ein reiner Austausch des Zeichen-Layers, ohne die Daten anzufassen.
- **Pflichtenheft als eigenständig erreichbare Website** (angekündigt vom Nutzer am 15.09.2026, „beim nächsten Bild, jetzt noch nicht nötig"): Das Pflichtenheft soll nicht nur als Datei vorliegen, sondern auch als für den Nutzer erreichbare Webseite/Doku-Seite abrufbar sein. Die Referenz-App spraytattoo_katalog hat kein vergleichbares Vorbild (ihr Pages-Deploy veröffentlicht nur die gebaute App, nicht ihre Doku); mögliche Ansätze für später (noch nicht entschieden): das `.md` direkt über die GitHub-eigene Markdown-Darstellung verlinken, oder eine kleine eigene Doku-Seite generieren. Mit der App-internen „Funktionsumfang"-Seite (siehe 3.3, 14) ist inzwischen zumindest ein Teil dieses Wunsches erfüllt.

## 9. Umsetzungsstand: Version 0.1 (14.09.2026)

Auf Anweisung wurde eine erste, funktionsfähige Version als Progressive Web App gebaut (Vanilla HTML/CSS/JS, keine Build-Tools) und dem Nutzer als Zip-Datei inkl. lokalem Git-Repository (ein Commit) bereitgestellt.

**Enthalten:** Start (Neue Runde / Verlaufsliste), Hauptbildschirm mit Lochauswahl vorn/hinten (Platzhalter-Skizze, Charakteristik-Text aus 4a, echte Par/HCP/Distanzwerte für Loch 2/11 aus 5a), Schläger-Verwaltung mit editierbarem Distanzbereich (Default-Werte aus 4b), Scorecard mit lokaler Persistenz je Runde, Sonstiges-Menü mit Über/Kontakt/Sprachumschaltung (DE/EN/NL). Als PWA installierbar (Manifest + Service Worker). Mit Playwright/Chromium smoke-getestet (Navigation, Schläger-CRUD, Score-Eingabe, Sprachwechsel) – funktionsfähig, aber noch nicht auf echten Endgeräten getestet.

**Bewusste Lücken in dieser Version** (Details siehe App-README):
- Lochskizzen sind generischer Platzhalter für alle 9 Bahnen (Punkt 7 weiterhin offen).
- Nur Loch 2/11 hat reale Scorecard-Daten, übrige Bahnen zeigen „–" (Punkt 3 – Fotos der restlichen Tafeln stehen noch aus).
- App-Icons sind aus dem nur 70×70 px großen Logo generiert und entsprechend niedrig aufgelöst – für Produktionsqualität wird eine höher aufgelöste Logo-Datei benötigt (neuer offener Punkt, siehe Abschnitt 6).
- **Git-Repository:** Erfolgreich zu GitHub gepusht. Das lokale Repo wurde über die Geräte-Verbindung in den Ordner `flutter_apps/gcwbb-app` auf dem Mac des Nutzers übertragen (gleicher Ordner, in dem auch „Spray Vorlagen"/spraytattoo_katalog liegt), dort wurde per Nutzer-Token ein neues **privates** Repository angelegt und der bestehende Commit gepusht: [github.com/carstenroesner/gc-winterberg-birdie-book](https://github.com/carstenroesner/gc-winterberg-birdie-book) (Branch `master`). Der lokale `origin`-Remote verweist sauber auf die HTTPS-URL ohne eingebettetes Token. **GitHub Pages** wurde aktiviert (Quelle: Branch `master`, Root-Verzeichnis). Die App ist damit öffentlich erreichbar und als PWA installierbar unter: **https://carstenroesner.github.io/gc-winterberg-birdie-book/** (erster Build kann einige Minuten dauern, bis die Seite live ist).

### Update 15.09.2026: Fixes + Erweiterung aus Abschnitt 10 gepusht

- Commit `2fa18ed` (Footer-Layout-Fix Startseite, Schläger-Mehrfach-Bearbeitungsmodus) wurde nach GitHub gepusht.
- Anschließend wurde die vollständige, in Abschnitt 10 spezifizierte Erweiterung umgesetzt: Rundeneinstellungen-Bildschirm mit 9-/18-Loch-Toggle (3.1a), Löcher+Scorecard als gemeinsamer Wisch-Pager (3.2/3.5), vertikale Lochnummern-Liste mit Trennlinien statt runder Buttons, 9 individuelle handgezeichnet wirkende Lochskizzen (10.5), sowie „Problem melden" im Kontakt-Bereich mit Weiterleitung zu einer vorausgefüllten, token-freien GitHub-Issue-URL (10.6). Mit Playwright/Chromium smoke-getestet (u. a. Pager-Navigation, 9-/18-Loch-Umschaltung inkl. Ausblenden der hinteren Spalte, Direktsprung über die Lochliste, Scorecard-Eingabe mit Vorne/Hinten-Umschalter, Problem-melden-Dialog inkl. echter GitHub-Issue-URL-Prüfung ohne Token-Leck) – alle Prüfungen erfolgreich.
- Nach GitHub gepusht als Commit **`69d412c`** (Branch `master`). GitHub Pages baut automatisch neu; die Live-Version unter https://carstenroesner.github.io/gc-winterberg-birdie-book/ ist damit in Kürze aktuell (der Build-Status konnte aus dieser Sitzung heraus nicht automatisiert abgefragt werden, da sowohl der direkte Pages-Abruf als auch die GitHub-API über die vorhandenen Netzwerkzugänge blockiert wurden – der erfolgreiche `git push` selbst ist aber der verlässliche Beleg für die Auslieferung).

## 10. Rundeneinstellungen, 9-/18-Loch-Umschaltung & Wisch-Navigation (umgesetzt am 15.09.2026)

Der Nutzer hatte am 15.09.2026 eine **Kette mehrerer zusammenhängender Änderungen** an Design und Nutzerführung angekündigt und zunächst gebeten, mit der Umsetzung erst nach expliziter Freigabe zu beginnen. Nach vollständiger Spezifikation aller Teile dieser Kette (10.1–10.6) hat der Nutzer die Umsetzung freigegeben („Wenn du keine Fragen hast, kannst du mit der Umsetzung beginnen"); sie wurde am 15.09.2026 implementiert, per Playwright/Chromium smoke-getestet und nach GitHub gepusht (Commit `69d412c`, siehe Abschnitt 9). Dieser Abschnitt bleibt als Entscheidungs-/Spezifikationsprotokoll erhalten; die aktuell gültige Beschreibung des Ist-Zustands steht in Abschnitt 3 (3.1a, 3.2, 3.3, 3.5).

**Grundprinzip bleibt:** Löcher werden weiterhin über den Hauptbildschirm erreicht (Lochauswahl-Buttons links/rechts, siehe 3.2) – das wird beibehalten und erweitert, nicht ersetzt.

**1. Neuer Bildschirm „Rundeneinstellungen"**
Nach der Auswahl auf dem Startbildschirm („Neue Runde" **oder** „Bestehende Runde", siehe 3.1) erscheint zusätzlich ein neuer Bildschirm, auf dem die Einstellungen der jeweiligen Runde festgelegt/geändert werden können – **bevor** die Lochansicht (Loch 1) erscheint.

**2. Erste Einstellung: 9-Loch/18-Loch-Umschalter**
Als erste Einstellung auf diesem Bildschirm gibt es einen **Toggle „9-Loch-Runde" / „18-Loch-Runde"**:
- **18-Loch-Runde:** Hauptbildschirm-Layout wie bisher – linke Spalte Löcher 1–9, rechte Spalte Löcher 10–18 (siehe 3.2).
- **9-Loch-Runde:** Nur die linke Spalte (Löcher 1–9) wird angezeigt, die rechte Spalte (10–18) wird **ausgeblendet**.

**3. Neue Gesamt-Reihenfolge / Position von Einstellungen und Scorecard**
- Die Einstellungs-Seite steht an erster Stelle, **vor Loch 1**.
- Die Scorecard wird an das Ende der Lochfolge verschoben statt (nur) über das Fußmenü erreichbar zu sein:
  - Bei **18-Loch-Runde**: Scorecard **nach Loch 18**.
  - Bei **9-Loch-Runde**: Scorecard **nach Loch 9**.

**4. Wisch-Navigation (Swipe)**
Durch Wischen nach links/rechts kann zwischen den Elementen dieser Abfolge gewechselt werden: Einstellungen ↔ Loch 1 ↔ … ↔ Loch 9 (↔ … ↔ Loch 18 bei 18-Loch-Runde) ↔ Scorecard. Die bestehenden Lochauswahl-Buttons (3.2) bleiben zusätzlich als direkte Sprung-Navigation erhalten.

**5. Lochskizzen- und Navigationsdesign (handgezeichnete Referenzskizze des Nutzers, 15.09.2026)**
Der Nutzer hat eine handgezeichnete Referenzskizze bereitgestellt (nicht als Bild in dieses Dokument eingebettet, siehe Hinweis zu Anhängen weiter oben – stattdessen hier in Worten beschrieben). Zwei Design-Elemente daraus:

- **Lochnummern-Liste:** Statt der aktuellen runden Buttons (3.2) soll die Lochnummer-Navigation als **schlichte vertikale Liste mit Trennstrichen** zwischen den Zahlen dargestellt werden (lineal-/registerartiger Stil). Gilt vermutlich analog für beide Spalten (vordere/hintere Neun) – zu bestätigen, sobald die Umsetzung ansteht.
- **Lochskizze:** Statt der aktuellen generischen Platzhalter-Form (identische Kontur für alle 9 Bahnen) soll die Skizze **handgezeichnet wirken und die tatsächliche Form der jeweiligen Bahn nachbilden** (z. B. Dogleg-Schwünge), mit Grün und Fahne an der realen Position sowie grob skizzierten Bunker-Formen an ungefährer realer Lage. Dies präzisiert den bisher offenen Punkt 7 (Skizzenerstellung/Stilvorgaben) um eine konkrete Stilrichtung; die tatsächlichen Bahn-Formen je Loch müssen weiterhin anhand der vorhandenen Referenzfotos/-grafiken (siehe 4a) einzeln nachgezeichnet werden.

**6. „Über" und „Kontakt" nach Vorbild der Referenz-App (15.09.2026)**
Der Nutzer wünscht, dass „Über" und „Kontakt" so umgesetzt werden wie in seiner anderen App (gemeint ist vermutlich **„Spray Vorlagen"/spraytattoo\_katalog**, im Ordner `flutter_apps` – technisch eine Flutter-App, die für iOS aber Swift-Wrapper-Code enthält, daher vermutlich die Bezeichnung „Swift-Ordner"; bitte korrigieren, falls eine andere App gemeint war). Das Vorbild wurde direkt im Quellcode dieser App eingesehen (`lib/screens/about_dialog.dart` und `lib/screens/report_issue_dialog.dart`):

- **„Über":** Ein einfaches Info-Fenster (Dialog) mit App-Name, Copyright-Zeile und „Schließen"-Button. Für GCWBB inhaltlich entsprechend den bereits vorhandenen Basisdaten (Abschnitt 1/4).
- **„Kontakt":** Wird zu einem **„Problem melden"-Dialog** erweitert bzw. dadurch ersetzt: Umschalter „Problem" / „Anregung" (Bug/Enhancement), Eingabefelder für Titel und Beschreibung, Button „Issue öffnen". Beim Absenden öffnet die App **kein** direktes API-Update, sondern eine **vorausgefüllte GitHub-„New Issue"-URL** (`github.com/carstenroesner/gc-winterberg-birdie-book/issues/new?title=…&body=…&labels=bug|enhancement`) im Browser – die eigentliche Übermittlung erfolgt dort mit dem eigenen GitHub-Konto der meldenden Person. Bewusst **kein** GitHub-Token in der App, aus Sicherheitsgründen (Vorbild-App macht das genauso, mit explizitem Kommentar im Code).

**Update 15.09.2026 – gelöst:** Auf Wunsch des Nutzers wurden **beide** Repositories (GCWBB und spraytattoo_katalog, gleicher GitHub-Account) von privat auf **öffentlich** umgestellt (reine GitHub-Einstellungsänderung über die API, keine Codeänderung nötig). Damit kann jede Person das Repository und die Issues lesen, und der „Issue öffnen"-Link ist nicht mehr durch fehlenden Repo-Zugriff blockiert – Option (b) aus der ursprünglichen Frage wurde damit umgesetzt.

**Einschränkung, die bestehen bleibt (GitHub-Plattformgrenze, nicht durch die App lösbar):** Der Nutzer fragte, ob Issues auch **ganz ohne Anmeldung** angelegt werden können. GitHub bietet das nicht an – auch bei einem öffentlichen Repository benötigt man zum Anlegen eines Issues ein (kostenloses) GitHub-Konto und muss eingeloggt sein; anonyme Issues sind eine seit Jahren offene, aber nicht umgesetzte Anfrage der Community. Wer den „Issue öffnen"-Link ohne GitHub-Konto anklickt, landet auf der GitHub-Login-/Registrierungsseite. Eine echte anonyme Einreichung wäre nur über einen Umweg möglich (z. B. ein serverseitiges Formular/eine Cloud-Funktion, die mit einem Bot-Token in GCWBB' Namen Issues anlegt) – das würde aber genau das Token-in-der-App-Problem wieder einführen, das mit dem aktuellen Ansatz bewusst vermieden wird (siehe oben). Für echte Endnutzer ohne GitHub-Konto bleibt Option (c) – ein zusätzlicher Kontaktweg wie der bestehende mailto-Link/die Vereins-Kontaktdaten (Abschnitt 1) – die praktikable Alternative; das ist weiterhin ein offener Punkt für eine spätere Entscheidung, aktuell aber nicht blockierend.

**Getroffene Annahmen bei der Umsetzung (15.09.2026)** – zu den zuvor offenen Detailfragen, ohne erneute Rückfrage entschieden, da laut Freigabe „keine Fragen" bestanden:
- Das Fußmenü (Löcher/Schläger/Scorecard/Sonstiges) bleibt bestehen. „Löcher" springt im Pager gezielt zu Loch 1, „Scorecard" gezielt zur Scorecard-Seite (nach dem letzten Loch) – zusätzlich zur Wisch-Navigation.
- Weitere Einstellungen auf dem „Rundeneinstellungen"-Bildschirm wurden **nicht** ergänzt; aktuell nur der 9-/18-Loch-Toggle (siehe 3.1a). Weitere Einstellungen bleiben ein offener Ausbaupunkt.
- Der 9-/18-Loch-Toggle ist **jederzeit während der Runde änderbar**, auch nach bereits erfassten Scores (einfachste Variante; ein Hinweis-Dialog bei bereits erfassten Scores wurde bewusst nicht ergänzt, um den Umfang klein zu halten – bei Bedarf nachrüstbar).
- Die Lochnummern-Liste (10.5) ist für vordere und hintere Neun **symmetrisch** im gleichen Stil umgesetzt.

**Status:** Umgesetzt, getestet und nach GitHub gepusht (siehe Abschnitt 9).

---

## 11. Buchregister-Design: Reiter statt Fußmenü (umgesetzt am 15.09.2026)

Auf ausdrücklichen Wunsch des Nutzers wurde die Navigation der App grundlegend überarbeitet, um stärker an ein physisches Buch mit Registern zu erinnern und um Platz für zukünftige Erweiterungen (siehe 11.5) zu schaffen. Freigabe erfolgte direkt mit „Bitte umsetzen und deploy" – ohne Rückfrage umgesetzt.

**11.1 Plastische Reiter-Optik**
Jeder Eintrag der Lochnummern-Listen (linke und rechte Spalte) ist jetzt ein eigenständiges, freigestelltes Element mit dezentem Verlaufshintergrund, abgerundeter Außenkante (links bei der linken Spalte, rechts bei der rechten Spalte) und gerichtetem Schlagschatten – die Ecke zur Buchmitte hin bleibt eckig, wie bei echten Registerreitern, die aus dem Buchschnitt herausragen. Der aktive Reiter hebt sich zusätzlich farblich (Gold-Verlauf) ab, wirft einen deutlicheren Schatten und „poppt" leicht nach außen (kleiner horizontaler Versatz). Ziel: das Gefühl, tatsächlich ein Register in einem Buch anzuklicken statt einen flachen Listeneintrag.

**11.2 Neuer Reiter „Rundeneinstellungen" (Zahnrad-Symbol)**
Über Loch 1 in der linken Spalte sitzt jetzt dauerhaft ein eigener Reiter mit Zahnrad-Symbol, der direkt zur Rundeneinstellungen-Seite (9-/18-Loch-Umschalter, siehe 3.1a) springt. Dieser Reiter ist immer sichtbar, unabhängig von der gewählten Rundenlänge.

**11.3 Scorecard-Reiter wandert mit der Rundenlänge**
Der Scorecard-Reiter (Tabellen-Symbol) erscheint jetzt nicht mehr als letzte Pager-Seite mit separatem Fußmenü-Zugriff, sondern als letzter Registerreiter der jeweils abschließenden Spalte: bei einer 9-Loch-Runde direkt unter Loch 9 in der linken Spalte, bei einer 18-Loch-Runde unter Loch 18 in der rechten Spalte. Beim Umschalten zwischen 9 und 18 Loch (Rundeneinstellungen) springt der Scorecard-Reiter automatisch mit.

**11.4 Fußmenü entfernt, Drei-Punkte-Menü im Kopfbereich**
Das bisherige Fußmenü (Löcher/Schläger/Scorecard/Sonstiges) wurde vollständig entfernt. An seine Stelle tritt ein Drei-Punkte-Symbol (⋮) im Kopfbereich der Hauptansicht, etwa dort, wo zuvor der Lochname als Überschrift stand. Es öffnet die bisherige „Sonstiges"-Seite, die jetzt eine eigene Kopfzeile mit Zurück-Pfeil besitzt (ebenso die Schläger-Seite, die zuvor nur über das Fußmenü erreichbar war und jetzt einen Zurück-Pfeil zur Hauptansicht braucht). Die App kommt damit ohne dauerhaft sichtbares Fußmenü aus; der Bereich unterhalb der Spalten zeigt nur noch die schlichte Credit-Zeile „made with ♥ in Winterberg". *(Seit der Flutter-Migration am 16.09.2026 ist die „Sonstiges"-Seite selbst entfallen, siehe Abschnitt 3.3/14 – das ⋮-Symbol öffnet jetzt direkt die vier Standard-Menüpunkte.)*

**11.5 Geplante Weiterentwicklung: „schwebende" Schläger-Auswahl**
Der Nutzer möchte die Schläger-Auswahl künftig „schwebend" direkt im Hauptbildschirm sehen (vermutlich ein permanent sichtbares oder leicht einblendbares Element, ohne eigenen Bildschirmwechsel) – ausdrücklich als späterer Arbeitsschritt benannt („damit verfahren wir später weiter"), nicht Teil dieser Umsetzung. Als **Zwischenlösung** wurde „Schläger" als Eintrag im ⋮-Menü einsortiert (bis 16.09.2026 unter „Sonstiges", seither als eigener Standard-Menüpunkt, siehe 3.3), damit die Funktion erreichbar bleibt. Diese Platzierung ist weiterhin bewusst vorläufig und wird durch das schwebende Design ersetzt, sobald dessen genaue Gestaltung spezifiziert ist.

**11.6 Technische Anpassung: Direktsprung statt Animation**
Beim Testen zeigte sich, dass ein Klick auf einen weit entfernten Reiter (z. B. von Loch 2 direkt zur Scorecard) mit sanfter Scroll-Animation kurzzeitig überlappende Seiteninhalte sichtbar machte. Da ein Registerreiter in einem echten Buch ohnehin einen sofortigen Sprung an die aufgeschlagene Stelle bewirkt (kein „Hindurchblättern"), wurde die Navigation per Reiter-Klick auf einen sofortigen Sprung ohne Animation umgestellt – behebt den optischen Effekt und entspricht zugleich besser der gewünschten Buch-Metapher. Die Wisch-Navigation (Ziehen mit dem Finger) bleibt unverändert flüssig/animiert. *(In der Flutter-Version: `PageController.jumpToPage()` für Reiter-Taps, natives animiertes Scrollen des `PageView` beim Wischen – siehe 14.)*

**Status:** Umgesetzt, mit Playwright/Chromium smoke-getestet (inkl. Prüfung der Reiter-aktiv-Zustände, des Zurück-Pfads über Sonstiges/Schläger und eines sauberen Scorecard-Screenshots nach der Direktsprung-Umstellung) und als Commit `74322b7` nach GitHub gepusht. Live-Status auf GitHub Pages konnte aus dieser Session heraus wie bereits in Abschnitt 9 beschrieben nicht programmatisch geprüft werden (kein Netzwerkzugriff auf github.io/api.github.com weder aus der Cloud-Umgebung noch vom Mac aus); der erfolgreiche Push gilt als Nachweis der Auslieferung.

---

## 12. Sprachauswahl auf die Startseite verlegt (umgesetzt am 15.09.2026)

Auf Wunsch des Nutzers sitzt die Sprachauswahl (Deutsch/Englisch/Niederländisch) jetzt nicht mehr im „Sonstiges"-Menü, sondern als kompakte Flaggen-Auswahl oben rechts auf der Startseite – direkt beim App-Start sichtbar und ohne Umweg über das Drei-Punkte-Menü erreichbar. Technisch wurde nur das bestehende Auswahl-Element an die neue Stelle verschoben und kompakter gestaltet (drei runde Flaggen-Buttons statt der früheren Zeile mit Sprachnamen); die zugrundeliegende Auswahl-Logik ist unverändert.

**Status:** Umgesetzt, mit Playwright/Chromium smoke-getestet (Sprachauswahl auf der Startseite geprüft, Abwesenheit im Sonstiges-Menü geprüft) und als Commit `ae6980d` nach GitHub gepusht.

---

## 13. Designmuster aus Loch 2 auf alle 9 Lochskizzen übertragen (umgesetzt am 15.09.2026)

Der Nutzer hat das in Abschnitt 12 (Änderungshistorie) erwähnte Designmuster für Loch 2 freigegeben („ja, bitte übertragen"). Die dort entwickelte, detailreichere Illustrationstechnik ist jetzt für alle 9 Lochskizzen aktiv:

- **Wasserhindernisse** mit Farbverlauf statt Volltonfarbe und zwei dünnen Wellenlinien für eine plastischere Wasseroberfläche.
- **Bunker** mit Sand-Textur (kleine Punkte) und einer feinen Schattenkante für mehr Tiefe.
- **Fairway** mit dezentem Mähstreifen-Effekt (schmale, versetzte Streifen, exakt auf die jeweilige Lochform zugeschnitten).
- **Grün** mit einem zusätzlichen, leicht durchscheinenden Fransensaum um die eigentliche Grünfläche.
- Zwei kleine **Tee-Markierungen** (Gold/Elfenbein) am Abschlagpunkt jedes Lochs.

Wichtig: Die individuell für jedes Loch abgestimmte Geometrie (Fairway-Verlauf, Lage von Wasser/Bunkern, Grünposition) aus der bisherigen Umsetzung (Pflichtenheft Punkt 10.5) wurde **nicht verändert** – nur die Zeichentechnik wurde vereinheitlicht und aufgewertet. Die im Designmuster gezeigte nummerierte Spiellinie (1–2–3, Abschlag/zweiter Schlag/Pitch) wurde bewusst **nicht** auf alle Löcher übertragen: Sie hätte für jedes Loch neu erfundene Wegpunkte erfordert, statt konsequent der bereits vorhandenen, realen Lochgeometrie zu folgen – das wäre eine Abweichung von „wie das Loch tatsächlich verläuft" gewesen. Diese Entscheidung wurde ohne Rückfrage getroffen, da der Freigabe-Wortlaut „übertragen" sich auf den gezeigten Illustrationsstil bezog.

**Status:** Umgesetzt, mit Playwright/Chromium smoke-getestet (bestehende Testsuite plus visuelle Einzelprüfung aller 9 Lochskizzen, keine JS-Fehler) und als Commit `d3320bb` nach GitHub gepusht. *(Dieser Stand wurde am 16.09.2026 1:1 nach Flutter portiert, siehe Abschnitt 14 – die hier beschriebene Zeichentechnik ist die Grundlage für `hole_sketch_painter.dart`.)*

Nutzer-Feedback zu diesen Lochskizzen (15.09.2026, noch nicht umgesetzt): insgesamt nicht attraktiv genug, sollen deutlich größer werden (bildschirmfüllend), weniger verspielt/mehr wie eine taktische Karte wirken, gerade statt geschwungene Linien nutzen, näher am Realismus der echten Platztafeln sein und die Ausrichtung drehen (Fahne/Grün immer oben, Abschlag immer unten). Auf ausdrücklichen Wunsch **nicht** in der App umgesetzt oder deployt, sondern vier alternative Stil-Entwürfe ausschließlich für Loch 2 in einem separaten Design-Canvas ergänzt (siehe Änderungshistorie 15.09.2026): „Vermessungstafel-Realismus", „Taktische Karte/Yardage-Book", „Topografische Kontur-Karte" und „Blaupause/Technische Zeichnung". Entscheidung über die Richtung liegt weiterhin beim Nutzer; siehe Backlog (Abschnitt 8) und 14.6.

---

## 14. Flutter-Migration (ab 16.09.2026)

### 14.1 Anlass

Am 16.09.2026 wurde ein neuer, für **alle** Apps von Carsten Rösner verbindlicher App-Entwicklungsstandard eingeführt (Referenz-Implementierung: `spraytattoo_katalog`). Er schreibt Flutter/Dart mit Material 3, `provider`-State-Management, eine feste `lib/`-Projektstruktur, ein Standard-⋮-Menü (Funktionsumfang/Schläger.../Problem melden/Über diese App), eine automatisierte GitHub-Actions-CI/CD-Pipeline mit echten `flutter test`-Tests als Deploy-Gate sowie eine in der App selbst einsehbare Anforderungsdokumentation vor. GCWBB widersprach diesem Standard in allen Punkten (Vanilla-JS statt Flutter, kein CI/CD-Workflow, kein `flutter test`, kein In-App-Funktionsumfang-Screen). Dem Standard folgend wurde dies dem Nutzer aktiv gemeldet, statt stillschweigend abzuweichen oder unaufgefordert umzubauen. **Der Nutzer hat sich für eine vollständige Migration auf Flutter entschieden** (statt Vanilla-JS als dauerhafte Ausnahme zu behalten).

### 14.2 Getroffene Entscheidungen

- **Menü/IA:** ⋮-Menü mit genau 4 Einträgen (Funktionsumfang, Schläger, Problem melden, Über diese App). „Kontakt" faltet in „Über diese App" statt eines eigenen Punkts. „Schläger" bleibt ein normaler, über das Menü erreichbarer Bildschirm (keine „schwebende" Lösung – die bleibt Backlog, siehe 8/11.5).
- **Lochskizzen-Stil:** Der bisherige Stil (Abschnitt 10.5/13) wird zunächst **1:1 nach Flutter portiert**, nicht neu gestaltet. Geometrie (`lib/models/hole_sketch_def.dart`, `lib/content/hole_sketch_defs.dart`) und Zeichen-Layer (`lib/widgets/hole_sketch_painter.dart`) sind bewusst sauber getrennt, damit eine spätere Neugestaltung (siehe 13, Design-Canvas-Entwürfe) ein reiner Austausch des Zeichen-Layers ist, ohne die Migration zu blockieren.
- **Pflichtenheft:** Dieses Dokument zieht von `claude/pflichtenheft-gcwbb.md` in den Repo-Root als `PFLICHTENHEFT.md` um; die vollständige Historie bleibt erhalten (kein Neuanfang).
- **i18n:** handgerollter `Map<String,Map<String,String>>`-Übersetzungs-Service (`lib/services/locale_service.dart`) als 1:1-Port der bisherigen `I18N`/`t()`-Struktur aus `js/i18n.js` – kein ARB-Codegen, da nur 3 Sprachen und keine Pluralisierung nötig sind.
- **Build-Umgebung:** Weder im Cloud-Arbeitsbereich dieser Session noch über die Geräte-Verbindung zum Mac war das Flutter-SDK erreichbar (Downloads von `storage.googleapis.com`/`dl.google.com`/`pub.dev` von der Netzwerk-Freigabeliste blockiert). Der Dart-Code wurde daher sorgfältig von Hand geschrieben (Quelldaten vor der Übernahme jeweils per Vergleich mit `js/app.js`/`js/data.js`/`js/i18n.js` gegengeprüft), die GitHub-Actions-Pipeline (mit vollem Internetzugriff) dient als alleiniges reales `flutter test`/`flutter build`-Gate.

### 14.3 Neue Projektstruktur

```
lib/
  theme/     – app_theme.dart, golf_palette.dart (OKLCH → Hex portierte Design-Tokens)
  models/    – hole.dart, hole_scorecard.dart, course_info.dart, club.dart, round.dart, hole_sketch_def.dart
  content/   – course_data.dart, default_clubs.dart, hole_sketch_defs.dart, feature_overview_content.dart
  services/  – locale_service.dart, clubs_service.dart, rounds_service.dart (alle ChangeNotifier, via MultiProvider)
  screens/   – start_screen.dart, existing_rounds_screen.dart, main_pager_screen.dart, clubs_screen.dart,
               feature_overview_screen.dart, report_issue_dialog.dart, about_dialog.dart
  widgets/   – hole_sketch_painter.dart, hole_sketch.dart, book_tab_rail.dart, round_settings_page.dart,
               hole_page.dart, scorecard_page.dart, lang_flag_row.dart, club_list_item.dart, club_edit_row.dart
  main.dart  – MultiProvider + Init-Gate mit kurzem Splash
test/        – Unit-/Service-/Widget-Tests, siehe 14.5
.github/workflows/deploy-web.yml – CI/CD nach Referenzmuster spraytattoo_katalog
```

### 14.4 Feature-Parität

Alle Inhalte und Funktionen der bisherigen Vanilla-JS-Version (Abschnitt 3, 9–13) wurden 1:1 übernommen: Start mit Neue-Runde/Bestehende-Runden und Sprachzeile, Rundeneinstellungen mit 9-/18-Loch-Toggle, Buchregister-Pager mit Wisch- und Direktsprung-Navigation, individuelle Lochskizzen (zeichengenau portierte SVG-Pfade), Schläger-Verwaltung mit Bulk-Edit, Scorecard mit Vorne/Hinten-Umschalter und lokaler Persistenz, sowie der „Problem melden"-Flow ohne Token im Client (Owner/Repo/Labels identisch, siehe 10.6). Neu hinzugekommen ist ausschließlich der vom Standard geforderte „Funktionsumfang"-Screen.

### 14.5 Umsetzungsstand

**Abgeschlossen (16.09.2026).** Vollständig umgesetzt: Projekt-Scaffold, `lib/theme/`, `lib/models/`, `lib/content/`, `lib/services/`, `main.dart`, `hole_sketch_painter.dart`/`hole_sketch.dart`, alle Pager-Widgets, alle ⋮-Menü-Ziele, `main_pager_screen.dart`, Start-/Rundenverlauf-/Sprach-Widgets, `clubs_screen.dart` mit Sub-Widgets, sowie eine Test-Suite (`widget_test.dart`, `hole_sketch_defs_test.dart`, `rounds_service_test.dart`, `clubs_service_test.dart`, `clubs_screen_test.dart`, `locale_service_test.dart`, `report_issue_dialog_test.dart`, `scorecard_page_test.dart`, `main_pager_flow_test.dart`) sowie der CI/CD-Workflow und `pubspec.yaml`. Nach GitHub gepusht (finaler Commit `ff73d25`), GitHub-Actions-Lauf grün (`flutter test`, `flutter build web --release`, Deploy), GitHub-Pages-Deploy-Quelle erfolgreich auf „GitHub Actions" umgestellt (`build_type: workflow`), Live-Version unter https://carstenroesner.github.io/gc-winterberg-birdie-book/ im Browser verifiziert (Start/Sprachzeile, Neue Runde → Rundeneinstellungen zuerst, 9-/18-Loch-Umschalter inkl. Tab-Rail-Sichtbarkeit, Lochskizze Loch 2, Scorecard mit echten Werten für Loch 2 und „–" für die übrigen, alle 4 ⋮-Menüpunkte inkl. Funktionsumfang- und Über-Dialog-Inhalt, Schläger-Liste mit 12 Standardschlägern).

Bei der Diagnose zeigte sich zusätzlich ein echter (kein Test-)Bug: `ClubsService.saveEdit()` speicherte den Schläger-Namen ungetrimmt (führende/nachgestellte Leerzeichen blieben erhalten). Behoben durch Trimmen beim Übernehmen aus dem Bearbeitungspuffer.

**Nachbesserung (17.09.2026): Schriften lokal statt per Netzwerk laden.** Nutzer meldete per Screenshot vom Mobilgerät (Loch-Detailseite), dass Layout/Typografie nicht mehr dem gewohnten Erscheinungsbild entsprachen – fette serifenlose Systemschrift statt Manrope/Cormorant Garamond, ⋮-Menü- und Neue-Runde-Symbol als falsche Fallback-Glyphen statt der Material-Icons. Ursache: `app_theme.dart` lud Manrope und Cormorant Garamond zur Laufzeit per `google_fonts`-Paket von Googles CDN (`fonts.googleapis.com`/`fonts.gstatic.com`); auf einer langsameren mobilen Verbindung (z. B. auf dem Golfplatz) blieb die App im initialen Fallback-Zustand hängen bzw. dieser dauerte sichtbar lange – reproduziert auch im eigenen Testbrowser als kurzes Fallback-Fenster direkt nach dem Laden. Fix: beide Schriften als lokale Variable-Font-Dateien unter `assets/fonts/` gebündelt (`pubspec.yaml`, `fonts:`-Sektion), `google_fonts`-Abhängigkeit entfernt, `app_theme.dart` nutzt jetzt `fontFamily` direkt aus dem Asset-Bundle – kein externer Netzwerk-Round-Trip mehr, Schriften sind Teil des einen App-Deployments und werden vom PWA-Service-Worker mitgecacht.

### 14.6 Noch zu erledigen

- Logo-Auflösung (Punkt 14 in Abschnitt 6) bleibt unabhängig von der Migration offen.
- Entscheidung über die Neugestaltung der Lochskizzen (Abschnitt 13, vier Design-Canvas-Entwürfe) bleibt offen und unabhängig von dieser Migration – dank der getrennten Architektur (14.2) jederzeit nachrüstbar.
- **Test-Anhang (Nutzerwunsch vom 17.09.2026, Umsetzung erst beim nächsten Compile-/Deploy-Zyklus):** Sowohl diesem Pflichtenheft als auch dem In-App-„Funktionsumfang"-Screen (`feature_overview_content.dart`) soll ein Anhang hinzugefügt werden, der die vorhandenen automatisierten Tests (`test/*.dart`, per `flutter test` in der CI ausgeführt) auflistet – je Testdatei die geprüften Fälle. Ausdrücklich noch nicht jetzt umzusetzen, sondern beim nächsten ohnehin anstehenden Code-/Deploy-Zyklus mit zu erledigen.

---

*Änderungshistorie*
- 14.09.2026: Erstfassung auf Basis der Anforderungsbeschreibung.
- 14.09.2026: Logo ergänzt, erste Beispieldesigns erstellt (5a).
- 14.09.2026: Design-Anhang mit Screenshots wieder entfernt (auf Wunsch – reine Textfassung).
- 14.09.2026: Loch-Charakteristiken und Platz-Kenndaten von golfclub-winterberg.de/9-loch-turnierplatz eingearbeitet (4a, 5b).
- 14.09.2026: Offizielle Vorgabewirksame Tabelle (CR/Slope/Par je Abschlag, DGV-STV→DGV-SPV) vom Nutzer ergänzt (5c); Website-CR/Slope-Werte entsprechend korrigiert.
- 14.09.2026: Offene Punkte 3, 5, 8, 9, 10, 12 geklärt (Distanzdaten-Quelle, Schläger-Standardsatz inkl. editierbarem Distanzbereich mit recherchierten Default-Werten (4b, 5d), zunächst ein Spieler, zunächst lokale Speicherung, drei Sprachen mit Flaggenauswahl, App-Icon = Vereinslogo); Punkt 13 auf neu angelegtes Backlog (Abschnitt 8) verschoben.
- 14.09.2026: Erste lauffähige Version 0.1 als PWA gebaut und ausgeliefert (Abschnitt 9); lokales Git-Repository angelegt (kein GitHub-Push, da kein GitHub-Zugriff in dieser Session); neuer offener Punkt 14 (Logo-Auflösung) ergänzt.
- 14.09.2026: Repository erfolgreich nach GitHub gepusht (privates Repo `carstenroesner/gc-winterberg-birdie-book`, gleicher Account wie Spray Vorlagen); Punkt 11 damit geklärt.
- 14.09.2026: GitHub Pages aktiviert; App öffentlich unter https://carstenroesner.github.io/gc-winterberg-birdie-book/ erreichbar (Abschnitt 9).
- 14.09.2026: Layout-Fix Startseite (Footer-Text) sowie neuer Schläger-Mehrfach-Bearbeitungsmodus (Auswahl statt Direkt-Modal, Bearbeiten/Abbrechen/Speichern) umgesetzt, getestet und committet.
- 15.09.2026: Diese Fixes nach GitHub gepusht (Commit `2fa18ed`); GitHub Pages baut automatisch neu, Live-Version unter https://carstenroesner.github.io/gc-winterberg-birdie-book/ in Kürze aktuell.
- 15.09.2026: Ersten Teil einer angekündigten Änderungskette (Rundeneinstellungen, 9-/18-Loch-Umschalter, neue Reihenfolge Einstellungen→Löcher→Scorecard, Wisch-Navigation) als Spezifikation aufgenommen (Abschnitt 10) – Umsetzung auf ausdrücklichen Wunsch zurückgestellt.
- 15.09.2026: Handgezeichnete Referenzskizze des Nutzers ausgewertet und als Punkt 10.5 ergänzt (Lochnummern als vertikale Liste statt runder Buttons; handgezeichneter, individueller Lochskizzen-Stil statt generischer Platzhalter) – weiterhin nur Spezifikation, keine Umsetzung.
- 15.09.2026: „Über"/„Kontakt" nach Vorbild der Referenz-App spraytattoo_katalog spezifiziert (Punkt 10.6): einfacher Info-Dialog bzw. „Problem melden"-Dialog mit Weiterleitung zu vorausgefüllter GitHub-Issue-URL, kein Token in der App; offene Frage zum privaten Repo ergänzt. Weiterhin keine Umsetzung.
- 15.09.2026: Nutzer hat die Umsetzung der gesamten Änderungskette aus Abschnitt 10 freigegeben. Umgesetzt: Rundeneinstellungen-Bildschirm mit 9-/18-Loch-Toggle, Löcher+Scorecard als Wisch-Pager, vertikale Lochlisten mit Trennlinien, 9 individuelle Lochskizzen, „Problem melden"-Dialog mit token-freier GitHub-Issue-URL. Abschnitt 3 (3.1a, 3.2, 3.3, 3.5) auf den neuen Ist-Zustand aktualisiert, Punkt 7 in Abschnitt 6 als erledigt markiert, offene Detailfragen zu Abschnitt 10 mit den getroffenen Annahmen beantwortet. Mit Playwright/Chromium smoke-getestet (inkl. echter GitHub-Issue-URL-Prüfung ohne Token-Leck) und als Commit `69d412c` nach GitHub gepusht.
- 15.09.2026: Auf Wunsch des Nutzers beide GitHub-Repositories (GCWBB und spraytattoo_katalog) von privat auf öffentlich umgestellt (Abschnitt 2, 10.6) – reine Repo-Einstellung über die GitHub-API, keine Codeänderung. Frage nach anonymer Issue-Erstellung recherchiert und beantwortet: GitHub erfordert dafür immer ein eingeloggtes Konto, auch bei öffentlichen Repos (10.6); das ist eine Plattformgrenze, keine App-Einschränkung. Neuer Backlog-Punkt ergänzt (Abschnitt 8): Pflichtenheft soll künftig zusätzlich als erreichbare Website verfügbar sein – die Referenz-App spraytattoo_katalog wurde geprüft, hat aber kein vergleichbares Vorbild (ihr Pages-Deploy veröffentlicht nur die gebaute App, nicht ihre Doku); Umsetzung ausdrücklich noch nicht angefordert.
- 15.09.2026: Buchregister-Redesign umgesetzt (Abschnitt 11): plastische, schattierte Reiter-Optik für die Lochlisten; neuer Reiter „Rundeneinstellungen" (Zahnrad) über Loch 1; Scorecard-Reiter wandert je nach 9-/18-Loch-Auswahl unter Loch 9 bzw. Loch 18; Fußmenü vollständig entfernt und durch ein Drei-Punkte-Menü im Kopfbereich ersetzt (öffnet die neu mit Zurück-Pfeil versehene „Sonstiges"-Seite); Schläger-Zugriff vorläufig in „Sonstiges" einsortiert, bis die vom Nutzer gewünschte „schwebende" Schläger-Auswahl im Hauptbildschirm später spezifiziert wird; Reiter-Navigation auf Direktsprung statt Scroll-Animation umgestellt (behebt einen optischen Überlapp-Effekt bei weiten Sprüngen). Mit Playwright/Chromium smoke-getestet und als Commit `74322b7` nach GitHub gepusht.
- 15.09.2026: Sprachauswahl von der Sonstiges-Seite auf die Startseite verlegt (Abschnitt 12), dort als kompakte Flaggen-Auswahl oben rechts. Mit Playwright/Chromium smoke-getestet und als Commit `ae6980d` nach GitHub gepusht. Außerdem: als separates Designmuster (nicht Teil der ausgelieferten App) eine Illustrations-Variante für Loch 2 als Design-Canvas erstellt, um eine mögliche Weiterentwicklung der Lochskizzen zu zeigen.
- 15.09.2026: Auf Freigabe des Nutzers die im Designmuster gezeigte Illustrationstechnik auf alle 9 Lochskizzen übertragen (Abschnitt 13): Wasser mit Verlauf und Wellenlinien, Bunker mit Sand-Textur und Schattenkante, Mähstreifen-Effekt im Fairway, Fransensaum am Grün, Tee-Markierungen am Abschlag – jeweils auf Basis der bereits vorhandenen, individuellen Lochgeometrie. Mit Playwright/Chromium smoke-getestet (inkl. visueller Einzelprüfung aller 9 Löcher) und als Commit `d3320bb` nach GitHub gepusht.
- 15.09.2026: Nutzer-Feedback zu den unter Abschnitt 13 ausgelieferten Lochskizzen: insgesamt nicht attraktiv genug, sollen deutlich größer werden (bildschirmfüllend), weniger verspielt/mehr wie eine taktische Karte wirken, gerade statt geschwungene Linien nutzen, näher am Realismus der echten Platztafeln sein und die Ausrichtung drehen (Fahne/Grün immer oben, Abschlag immer unten). Auf ausdrücklichen Wunsch **nicht** in der App umgesetzt oder deployt, sondern vier alternative Stil-Entwürfe ausschließlich für Loch 2 im bestehenden Design-Canvas ergänzt: „Vermessungstafel-Realismus" (Pergament-Ton, Kompassrose, Schraffur), „Taktische Karte/Yardage-Book" (kräftige Flächenfarben, Distanz-Badges), „Topografische Kontur-Karte" (Höhenlinien-Hintergrund, gedämpfte Erdtöne) und „Blaupause/Technische Zeichnung" (dunkler Blaupausen-Look mit Maßlinien). Alle vier nutzen dieselbe geradlinige, facettierte Fairway-Geometrie (statt der bisherigen weichen Kurven) und die gewünschte Ausrichtung mit Grün oben/Abschlag unten. Entscheidung über die Richtung liegt beim Nutzer; noch keine Umsetzung in der App.
- 16.09.2026: Neuer, für alle Apps verbindlicher App-Entwicklungsstandard eingeführt (Flutter/Dart, Material 3, Standard-⋮-Menü, GitHub-Actions-CI mit `flutter test`-Gate, Pflichtenheft auch in der App einsehbar); GCWBB wurde als abweichend identifiziert und dem Nutzer aktiv gemeldet. Nutzer hat sich für eine vollständige Migration auf Flutter entschieden (statt Vanilla-JS als Ausnahme).
- 16.09.2026: Migrationsplan erarbeitet und vom Nutzer freigegeben: ⋮-Menü mit 4 Einträgen (Funktionsumfang/Schläger/Problem melden/Über diese App, Kontakt faltet in Über), bisheriger Lochskizzen-Stil wird zunächst 1:1 portiert (Geometrie/Rendering sauber getrennt), ein späteres Redesign (siehe Abschnitt 13) bleibt davon unabhängig möglich (Abschnitt 14).
- 16.09.2026: Flutter-Web-Projekt vollständig aufgebaut (`lib/theme`, `lib/models`, `lib/content`, `lib/services`, `lib/screens`, `lib/widgets`, `test/`) mit 1:1-Feature-Parität zur bisherigen Vanilla-JS-Version, inkl. zeichengenau portierter Lochskizzen-Geometrie und aller bisherigen Inhalte (Loch-Charakteristiken, Schläger-Standardsatz, i18n). GitHub-Actions-Workflow und Test-Suite nach Referenzmuster (spraytattoo_katalog) ergänzt. Dieses Dokument von `claude/pflichtenheft-gcwbb.md` nach `PFLICHTENHEFT.md` im Repo-Root migriert (Abschnitt 14).
- 16.09.2026: Migration abgeschlossen. Beim ersten CI-Lauf schlugen mehrere Widget-Tests fehl; über die Check-Run-Annotations-API diagnostiziert (Rohlogs sind über die Proxy-Freigabeliste blockiert), da mit temporären Diagnose-Schritten im Workflow nachgebessert werden musste. Ursachen waren ausschließlich Test-Annahmen, die legitime Duplikate bzw. Lazy-Rendering nicht berücksichtigten (doppelt vorkommender Text „Rundeneinstellungen"/Par-Wert „5", nicht gescrollter „Schläger hinzufügen"-Button), sowie ein echter Anwendungsfehler: `ClubsService.saveEdit()` trimmte den Schläger-Namen nicht vor dem Speichern. Alle Testdateien und der Anwendungscode entsprechend korrigiert, der Diagnose-Schritt danach wieder auf die einfache Form `flutter test` zurückgebaut (Commit `ff73d25`). GitHub-Actions-Lauf danach grün (Tests, Build, Deploy). GitHub-Pages-Deploy-Quelle auf „GitHub Actions" umgestellt. Live-Version unter https://carstenroesner.github.io/gc-winterberg-birdie-book/ im Browser verifiziert (Start, Rundeneinstellungen, 9-/18-Loch-Umschalter, Lochskizze, Scorecard, alle ⋮-Menüpunkte, Schläger-Liste). Damit ist Abschnitt 14 vollständig abgeschlossen.
- 17.09.2026: Nutzer meldete per Screenshot vom Mobilgerät, dass Layout/Typografie der Live-Version nicht mehr dem gewohnten Erscheinungsbild entsprachen (Systemschrift statt Manrope/Cormorant Garamond, falsche Fallback-Icons statt Material-Icons). Ursache diagnostiziert und im eigenen Testbrowser reproduziert: `google_fonts` lud beide Schriften zur Laufzeit von Googles CDN, was auf langsameren mobilen Verbindungen zu einem sichtbaren bzw. anhaltenden Fallback-Zustand führte. Fix: Manrope und Cormorant Garamond als lokale Variable-Font-Assets gebündelt (`assets/fonts/`, `pubspec.yaml`), `google_fonts`-Abhängigkeit entfernt (Abschnitt 14.5).
- 17.09.2026: Weiteres Nutzer-Feedback per Screenshot (Loch-Detailseite): die Buchregister-Reiter (Löcher, Zahnrad, Scorecard) stapelten sich nur oben im Bildschirm, der restliche Platz darunter blieb ungenutzt leer. Ursache: `BookTabRail` war eine `Column` mit `mainAxisSize.min` ohne vorgegebene Höhe vom Eltern-Layout. Fix: `main_pager_screen.dart` gibt der Reiterleiste über `CrossAxisAlignment.stretch` die volle verfügbare Höhe, `BookTabRail` verteilt die Tabs jetzt mit `mainAxisSize.max` und `MainAxisAlignment.spaceBetween` gleichmäßig von oben bis unten – in 9- und 18-Loch-Modus live verifiziert.
- 17.09.2026: Nutzer-Feinschliff zur Reiterleiste: die Verteilung war zwar korrekt, die einzelnen Reiter sollten aber als eine durchgehende, flächige Leiste aneinanderschließen (statt einzelner Kacheln mit Zwischenraum), zusätzlich unten 5 % der Bildschirmhöhe Sicherheitsabstand, da die abgerundete Display-Ecke des iPhone Pro den untersten Reiter sonst stört. Fix: `BookTabRail` von `spaceBetween`-verteilten einzelnen `Material`-Kacheln auf eine einzige `ClipRRect`/`Material`-Hülle mit nur außen abgerundeten Ecken umgestellt, darin eine `Column` aus `Expanded`-Zellen mit dünnen Trennlinien zwischen den Zellen (keine Lücken mehr); `main_pager_screen.dart` berechnet `MediaQuery.of(context).size.height * 0.05` und addiert diesen Wert als zusätzlichen unteren Innenabstand auf beide Reiterleisten. In 9- und 18-Loch-Modus live verifiziert, Tab-Navigation weiterhin per Antippen funktionsfähig (Commit `e31be99`).
- 17.09.2026: Nutzer hat per Screenshot die eigentlich gewünschte Darstellung nachgereicht: die vorherige „flächige" Umsetzung (17.09.2026, `e31be99`) traf den gewünschten Look nicht – korrekt sind einzelne, ringsum abgerundete Reiter-Kacheln mit schmalen Zwischenräumen, wobei der aktive Reiter breiter ist und sichtbar in Richtung Seiteninhalt heraus „poppt". `BookTabRail` entsprechend umgebaut: jede Zelle hat wieder ihr eigenes `Material` mit eigenem Radius/Schatten statt einer gemeinsamen Hülle; die Vollhöhen-Verteilung (`Expanded` je Reiter) und der 5-%-Sicherheitsabstand unten bleiben erhalten. In 9- und 18-Loch-Modus live verifiziert (Commit `813680c`).
- 17.09.2026: Neue Funktion „Runde versenden/löschen" in „Bestehende Runden" umgesetzt (Abschnitt 3.1/5): Swipe nach links auf einer gespeicherten Runde blendet zwei Aktionen ein. „Löschen" entfernt die Runde nach Sicherheitsabfrage endgültig (`RoundsService.deleteRound()`). „Versenden" erzeugt die Scorecard der Runde als PDF (`ScorecardPdfService`, Paket `pdf`, Tabelle mit Loch/Par/HCP/Herren/Damen/Score sowie Score-Summe) und ruft darüber die System-Weiterleitungsfunktion des Geräts auf (Paket `printing`, `Printing.sharePdf` – Share-Sheet unter iOS/Android, Web-Share-API bzw. Datei-Download als Fallback im Browser). Die Swipe-Geste selbst nutzt das Paket `flutter_slidable`. Neue Tests: `deleteRound` in `rounds_service_test.dart`, `scorecard_pdf_service_test.dart` (gültige PDF-Bytes für 9-/18-Loch-Runden), `existing_rounds_screen_test.dart` (Swipe-Aktionen mit korrektem Label im Widget-Baum vorhanden). Bekannte Einschränkung ergänzt: Datei-Share funktioniert je nach Browser/Plattform unterschiedlich, Fallback ist ein normaler Download.
