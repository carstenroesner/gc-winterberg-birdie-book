// Speichert den einmal eingegebenen Namen des Spielers/der Spielerin
// (Nutzerwunsch, 18.09.2026, siehe PFLICHTENHEFT.md Abschnitt 8/18):
// Eingabefeld auf der Startseite, dauerhaft persistiert, künftig immer
// vorbelegt. Analog zu LocaleService (ChangeNotifier + SharedPreferences).

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _prefsKeyName = 'gcwbb_player_name';

class PlayerService extends ChangeNotifier {
  String _name = '';
  bool _loaded = false;

  String get name => _name;
  bool get isLoaded => _loaded;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString(_prefsKeyName) ?? '';
    _loaded = true;
    notifyListeners();
  }

  /// Speichert den Namen dauerhaft. Wird bei jeder Änderung im Eingabefeld
  /// aufgerufen (siehe start_screen.dart) – bei leerem String wird der
  /// gespeicherte Name wieder entfernt.
  Future<void> setName(String value) async {
    final trimmed = value.trim();
    if (trimmed == _name) return;
    _name = trimmed;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (trimmed.isEmpty) {
      await prefs.remove(_prefsKeyName);
    } else {
      await prefs.setString(_prefsKeyName, trimmed);
    }
  }
}
