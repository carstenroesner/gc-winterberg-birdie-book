// GCWBB – Statische Ausgangsdaten
// Quellen: golfclub-winterberg.de/9-loch-turnierplatz (Charakteristik-Texte,
// Referenzgrafiken), Vor-Ort-Ausschilderung aller 9 Bahnen (Fotos der
// Bahntafeln, vom Nutzer am 17.09.2026 hochgeladen; Par/HCP/Distanzen für
// alle 9 Bahnen vollständig erfasst), offizielle Vorgabewirksame Tabelle
// (CR/Slope/Par).
// Zeichengenau portiert aus js/data.js der bisherigen Vanilla-JS-App.

import '../models/course_info.dart';
import '../models/hole.dart';
import '../models/hole_scorecard.dart';

const CourseInfo courseInfo = CourseInfo(
  clubName: 'GC Winterberg',
  address: 'In der Büre 20, 59955 Winterberg',
  phone: '02981 1770',
  email: 'info@golfclub-winterberg.de',
  web: 'golfclub-winterberg.de',
  greenfeeFrom: '30 €',
  tees: {
    'herren': TeeInfo(name: 'Schanze', color: 'gelb', cr: 70.9, slope: 135, par: 70),
    'damen': TeeInfo(name: 'Bob', color: 'rot', cr: 73.6, slope: 134, par: 70),
  },
);

// 9 Bahnen, jeweils von vorderem (n) und hinterem (n+9) Abschlag gespielt.
const List<Hole> holes = [
  Hole(
    n: 1,
    title: 'Abschlag am Clubhaus',
    text:
        'Ein guter Abschlag zur linken Seite des Fairway ist wichtig, denn auf der rechten könnte der Ball sonst im Teich landen. Der zweite Schlag muss lang genug sein, um Carry aufs Grün zu kommen, sonst wandert der Ball zu lang auf dem sehr abschüssigen Fairway. Am sichersten ist es, den Ball kurz aufkommen zu lassen, dass er zum Grün rollt.',
    refImage:
        'https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn1_03160c67a6-153x300.gif',
    scorecard: HoleScorecard(
      par: 4,
      hcp: SideValues(front: 3, back: 4),
      herren: SideValues(front: 397, back: 392),
      damen: SideValues(front: 364, back: 364),
    ),
  ),
  Hole(
    n: 2,
    title: 'Ein klassisches Par 5',
    text:
        'Bis auf das kleinste Grün des Platzes werden drei Schläge benötigt, denn dieses Doppel-Dogleg ist mit zwei Schlägen kaum zu bewältigen. Der Abschlag muss vor dem Wassergraben liegen, der zweite rechts vom Fairway-Bunker. Von dort benötigen Sie einen sehr genauen Pitch, um das Grün zu treffen.',
    refImage:
        'https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn2_798ba9e2ba-145x300.gif',
    scorecard: HoleScorecard(
      par: 5,
      hcp: SideValues(front: 11, back: 12),
      herren: SideValues(front: 450, back: 438),
      damen: SideValues(front: 406, back: 395),
    ),
  ),
  Hole(
    n: 3,
    title: 'Kurze Distanz',
    text:
        'Die dritte Bahn ist die kürzeste auf dem Platz. Ein mittleres bis kurzes Eisen wird empfohlen für den Schlag bis zum Grün. Genauigkeit ist wichtig, da die Distanz zur Ausgrenze sehr kurz ist.',
    refImage:
        'https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn3_8d81eb7245-157x300.gif',
    scorecard: HoleScorecard(
      par: 3,
      hcp: SideValues(front: 17, back: 18),
      herren: SideValues(front: 154, back: 137),
      damen: SideValues(front: 151, back: 137),
    ),
  ),
  Hole(
    n: 4,
    title: 'Das Wasser überbrücken',
    text:
        'Der Abschlag zur vierten Bahn sollte sehr nach links angehalten werden, da das Fairway zur rechten Seite hin sehr schräg wird. Ein langer zweiter Schlag ist wichtig, um das Wasser vor dem Grün zu überbrücken.',
    refImage:
        'https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn4_d8eedc6d3f-147x300.gif',
    scorecard: HoleScorecard(
      par: 4,
      hcp: SideValues(front: 9, back: 10),
      herren: SideValues(front: 323, back: 305),
      damen: SideValues(front: 291, back: 251),
    ),
  ),
  Hole(
    n: 5,
    title: 'Es geht bergauf',
    text:
        'An der fünften Bahn geht es bergauf. Beim Abschlag sollte man sich links halten, da auf der rechten Seite der tiefste Bunker des Platzes liegt.',
    refImage:
        'https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn5_2ee2031a40-157x300.gif',
    scorecard: HoleScorecard(
      par: 3,
      hcp: SideValues(front: 13, back: 14),
      herren: SideValues(front: 169, back: 148),
      damen: SideValues(front: 164, back: 148),
    ),
  ),
  Hole(
    n: 6,
    title: 'Sechstes und Längstes',
    text:
        'Die sechste ist die längste Bahn des Golfplatzes Winterberg. Der Abschlag muss vor dem Graben liegen. Hier sind zwei gute, genaue Schläge nötig, um das Grün zu erreichen. Das Grün wird von zwei großen Bunkern verteidigt.',
    refImage:
        'https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn6_4069a413a5-160x300.gif',
    scorecard: HoleScorecard(
      par: 5,
      hcp: SideValues(front: 7, back: 8),
      herren: SideValues(front: 477, back: 456),
      damen: SideValues(front: 437, back: 420),
    ),
  ),
  Hole(
    n: 7,
    title: '400 Meter – 4 Schläge',
    text:
        'Die siebte Bahn ist die schwierigste des Platzes. Gut 400 Meter müssen überbrückt werden. Am idealsten geht der erste Schlag schräg in die linke Fairway-Hälfte. Nach etwa 225 Metern vom ersten Abschlag aus liegt ein Graben. Das Grün wird von zwei Bunkern geschützt.',
    refImage:
        'https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn7_27d9cd6e84-157x300.gif',
    scorecard: HoleScorecard(
      par: 4,
      hcp: SideValues(front: 1, back: 2),
      herren: SideValues(front: 403, back: 391),
      damen: SideValues(front: 355, back: 344),
    ),
  ),
  Hole(
    n: 8,
    title: "Hier geht's bergauf",
    text:
        "Ganze 183 Meter den Berg hinauf muss der Ball auf Bahn 8 geschlagen werden. Der Abschlag sollte hier sehr gerade und lang genug sein. Rechts und links des Grüns sind große Bunker. Das Grün hat eine große Stufe (McKenzie-Grün).",
    refImage:
        'https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn8_34e02e8bf2-158x300.gif',
    scorecard: HoleScorecard(
      par: 3,
      hcp: SideValues(front: 5, back: 6),
      herren: SideValues(front: 183, back: 175),
      damen: SideValues(front: 150, back: 150),
    ),
  ),
  Hole(
    n: 9,
    title: 'Gefährlicher Pot-Bunker',
    text:
        'Die kürzeste und sehr enge Par 4-Bahn auf dem Platz ist die Neunte. Ein mittleres bis langes Eisen sollte zum ersten Schlag genutzt werden. Bis zum Grün reicht ein kurzes Eisen. Der Schlag sollte nach rechts gehalten werden, da auf der linken Seite ein kleiner Pot-Bunker gefährlich werden kann.',
    refImage:
        'https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn9_a948a14a2f-148x300.gif',
    scorecard: HoleScorecard(
      par: 4,
      hcp: SideValues(front: 15, back: 16),
      herren: SideValues(front: 259, back: 227),
      damen: SideValues(front: 247, back: 227),
    ),
  ),
];

/// Liefert das [Hole] für die physische Bahnnummer (1..9) unabhängig davon,
/// ob sie als vordere (n) oder hintere (n+9) Bahn gespielt wird.
Hole holeForPhysicalNumber(int physicalN) => holes[(physicalN - 1) % 9];
