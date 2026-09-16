// Standard-Schlägersatz mit Default-Distanzbereichen (Richtwerte hohes
// Handicap ~HCP 30-36, Herren). Quelle: clevergolfer.com "Average Golf Club
// Distances For High, Middle And Low HCP in METERS". Zeichengenau portiert
// aus js/data.js.

import '../models/club.dart';

const List<Club> defaultClubs = [
  Club(id: 'driver', name: 'Driver', category: 'Holz', min: 170, max: 200),
  Club(id: 'wood3', name: '3-Holz', category: 'Holz', min: 155, max: 185),
  Club(id: 'hybrid', name: 'Hybrid', category: 'Hybrid', min: 140, max: 170),
  Club(id: 'iron4', name: 'Eisen 4', category: 'Eisen', min: 125, max: 145),
  Club(id: 'iron5', name: 'Eisen 5', category: 'Eisen', min: 120, max: 140),
  Club(id: 'iron6', name: 'Eisen 6', category: 'Eisen', min: 110, max: 130),
  Club(id: 'iron7', name: 'Eisen 7', category: 'Eisen', min: 100, max: 120),
  Club(id: 'iron8', name: 'Eisen 8', category: 'Eisen', min: 90, max: 110),
  Club(id: 'iron9', name: 'Eisen 9', category: 'Eisen', min: 80, max: 100),
  Club(id: 'pw', name: 'Pitching Wedge', category: 'Wedge', min: 70, max: 90),
  Club(id: 'sw', name: 'Sand Wedge', category: 'Wedge', min: 50, max: 70),
  Club(id: 'putter', name: 'Putter', category: 'Putter', min: null, max: null),
];
