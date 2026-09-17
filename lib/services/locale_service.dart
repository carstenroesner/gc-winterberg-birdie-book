// Sprachauswahl (Deutsch/Englisch/Niederländisch) + Übersetzungs-Lookup.
// Zeichengenau portiert aus js/i18n.js der bisherigen Vanilla-JS-App.
// Lochbeschreibungen/-titel bleiben bewusst nur Deutsch (siehe
// lib/content/course_data.dart) – hier geht es nur um die App-Oberfläche.
//
// Ergänzt um Keys für das neue Standard-⋮-Menü (Funktionsumfang,
// Problem melden, Über diese App), die es in der Vanilla-JS-Version noch
// nicht gab.

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _prefsKeyLang = 'gcwbb_lang';

const Map<String, Map<String, String>> _i18n = {
  'de': {
    'flag': '🇩🇪',
    'label': 'Deutsch',
    'newRound': 'Neue Runde',
    'existingRounds': 'Bestehende Runden',
    'heroSub': 'Deine Runde auf dem 9-Loch-Platz',
    'par': 'Par',
    'hcp': 'HCP',
    'herren': 'Herren',
    'damen': 'Damen',
    'navHoles': 'Löcher',
    'navClubs': 'Schläger',
    'navScorecard': 'Scorecard',
    'navMore': 'Sonstiges',
    'madeWith': 'made with ♥ in Winterberg',
    'clubsTitle': 'Schläger',
    'clubsSub': 'Standardsatz',
    'addClub': 'Schläger hinzufügen',
    'distanceRange': 'Distanzbereich',
    'noDistance': 'kein Distanzbereich',
    'scorecardTitle': 'Scorecard',
    'frontNine': 'Vordere Neun',
    'backNine': 'Hintere Neun',
    'hole': 'Loch',
    'score': 'Score',
    'scoreNote':
        'Beispielwerte für Loch 2 auf Basis der Platzausschilderung. Übrige Lochdaten folgen.',
    'moreTitle': 'Sonstiges',
    'about': 'Über',
    'aboutSub': 'GC Winterberg & die App',
    'contact': 'Kontakt',
    'contactSub': 'Anfragen & Feedback',
    'language': 'Sprache',
    'roundsTitle': 'Bestehende Runden',
    'roundsEmpty': 'Noch keine gespeicherten Runden.',
    'startNewInstead': 'Neue Runde starten',
    'save': 'Speichern',
    'cancel': 'Abbrechen',
    'delete': 'Löschen',
    'edit': 'Bearbeiten',
    'clubName': 'Bezeichnung',
    'minDist': 'Min. (m)',
    'maxDist': 'Max. (m)',
    'editClub': 'Schläger bearbeiten',
    'newClub': 'Neuer Schläger',
    'aboutText':
        'GC Winterberg – 9-Loch-Turnierplatz. Der Platz wird mit zwei Abschlagsätzen (Herren „Schanze“, Damen „Bob“) wie ein 18-Loch-Kurs gespielt. Course Rating/Slope: Herren 70,9/135, Damen 73,6/134 (Par 70).',
    'contactText':
        'Adresse: {address}\nTelefon: {phone}\nE-Mail: {email}\nWeb: {web}',
    'settingsTitle': 'Rundeneinstellungen',
    'settingsSub': 'Lege fest, wie deine Runde gespielt wird.',
    'roundType': 'Rundenlänge',
    'nineHoleRound': '9-Loch-Runde',
    'eighteenHoleRound': '18-Loch-Runde',
    'reportIssueBtn': 'Problem oder Anregung melden',
    'reportIssueTitle': 'Problem oder Anregung melden',
    'reportBug': 'Problem',
    'reportIdea': 'Anregung',
    'issueTitleLabel': 'Titel',
    'issueDescLabel': 'Beschreibung',
    'issueOpenBtn': 'Issue öffnen',
    'reportIssueHint':
        'Öffnet ein vorausgefülltes GitHub-Issue in deinem Browser – die Übermittlung erfolgt dort mit deinem eigenen GitHub-Konto.',
    'menuFeatureOverview': 'Funktionsumfang',
    'menuClubs': 'Schläger',
    'menuReportIssue': 'Problem melden',
    'menuAbout': 'Über diese App',
    'featureOverviewTitle': 'Funktionsumfang',
    'knownLimitations': 'Bekannte Einschränkungen',
    'close': 'Schließen',
    'send': 'Versenden',
    'deleteRoundTitle': 'Runde löschen?',
    'deleteRoundBody':
        'Diese Runde wird endgültig gelöscht. Das kann nicht rückgängig gemacht werden.',
    'shareError': 'Die Runde konnte nicht zum Versenden vorbereitet werden.',
  },
  'en': {
    'flag': '🇬🇧',
    'label': 'English',
    'newRound': 'New Round',
    'existingRounds': 'Existing Rounds',
    'heroSub': 'Your round on the 9-hole course',
    'par': 'Par',
    'hcp': 'HCP',
    'herren': 'Men',
    'damen': 'Women',
    'navHoles': 'Holes',
    'navClubs': 'Clubs',
    'navScorecard': 'Scorecard',
    'navMore': 'More',
    'madeWith': 'made with ♥ in Winterberg',
    'clubsTitle': 'Clubs',
    'clubsSub': 'Standard set',
    'addClub': 'Add club',
    'distanceRange': 'Distance range',
    'noDistance': 'no distance range',
    'scorecardTitle': 'Scorecard',
    'frontNine': 'Front Nine',
    'backNine': 'Back Nine',
    'hole': 'Hole',
    'score': 'Score',
    'scoreNote':
        'Sample values for hole 2 from the on-course signage. Remaining hole data to follow.',
    'moreTitle': 'More',
    'about': 'About',
    'aboutSub': 'GC Winterberg & the app',
    'contact': 'Contact',
    'contactSub': 'Enquiries & feedback',
    'language': 'Language',
    'roundsTitle': 'Existing Rounds',
    'roundsEmpty': 'No saved rounds yet.',
    'startNewInstead': 'Start a new round',
    'save': 'Save',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'edit': 'Edit',
    'clubName': 'Name',
    'minDist': 'Min. (m)',
    'maxDist': 'Max. (m)',
    'editClub': 'Edit club',
    'newClub': 'New club',
    'aboutText':
        'GC Winterberg – 9-hole tournament course. The course is played like an 18-hole course using two tee sets (men "Schanze", women "Bob"). Course rating/slope: men 70.9/135, women 73.6/134 (par 70).',
    'contactText': 'Address: {address}\nPhone: {phone}\nEmail: {email}\nWeb: {web}',
    'settingsTitle': 'Round settings',
    'settingsSub': 'Choose how your round is played.',
    'roundType': 'Round length',
    'nineHoleRound': '9-hole round',
    'eighteenHoleRound': '18-hole round',
    'reportIssueBtn': 'Report a problem or idea',
    'reportIssueTitle': 'Report a problem or idea',
    'reportBug': 'Problem',
    'reportIdea': 'Idea',
    'issueTitleLabel': 'Title',
    'issueDescLabel': 'Description',
    'issueOpenBtn': 'Open issue',
    'reportIssueHint':
        'Opens a pre-filled GitHub issue in your browser – it is submitted there with your own GitHub account.',
    'menuFeatureOverview': 'Feature overview',
    'menuClubs': 'Clubs',
    'menuReportIssue': 'Report a problem',
    'menuAbout': 'About this app',
    'featureOverviewTitle': 'Feature overview',
    'knownLimitations': 'Known limitations',
    'close': 'Close',
    'send': 'Send',
    'deleteRoundTitle': 'Delete round?',
    'deleteRoundBody': 'This round will be permanently deleted. This cannot be undone.',
    'shareError': 'The round could not be prepared for sending.',
  },
  'nl': {
    'flag': '🇳🇱',
    'label': 'Nederlands',
    'newRound': 'Nieuwe ronde',
    'existingRounds': 'Bestaande rondes',
    'heroSub': 'Jouw ronde op de 9-holes baan',
    'par': 'Par',
    'hcp': 'HCP',
    'herren': 'Heren',
    'damen': 'Dames',
    'navHoles': 'Holes',
    'navClubs': 'Clubs',
    'navScorecard': 'Scorekaart',
    'navMore': 'Meer',
    'madeWith': 'made with ♥ in Winterberg',
    'clubsTitle': 'Clubs',
    'clubsSub': 'Standaardset',
    'addClub': 'Club toevoegen',
    'distanceRange': 'Afstandsbereik',
    'noDistance': 'geen afstandsbereik',
    'scorecardTitle': 'Scorekaart',
    'frontNine': 'Eerste negen',
    'backNine': 'Tweede negen',
    'hole': 'Hole',
    'score': 'Score',
    'scoreNote':
        'Voorbeeldwaarden voor hole 2 op basis van de bebording op de baan. Overige holegegevens volgen.',
    'moreTitle': 'Meer',
    'about': 'Over ons',
    'aboutSub': 'GC Winterberg & de app',
    'contact': 'Contact',
    'contactSub': 'Vragen & feedback',
    'language': 'Taal',
    'roundsTitle': 'Bestaande rondes',
    'roundsEmpty': 'Nog geen opgeslagen rondes.',
    'startNewInstead': 'Nieuwe ronde starten',
    'save': 'Opslaan',
    'cancel': 'Annuleren',
    'delete': 'Verwijderen',
    'edit': 'Bewerken',
    'clubName': 'Naam',
    'minDist': 'Min. (m)',
    'maxDist': 'Max. (m)',
    'editClub': 'Club bewerken',
    'newClub': 'Nieuwe club',
    'aboutText':
        'GC Winterberg – 9-holes toernooibaan. De baan wordt met twee afslagsets (heren "Schanze", dames "Bob") als een 18-holes baan gespeeld. Course rating/slope: heren 70,9/135, dames 73,6/134 (par 70).',
    'contactText': 'Adres: {address}\nTelefoon: {phone}\nE-mail: {email}\nWeb: {web}',
    'settingsTitle': 'Rondeinstellingen',
    'settingsSub': 'Bepaal hoe je ronde wordt gespeeld.',
    'roundType': 'Rondelengte',
    'nineHoleRound': '9-holes ronde',
    'eighteenHoleRound': '18-holes ronde',
    'reportIssueBtn': 'Probleem of idee melden',
    'reportIssueTitle': 'Probleem of idee melden',
    'reportBug': 'Probleem',
    'reportIdea': 'Idee',
    'issueTitleLabel': 'Titel',
    'issueDescLabel': 'Beschrijving',
    'issueOpenBtn': 'Issue openen',
    'reportIssueHint':
        'Opent een vooringevuld GitHub-issue in je browser – het wordt daar verzonden met je eigen GitHub-account.',
    'menuFeatureOverview': 'Functieoverzicht',
    'menuClubs': 'Clubs',
    'menuReportIssue': 'Probleem melden',
    'menuAbout': 'Over deze app',
    'featureOverviewTitle': 'Functieoverzicht',
    'knownLimitations': 'Bekende beperkingen',
    'close': 'Sluiten',
    'send': 'Versturen',
    'deleteRoundTitle': 'Ronde verwijderen?',
    'deleteRoundBody':
        'Deze ronde wordt definitief verwijderd. Dit kan niet ongedaan worden gemaakt.',
    'shareError': 'De ronde kon niet worden voorbereid om te versturen.',
  },
};

/// Verwaltet die gewählte App-Sprache und stellt die Übersetzungsfunktion
/// [t] bereit. Fallback-Kette: gewählte Sprache -> Deutsch -> der Key selbst
/// (identisch zur bisherigen `t()`-Logik in js/i18n.js).
class LocaleService extends ChangeNotifier {
  String _lang = 'de';
  bool _loaded = false;

  String get lang => _lang;
  bool get isLoaded => _loaded;

  List<String> get availableLangs => _i18n.keys.toList(growable: false);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _lang = prefs.getString(_prefsKeyLang) ?? 'de';
    if (!_i18n.containsKey(_lang)) _lang = 'de';
    _loaded = true;
    notifyListeners();
  }

  Future<void> setLang(String code) async {
    if (!_i18n.containsKey(code) || code == _lang) return;
    _lang = code;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKeyLang, code);
  }

  String t(String key) {
    final dict = _i18n[_lang] ?? _i18n['de']!;
    return dict[key] ?? _i18n['de']![key] ?? key;
  }

  /// Ersetzt `{platzhalter}`-Muster wie in `contactText`, z. B.
  /// `tFormat('contactText', {'address': '...', 'phone': '...'})`.
  String tFormat(String key, Map<String, String> values) {
    var result = t(key);
    values.forEach((k, v) {
      result = result.replaceAll('{$k}', v);
    });
    return result;
  }
}
