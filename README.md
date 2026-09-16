# GC Winterberg Birdie Book (GCWBB)

Digitales "Birdie Book" für den 9-Loch-Turnierplatz des GC Winterberg:
Lochübersicht mit Skizze, Schlägerwahl, Scorecard und Vereinsinfos während
der Runde.

Gebaut mit Flutter (Web), nach dem für alle Apps von Carsten Rösner
verbindlichen Entwicklungsstandard (Referenz-Implementierung:
[spraytattoo_katalog](https://github.com/carstenroesner/spraytattoo_katalog)).

Die vollständige Anforderungsdokumentation – Zweck, Entscheidungen, offene
Punkte, Änderungshistorie – steht in [`PFLICHTENHEFT.md`](./PFLICHTENHEFT.md)
sowie im ⋮-Menü der App unter "Funktionsumfang".

## Live-Version

https://carstenroesner.github.io/gc-winterberg-birdie-book/

## Entwicklung

```bash
flutter pub get
flutter test
flutter run -d chrome
```

## Deploy

Push auf `master` löst automatisch `.github/workflows/deploy-web.yml` aus:
Tests laufen (blockierend), danach Build und Deploy auf GitHub Pages.
