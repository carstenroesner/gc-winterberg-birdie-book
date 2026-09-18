// GCWBB – Statische Ausgangsdaten
// Quellen: golfclub-winterberg.de/9-loch-turnierplatz (Charakteristik-Texte,
// Referenzgrafiken), Vor-Ort-Ausschilderung aller 9 Bahnen (Fotos der
// Bahntafeln, vom Nutzer am 17.09.2026 hochgeladen; Par/HCP/Distanzen für
// alle 9 Bahnen vollständig erfasst), offizielle Vorgabewirksame Tabelle
// (CR/Slope/Par).
// Zeichengenau portiert aus js/data.js der bisherigen Vanilla-JS-App.
//
// title/text seit 18.09.2026 dreisprachig (de/en/nl, siehe Hole.titleFor/
// textFor) – Deutsch ist die Quelle (golfclub-winterberg.de), EN/NL sind
// sinngemäße Übersetzungen (siehe PFLICHTENHEFT.md Abschnitt 18).

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
    title: {
      'de': 'Abschlag am Clubhaus',
      'en': 'Tee-off by the Clubhouse',
      'nl': 'Afslag bij het clubhuis',
    },
    text: {
      'de':
          'Ein guter Abschlag zur linken Seite des Fairway ist wichtig, denn auf der rechten könnte der Ball sonst im Teich landen. Der zweite Schlag muss lang genug sein, um Carry aufs Grün zu kommen, sonst wandert der Ball zu lang auf dem sehr abschüssigen Fairway. Am sichersten ist es, den Ball kurz aufkommen zu lassen, dass er zum Grün rollt.',
      'en':
          'A good tee shot to the left side of the fairway is important, as the right side could see your ball end up in the pond. The second shot needs enough carry to reach the green, or the ball will run too far on the steeply sloping fairway. The safest play is to land the ball short and let it roll onto the green.',
      'nl':
          'Een goede afslag naar de linkerkant van de fairway is belangrijk, want aan de rechterkant kan de bal in de vijver belanden. De tweede slag moet ver genoeg dragen om het green te bereiken, anders rolt de bal te ver door op de sterk hellende fairway. Het veiligst is om de bal kort te laten landen, zodat hij naar het green rolt.',
    },
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
    title: {
      'de': 'Ein klassisches Par 5',
      'en': 'A Classic Par 5',
      'nl': 'Een klassieke par 5',
    },
    text: {
      'de':
          'Bis auf das kleinste Grün des Platzes werden drei Schläge benötigt, denn dieses Doppel-Dogleg ist mit zwei Schlägen kaum zu bewältigen. Der Abschlag muss vor dem Wassergraben liegen, der zweite rechts vom Fairway-Bunker. Von dort benötigen Sie einen sehr genauen Pitch, um das Grün zu treffen.',
      'en':
          'Reaching the smallest green on the course takes three shots, as this double dogleg is barely playable in two. The tee shot must stay short of the water ditch, and the second shot right of the fairway bunker. From there you\'ll need a very precise pitch to find the green.',
      'nl':
          'Om het kleinste green van de baan te bereiken zijn drie slagen nodig, want deze dubbele dogleg is met twee slagen nauwelijks te overbruggen. De afslag moet vóór de watergreppel blijven liggen, de tweede slag rechts van de fairwaybunker. Vandaar is een zeer nauwkeurige pitch nodig om het green te raken.',
    },
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
    title: {
      'de': 'Kurze Distanz',
      'en': 'Short Distance',
      'nl': 'Korte afstand',
    },
    text: {
      'de':
          'Die dritte Bahn ist die kürzeste auf dem Platz. Ein mittleres bis kurzes Eisen wird empfohlen für den Schlag bis zum Grün. Genauigkeit ist wichtig, da die Distanz zur Ausgrenze sehr kurz ist.',
      'en':
          'The third hole is the shortest on the course. A mid to short iron is recommended for the approach to the green. Accuracy is important, as the distance to the out-of-bounds line is very short.',
      'nl':
          'De derde hole is de kortste van de baan. Een midden- tot korte ijzer wordt aanbevolen voor de slag naar het green. Precisie is belangrijk, want de afstand tot de out-of-bounds is erg kort.',
    },
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
    title: {
      'de': 'Das Wasser überbrücken',
      'en': 'Crossing the Water',
      'nl': 'Het water overbruggen',
    },
    text: {
      'de':
          'Der Abschlag zur vierten Bahn sollte sehr nach links angehalten werden, da das Fairway zur rechten Seite hin sehr schräg wird. Ein langer zweiter Schlag ist wichtig, um das Wasser vor dem Grün zu überbrücken.',
      'en':
          'The tee shot on the fourth hole should be aimed well to the left, as the fairway slopes away sharply on the right. A long second shot is important to carry the water in front of the green.',
      'nl':
          'De afslag op de vierde hole moet ver naar links gericht worden, want de fairway loopt aan de rechterkant sterk af. Een lange tweede slag is belangrijk om het water voor het green te overbruggen.',
    },
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
    title: {
      'de': 'Es geht bergauf',
      'en': 'Heading Uphill',
      'nl': 'Het gaat omhoog',
    },
    text: {
      'de':
          'An der fünften Bahn geht es bergauf. Beim Abschlag sollte man sich links halten, da auf der rechten Seite der tiefste Bunker des Platzes liegt.',
      'en':
          'The fifth hole plays uphill. Favour the left side off the tee, as the deepest bunker on the course lies on the right.',
      'nl':
          'De vijfde hole speelt bergop. Houd bij de afslag links aan, want aan de rechterkant ligt de diepste bunker van de baan.',
    },
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
    title: {
      'de': 'Sechstes und Längstes',
      'en': 'Sixth and Longest',
      'nl': 'Zesde en langste',
    },
    text: {
      'de':
          'Die sechste ist die längste Bahn des Golfplatzes Winterberg. Der Abschlag muss vor dem Graben liegen. Hier sind zwei gute, genaue Schläge nötig, um das Grün zu erreichen. Das Grün wird von zwei großen Bunkern verteidigt.',
      'en':
          'The sixth is the longest hole at Golfclub Winterberg. The tee shot must stay short of the ditch. Two good, accurate shots are needed here to reach the green, which is defended by two large bunkers.',
      'nl':
          'De zesde is de langste hole van Golfclub Winterberg. De afslag moet vóór de greppel blijven liggen. Hier zijn twee goede, nauwkeurige slagen nodig om het green te bereiken, dat wordt verdedigd door twee grote bunkers.',
    },
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
    title: {
      'de': '400 Meter – 4 Schläge',
      'en': '400 Metres – 4 Shots',
      'nl': '400 meter – 4 slagen',
    },
    text: {
      'de':
          'Die siebte Bahn ist die schwierigste des Platzes. Gut 400 Meter müssen überbrückt werden. Am idealsten geht der erste Schlag schräg in die linke Fairway-Hälfte. Nach etwa 225 Metern vom ersten Abschlag aus liegt ein Graben. Das Grün wird von zwei Bunkern geschützt.',
      'en':
          'The seventh hole is the toughest on the course. A good 400 metres need to be covered. Ideally the first shot is played on an angle into the left half of the fairway. A ditch lies around 225 metres from the tee. The green is guarded by two bunkers.',
      'nl':
          'De zevende hole is de moeilijkste van de baan. Er moet ruim 400 meter overbrugd worden. Idealiter wordt de eerste slag schuin naar de linkerhelft van de fairway gespeeld. Op ongeveer 225 meter vanaf de afslag ligt een greppel. Het green wordt beschermd door twee bunkers.',
    },
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
    title: {
      'de': "Hier geht's bergauf",
      'en': 'Uphill All the Way',
      'nl': 'Hier gaat het omhoog',
    },
    text: {
      'de':
          "Ganze 183 Meter den Berg hinauf muss der Ball auf Bahn 8 geschlagen werden. Der Abschlag sollte hier sehr gerade und lang genug sein. Rechts und links des Grüns sind große Bunker. Das Grün hat eine große Stufe (McKenzie-Grün).",
      'en':
          'On the eighth hole the ball has to travel a full 183 metres up the hill. The tee shot needs to be very straight and long enough here. There are large bunkers to the left and right of the green, which has a pronounced tier (a McKenzie green).',
      'nl':
          'Op hole 8 moet de bal maar liefst 183 meter de berg op geslagen worden. De afslag moet hier erg recht en ver genoeg zijn. Links en rechts van het green liggen grote bunkers. Het green heeft een uitgesproken niveauverschil (een McKenzie-green).',
    },
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
    title: {
      'de': 'Gefährlicher Pot-Bunker',
      'en': 'Dangerous Pot Bunker',
      'nl': 'Gevaarlijke potbunker',
    },
    text: {
      'de':
          'Die kürzeste und sehr enge Par 4-Bahn auf dem Platz ist die Neunte. Ein mittleres bis langes Eisen sollte zum ersten Schlag genutzt werden. Bis zum Grün reicht ein kurzes Eisen. Der Schlag sollte nach rechts gehalten werden, da auf der linken Seite ein kleiner Pot-Bunker gefährlich werden kann.',
      'en':
          'The ninth is the shortest and narrowest par-4 hole on the course. A mid to long iron should be used for the first shot, and a short iron is enough to reach the green. Favour the right side, as a small pot bunker on the left can prove dangerous.',
      'nl':
          'De negende is de kortste en zeer smalle par-4 hole van de baan. Voor de eerste slag is een midden- tot lange ijzer aan te raden, tot het green is een korte ijzer voldoende. Houd rechts aan, want een kleine potbunker aan de linkerkant kan gevaarlijk zijn.',
    },
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
