// Verwaltung der gespeicherten Runden: Liste laden/persistieren, aktuelle
// Runde wählen/anlegen, Rundenlänge (9/18 Loch) und Scores setzen.
// Zeichengenau an das Verhalten von js/app.js angelehnt (getRounds/
// saveRounds/createNewRound/updateCurrentRound), inkl. Score-Schlüssel-
// Format `"front-<n>"`/`"back-<n>"` (siehe Round.scoreKey).
//
// Default-Rundenlänge ist seit 18.09.2026 9 Bahnen (Nutzerwunsch, siehe
// PFLICHTENHEFT.md Abschnitt 8/18; vorher 18). Ebenfalls seit 18.09.2026:
// `createNewRound()` stößt einen automatischen, nicht blockierenden
// Wetterabruf für die neue Runde an (siehe WeatherService).

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/round.dart';
import 'weather_service.dart';

const String _prefsKeyRounds = 'gcwbb_rounds';
const String _prefsKeyCurrent = 'gcwbb_current_round';

class RoundsService extends ChangeNotifier {
  List<Round> _rounds = [];
  String? _currentRoundId;
  bool _loaded = false;

  /// Monotoner Zähler als Kollisionsschutz für [createNewRound]: reines
  /// `DateTime.now().millisecondsSinceEpoch` kann bei zwei Aufrufen
  /// innerhalb derselben Millisekunde (z. B. in Tests ohne Verzögerung
  /// zwischen den Aufrufen) identische IDs erzeugen.
  int _idCounter = 0;

  List<Round> get rounds => List.unmodifiable(_rounds);
  bool get isLoaded => _loaded;
  String? get currentRoundId => _currentRoundId;

  Round? get currentRound {
    final id = _currentRoundId;
    if (id == null) return null;
    for (final r in _rounds) {
      if (r.id == id) return r;
    }
    return null;
  }

  /// Rundenlänge der aktuellen Runde, Default 9 (entspricht `holeCountFor`).
  int get currentHoleCount => currentRound?.holeCount ?? 9;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKeyRounds);
    if (raw != null) {
      try {
        _rounds = (jsonDecode(raw) as List)
            .map((e) => Round.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        _rounds = [];
      }
    }
    _currentRoundId = prefs.getString(_prefsKeyCurrent);
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persistRounds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKeyRounds,
      jsonEncode(_rounds.map((r) => r.toJson()).toList()),
    );
  }

  Future<void> _persistCurrent() async {
    final prefs = await SharedPreferences.getInstance();
    final id = _currentRoundId;
    if (id == null) {
      await prefs.remove(_prefsKeyCurrent);
    } else {
      await prefs.setString(_prefsKeyCurrent, id);
    }
  }

  /// Legt eine neue Runde an (Default 9-Loch, heutiges Datum) und macht sie
  /// zur aktuellen Runde. Entspricht `createNewRound()` in js/app.js. Stößt
  /// zusätzlich einen nicht blockierenden Wetterabruf an (siehe
  /// [_fetchWeatherFor]) – die Rückgabe der Methode wartet darauf nicht.
  Future<Round> createNewRound() async {
    final id = 'r${DateTime.now().millisecondsSinceEpoch}_${_idCounter++}';
    final round = Round(
      id: id,
      date: DateTime.now(),
      holeCount: 9,
      scores: const {},
    );
    _rounds = [round, ..._rounds];
    _currentRoundId = id;
    notifyListeners();
    await _persistRounds();
    await _persistCurrent();
    unawaited(_fetchWeatherFor(id));
    return round;
  }

  /// Ruft einmalig die aktuellen Wetterbedingungen ab und hinterlegt sie an
  /// der Runde mit [id] (auch falls sie zwischenzeitlich nicht mehr die
  /// aktuelle Runde ist). Schlägt der Abruf fehl oder wurde die Runde
  /// inzwischen gelöscht, passiert einfach nichts – Wetter ist optional.
  Future<void> _fetchWeatherFor(String id) async {
    final weather = await weatherFetcher();
    if (weather == null) return;
    final idx = _rounds.indexWhere((r) => r.id == id);
    if (idx == -1) return;
    final updated = _rounds[idx].copyWithWeather(
      weatherTempC: weather.tempC,
      weatherCode: weather.code,
      weatherWindKph: weather.windKph,
    );
    final next = List<Round>.of(_rounds);
    next[idx] = updated;
    _rounds = next;
    notifyListeners();
    await _persistRounds();
  }

  Future<void> selectRound(String id) async {
    _currentRoundId = id;
    notifyListeners();
    await _persistCurrent();
  }

  /// Löscht eine gespeicherte Runde endgültig (per Swipe-Aktion in
  /// "Bestehende Runden", siehe Abschnitt 3.1 im Pflichtenheft). War es die
  /// aktuell ausgewählte Runde, wird die Auswahl aufgehoben.
  Future<void> deleteRound(String id) async {
    _rounds = _rounds.where((r) => r.id != id).toList();
    if (_currentRoundId == id) {
      _currentRoundId = null;
    }
    notifyListeners();
    await _persistRounds();
    await _persistCurrent();
  }

  Future<void> setCurrentHoleCount(int holeCount) async {
    await _updateCurrentRound((r) => r.copyWith(holeCount: holeCount));
  }

  Future<void> setScore({required bool isBack, required int n, required int? score}) async {
    await _updateCurrentRound((r) {
      final scores = Map<String, int>.from(r.scores);
      final key = Round.scoreKey(isBack: isBack, n: n);
      if (score == null) {
        scores.remove(key);
      } else {
        scores[key] = score;
      }
      return r.copyWith(scores: scores);
    });
  }

  Future<void> _updateCurrentRound(Round Function(Round) mutator) async {
    final id = _currentRoundId;
    if (id == null) return;
    final idx = _rounds.indexWhere((r) => r.id == id);
    if (idx == -1) return;
    final updated = mutator(_rounds[idx]);
    final next = List<Round>.of(_rounds);
    next[idx] = updated;
    _rounds = next;
    notifyListeners();
    await _persistRounds();
  }
}
