/* GCWBB – Statische Ausgangsdaten
   Quellen: golfclub-winterberg.de/9-loch-turnierplatz (Charakteristik-Texte, Referenzgrafiken),
   Vor-Ort-Ausschilderung Loch 2 (Foto, Par/HCP/Distanzen), offizielle Vorgabewirksame Tabelle (CR/Slope/Par).
   Alle mit [PLATZHALTER] markierten Werte sind noch nicht real erfasst (siehe Pflichtenheft, Abschnitt 6). */

const COURSE_INFO = {
  clubName: "GC Winterberg",
  address: "In der Büre 20, 59955 Winterberg",
  phone: "02981 1770",
  email: "info@golfclub-winterberg.de",
  web: "golfclub-winterberg.de",
  greenfeeFrom: "30 €",
  tees: {
    herren: { name: "Schanze", color: "gelb", cr: 70.9, slope: 135, par: 70 },
    damen:  { name: "Bob",     color: "rot",  cr: 73.6, slope: 134, par: 70 }
  }
};

/* 9 Bahnen, jeweils mit vorderem (n) und hinterem (n+9) Loch.
   scorecard: null = noch nicht erfasst (Platzhalter), sonst {par, hcp:{front,back}, herren:{front,back}, damen:{front,back}} */
const HOLES = [
  {
    n: 1,
    title: "Abschlag am Clubhaus",
    text: "Ein guter Abschlag zur linken Seite des Fairway ist wichtig, denn auf der rechten könnte der Ball sonst im Teich landen. Der zweite Schlag muss lang genug sein, um Carry aufs Grün zu kommen, sonst wandert der Ball zu lang auf dem sehr abschüssigen Fairway. Am sichersten ist es, den Ball kurz aufkommen zu lassen, dass er zum Grün rollt.",
    refImage: "https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn1_03160c67a6-153x300.gif",
    scorecard: null
  },
  {
    n: 2,
    title: "Ein klassisches Par 5",
    text: "Bis auf das kleinste Grün des Platzes werden drei Schläge benötigt, denn dieses Doppel-Dogleg ist mit zwei Schlägen kaum zu bewältigen. Der Abschlag muss vor dem Wassergraben liegen, der zweite rechts vom Fairway-Bunker. Von dort benötigen Sie einen sehr genauen Pitch, um das Grün zu treffen.",
    refImage: "https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn2_798ba9e2ba-145x300.gif",
    scorecard: { par: 5, hcp: { front: 11, back: 12 }, herren: { front: 450, back: 438 }, damen: { front: 406, back: 395 } }
  },
  {
    n: 3,
    title: "Kurze Distanz",
    text: "Das dritte Loch ist das kürzeste auf dem Platz. Ein mittleres bis kurzes Eisen wird empfohlen für den Schlag bis zum Grün. Genauigkeit ist wichtig, da die Distanz zur Ausgrenze sehr kurz ist.",
    refImage: "https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn3_8d81eb7245-157x300.gif",
    scorecard: null
  },
  {
    n: 4,
    title: "Das Wasser überbrücken",
    text: "Der Abschlag zum vierten Loch sollte sehr nach links angehalten werden, da das Fairway zur rechten Seite hin sehr schräg wird. Ein langer zweiter Schlag ist wichtig, um das Wasser vor dem Grün zu überbrücken.",
    refImage: "https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn4_d8eedc6d3f-147x300.gif",
    scorecard: null
  },
  {
    n: 5,
    title: "Es geht bergauf",
    text: "Am fünften Loch geht es bergauf. Beim Abschlag sollte man sich links halten, da auf der rechten Seite der tiefste Bunker des Platzes liegt.",
    refImage: "https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn5_2ee2031a40-157x300.gif",
    scorecard: null
  },
  {
    n: 6,
    title: "Sechstes und Längstes",
    text: "Die sechste ist die längste Bahn des Golfplatzes Winterberg. Der Abschlag muss vor dem Graben liegen. Hier sind zwei gute, genaue Schläge nötig, um das Grün zu erreichen. Das Grün wird von zwei großen Bunkern verteidigt.",
    refImage: "https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn6_4069a413a5-160x300.gif",
    scorecard: null
  },
  {
    n: 7,
    title: "400 Meter – 4 Schläge",
    text: "Das siebte Loch ist das schwierigste des Platzes. Gut 400 Meter müssen überbrückt werden. Am idealsten geht der erste Schlag schräg in die linke Fairway-Hälfte. Nach etwa 225 Metern vom ersten Abschlag aus liegt ein Graben. Das Grün wird von zwei Bunkern geschützt.",
    refImage: "https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn7_27d9cd6e84-157x300.gif",
    scorecard: null
  },
  {
    n: 8,
    title: "Hier geht's bergauf",
    text: "Ganze 183 Meter den Berg hinauf muss der Ball an Loch 8 geschlagen werden. Der Abschlag sollte hier sehr gerade und lang genug sein. Rechts und links des Grüns sind große Bunker. Das Grün hat eine große Stufe (McKenzie-Grün).",
    refImage: "https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn8_34e02e8bf2-158x300.gif",
    scorecard: null
  },
  {
    n: 9,
    title: "Gefährlicher Pot-Bunker",
    text: "Die kürzeste und sehr enge Par 4-Bahn auf dem Platz ist die Neunte. Ein mittleres bis langes Eisen sollte zum ersten Schlag genutzt werden. Bis zum Grün reicht ein kurzes Eisen. Der Schlag sollte nach rechts gehalten werden, da auf der linken Seite ein kleiner Pot-Bunker gefährlich werden kann.",
    refImage: "https://golfclub-winterberg.de/wp-content/uploads/2017/05/csm_bahn9_a948a14a2f-148x300.gif",
    scorecard: null
  }
];

/* Standard-Schlägersatz mit Default-Distanzbereichen (Richtwerte hohes Handicap ~HCP 30-36, Herren).
   Quelle: clevergolfer.com "Average Golf Club Distances For High, Middle And Low HCP in METERS". */
const DEFAULT_CLUBS = [
  { id: "driver", name: "Driver",         category: "Holz",   min: 170, max: 200 },
  { id: "wood3",  name: "3-Holz",         category: "Holz",   min: 155, max: 185 },
  { id: "hybrid", name: "Hybrid",         category: "Hybrid", min: 140, max: 170 },
  { id: "iron4",  name: "Eisen 4",        category: "Eisen",  min: 125, max: 145 },
  { id: "iron5",  name: "Eisen 5",        category: "Eisen",  min: 120, max: 140 },
  { id: "iron6",  name: "Eisen 6",        category: "Eisen",  min: 110, max: 130 },
  { id: "iron7",  name: "Eisen 7",        category: "Eisen",  min: 100, max: 120 },
  { id: "iron8",  name: "Eisen 8",        category: "Eisen",  min: 90,  max: 110 },
  { id: "iron9",  name: "Eisen 9",        category: "Eisen",  min: 80,  max: 100 },
  { id: "pw",     name: "Pitching Wedge", category: "Wedge",  min: 70,  max: 90 },
  { id: "sw",     name: "Sand Wedge",     category: "Wedge",  min: 50,  max: 70 },
  { id: "putter", name: "Putter",         category: "Putter", min: null, max: null }
];
