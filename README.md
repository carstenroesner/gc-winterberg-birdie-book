# GCWBB – GC Winterberg Birdie Book

Digitales Birdie Book für den 9-Loch-Turnierplatz des GC Winterberg: Löcher-Übersicht mit Skizze, Schläger-Verwaltung, Scorecard und Vereinsinfos. Erste Version als **Progressive Web App** (Vanilla HTML/CSS/JS, keine Build-Tools, keine Abhängigkeiten außer Google Fonts).

Details zu Anforderungen, offenen Punkten und Backlog siehe das begleitende Pflichtenheft (separates Dokument im Claude-Projekt „App-Entwicklung").

## Lokal starten

Kein Build-Schritt nötig – einfach über einen beliebigen statischen Webserver ausliefern, z. B.:

```bash
python3 -m http.server 8000
# dann im Browser: http://localhost:8000
```

## Deployment (GitHub Pages)

1. Repository auf GitHub anlegen (privat, siehe Pflichtenheft Abschnitt 5) und diesen Ordner pushen.
2. In den Repo-Einstellungen unter **Pages** die Quelle auf den Branch `main` (Root) stellen.
3. Die App ist danach unter `https://<user>.github.io/<repo>/` erreichbar und über den Browser als PWA installierbar ("Zum Startbildschirm hinzufügen").

## Funktionsumfang (Stand dieser ersten Version)

- Start: „Neue Runde" (leerer Zustand) / „Bestehende Runden" (Verlaufsliste aus `localStorage`)
- Hauptbildschirm: Lochauswahl vordere/hintere Neun, Platzhalter-Lochskizze, Charakteristik-Text, Par/HCP/Distanzen (echte Werte nur für Loch 2/11, sonst „–")
- Schläger: Standardsatz mit editierbarem Distanzbereich, Hinzufügen/Bearbeiten/Löschen eigener Schläger
- Scorecard: vordere/hintere Neun umschaltbar, Score-Eingabe pro Loch, persistiert je Runde
- Sonstiges: Über, Kontakt, Sprachumschaltung (Deutsch/Englisch/Niederländisch) für die App-Oberfläche
- Installierbar als PWA (Manifest + Service Worker, Offline-Grundcache)

## Bekannte Lücken / offene Punkte

Siehe Pflichtenheft Abschnitt 6 (offene Punkte) und Abschnitt 8 (Backlog). Insbesondere:

- Lochskizzen sind aktuell ein generischer Platzhalter-Stil für alle 9 Bahnen (keine individuellen Formen aus den Referenzfotos).
- Distanz-/Par-/HCP-Daten liegen nur für Loch 2/11 vollständig vor; übrige Bahnen zeigen „–".
- Vereinslogo liegt nur in 70×70 px vor – die generierten App-Icons (bis 512×512) sind entsprechend niedrig aufgelöst; für Produktionsqualität wird eine höher aufgelöste Logo-Datei benötigt.
- Datenspeicherung ist aktuell rein lokal (`localStorage`); iCloud-Sync, Mehrspieler-Erfassung und automatische Vorgabewirksame-Berechnung sind Backlog-Punkte.
- Diese Version ist ungetestet auf echten Endgeräten (bislang nur Smoke-Test mit Playwright/Chromium im Entwicklungscontainer).

## Struktur

```
index.html            Einzige HTML-Seite (alle Screens als Sections, per JS umgeschaltet)
css/styles.css         Design-System (Farben, Typografie, Komponenten)
js/data.js              Statische Ausgangsdaten (Löcher, Platzinfos, Schläger-Standardsatz)
js/i18n.js               Übersetzungen DE/EN/NL für die Oberfläche
js/app.js                 App-Logik, Rendering, localStorage-Persistenz
manifest.webmanifest    PWA-Manifest
service-worker.js       Offline-Cache
icons/, assets/         App-Icons und Logo (aus dem Vereinslogo generiert)
```
