// Verwaltung des Schläger-Sets: Laden/Persistieren sowie der Sammel-
// Bearbeitungsmodus (Bulk-Edit) aus der bisherigen Vanilla-JS-App
// (state.clubsEditMode / state.editBuffer in js/app.js) 1:1 übernommen.
//
// Bewusste bestehende Einschränkung (siehe PFLICHTENHEFT.md): nur
// Sammel-Bearbeitung, kein Dialog pro einzelnem Schläger.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../content/default_clubs.dart';
import '../models/club.dart';

const String _prefsKeyClubs = 'gcwbb_clubs';

class ClubsService extends ChangeNotifier {
  List<Club> _clubs = List.of(defaultClubs);
  bool _loaded = false;

  bool _editMode = false;
  List<Club>? _editBuffer;

  List<Club> get clubs => List.unmodifiable(_clubs);
  bool get isLoaded => _loaded;
  bool get editMode => _editMode;

  /// Arbeitskopie während der Bearbeitung; nur gültig wenn [editMode] true ist.
  List<Club> get editBuffer =>
      _editBuffer == null ? const [] : List.unmodifiable(_editBuffer!);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKeyClubs);
    if (raw != null) {
      try {
        final list = (jsonDecode(raw) as List)
            .map((e) => Club.fromJson(e as Map<String, dynamic>))
            .toList();
        _clubs = list;
      } catch (_) {
        _clubs = List.of(defaultClubs);
      }
    } else {
      _clubs = List.of(defaultClubs);
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKeyClubs,
      jsonEncode(_clubs.map((c) => c.toJson()).toList()),
    );
  }

  /// Startet den Bearbeitungsmodus mit einer tiefen Arbeitskopie der
  /// aktuellen Liste (entspricht `startClubsEdit()` in js/app.js).
  void startEdit() {
    _editMode = true;
    _editBuffer = _clubs.map((c) => c.copyWith()).toList();
    notifyListeners();
  }

  void cancelEdit() {
    _editMode = false;
    _editBuffer = null;
    notifyListeners();
  }

  void updateBufferName(int index, String name) {
    _requireBuffer();
    _editBuffer![index] = _editBuffer![index].copyWith(name: name);
    notifyListeners();
  }

  void updateBufferMin(int index, int? min) {
    _requireBuffer();
    _editBuffer![index] =
        _editBuffer![index].copyWith(min: min, clearMin: min == null);
    notifyListeners();
  }

  void updateBufferMax(int index, int? max) {
    _requireBuffer();
    _editBuffer![index] =
        _editBuffer![index].copyWith(max: max, clearMax: max == null);
    notifyListeners();
  }

  void removeFromBuffer(int index) {
    _requireBuffer();
    _editBuffer!.removeAt(index);
    notifyListeners();
  }

  void addBlankToBuffer() {
    _requireBuffer();
    final id =
        'c${DateTime.now().millisecondsSinceEpoch}${(1000 + (DateTime.now().microsecond % 9000))}';
    _editBuffer!.add(
      Club(id: id, name: '', category: 'Eigener Schläger', min: null, max: null),
    );
    notifyListeners();
  }

  /// Übernimmt den Bearbeitungspuffer, verwirft leere Namenszeilen
  /// (entspricht dem `cleaned`-Filter in js/app.js) und persistiert.
  Future<void> saveEdit() async {
    _requireBuffer();
    _clubs = _editBuffer!.where((c) => c.name.trim().isNotEmpty).toList();
    _editMode = false;
    _editBuffer = null;
    notifyListeners();
    await _persist();
  }

  void _requireBuffer() {
    if (_editBuffer == null) {
      throw StateError('ClubsService.startEdit() muss zuerst aufgerufen werden.');
    }
  }
}
