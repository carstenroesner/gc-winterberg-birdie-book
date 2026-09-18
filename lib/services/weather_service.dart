// Automatischer Wetterabruf für neu angelegte Runden (Nutzerwunsch,
// 18.09.2026, siehe PFLICHTENHEFT.md Abschnitt 8/18): Statt den
// Gerätestandort abzufragen (Berechtigungsdialog, ggf. abweichend vom
// tatsächlichen Spielort), werden feste Koordinaten des GC Winterberg
// verwendet – die Wetterbedingungen sollen den Platz beschreiben, nicht
// das exakte GPS-Signal des Telefons. Quelle Open-Meteo (kostenlos, kein
// API-Key nötig, CORS-fähig für Web-Apps): https://open-meteo.com.
//
// [weatherFetcher] ist austauschbar (Top-Level-Funktionsvariable), damit
// `flutter test` keine echten Netzwerkaufrufe auslöst – siehe
// test/rounds_service_test.dart u.a. (`weatherFetcher = () async => null;`
// in setUp()). In Produktion zeigt sie auf [WeatherService.fetchCurrent].

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Feste Koordinaten Winterberg (NRW) – Stadtzentrum, ausreichend genau für
/// eine Wettervorhersage (Rasterauflösung der Wettermodelle liegt ohnehin
/// im Kilometerbereich).
const double _courseLat = 51.1925;
const double _courseLon = 8.5347;

class WeatherReading {
  final double tempC;
  final int code;
  final double windKph;

  const WeatherReading({required this.tempC, required this.code, required this.windKph});
}

class WeatherService {
  WeatherService._();

  /// Ruft die aktuellen Wetterbedingungen für den Platz ab. Liefert `null`
  /// bei jedem Fehler (offline, Timeout, unerwartete Antwort) – Wetter ist
  /// ein "nice to have", eine neue Runde darf dadurch nie blockiert werden.
  static Future<WeatherReading?> fetchCurrent() async {
    try {
      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$_courseLat&longitude=$_courseLon'
        '&current=temperature_2m,weather_code,wind_speed_10m'
        '&timezone=Europe%2FBerlin',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final current = json['current'] as Map<String, dynamic>?;
      if (current == null) return null;
      final temp = (current['temperature_2m'] as num?)?.toDouble();
      final code = (current['weather_code'] as num?)?.toInt();
      final wind = (current['wind_speed_10m'] as num?)?.toDouble();
      if (temp == null || code == null || wind == null) return null;
      return WeatherReading(tempC: temp, code: code, windKph: wind);
    } catch (_) {
      return null;
    }
  }
}

/// Austauschbarer Hook für Tests (siehe Dateikopf). Produktion: echter
/// Netzwerkabruf.
Future<WeatherReading?> Function() weatherFetcher = WeatherService.fetchCurrent;

/// Grobe Wetterkategorien für Icon/Label-Zuordnung, gemappt aus dem
/// WMO-Wettercode, den Open-Meteo liefert (https://open-meteo.com/en/docs,
/// Abschnitt "WMO Weather interpretation codes").
enum WeatherCategory { clear, partlyCloudy, cloudy, fog, drizzle, rain, snow, thunderstorm }

WeatherCategory weatherCategoryForCode(int code) {
  if (code == 0) return WeatherCategory.clear;
  if (code == 1 || code == 2) return WeatherCategory.partlyCloudy;
  if (code == 3) return WeatherCategory.cloudy;
  if (code == 45 || code == 48) return WeatherCategory.fog;
  if (const [51, 53, 55, 56, 57].contains(code)) return WeatherCategory.drizzle;
  if (const [61, 63, 65, 66, 67, 80, 81, 82].contains(code)) return WeatherCategory.rain;
  if (const [71, 73, 75, 77, 85, 86].contains(code)) return WeatherCategory.snow;
  if (const [95, 96, 99].contains(code)) return WeatherCategory.thunderstorm;
  return WeatherCategory.cloudy;
}

IconData weatherIconFor(WeatherCategory category) {
  switch (category) {
    case WeatherCategory.clear:
      return Icons.wb_sunny_outlined;
    case WeatherCategory.partlyCloudy:
      return Icons.wb_cloudy_outlined;
    case WeatherCategory.cloudy:
      return Icons.cloud_outlined;
    case WeatherCategory.fog:
      return Icons.blur_on;
    case WeatherCategory.drizzle:
      return Icons.grain;
    case WeatherCategory.rain:
      return Icons.water_drop_outlined;
    case WeatherCategory.snow:
      return Icons.ac_unit_outlined;
    case WeatherCategory.thunderstorm:
      return Icons.thunderstorm_outlined;
  }
}

/// i18n-Key (siehe locale_service.dart) für das Label der Kategorie.
String weatherLabelKeyFor(WeatherCategory category) {
  switch (category) {
    case WeatherCategory.clear:
      return 'weatherClear';
    case WeatherCategory.partlyCloudy:
      return 'weatherPartlyCloudy';
    case WeatherCategory.cloudy:
      return 'weatherCloudy';
    case WeatherCategory.fog:
      return 'weatherFog';
    case WeatherCategory.drizzle:
      return 'weatherDrizzle';
    case WeatherCategory.rain:
      return 'weatherRain';
    case WeatherCategory.snow:
      return 'weatherSnow';
    case WeatherCategory.thunderstorm:
      return 'weatherThunderstorm';
  }
}

/// Deutsches Klartext-Label für den PDF-Export (scorecard_pdf_service.dart),
/// der bewusst nicht lokalisiert ist (siehe dortiger Dateikopf).
String weatherLabelDe(WeatherCategory category) {
  switch (category) {
    case WeatherCategory.clear:
      return 'Sonnig';
    case WeatherCategory.partlyCloudy:
      return 'Leicht bewölkt';
    case WeatherCategory.cloudy:
      return 'Bewölkt';
    case WeatherCategory.fog:
      return 'Neblig';
    case WeatherCategory.drizzle:
      return 'Nieselregen';
    case WeatherCategory.rain:
      return 'Regen';
    case WeatherCategory.snow:
      return 'Schnee';
    case WeatherCategory.thunderstorm:
      return 'Gewitter';
  }
}
