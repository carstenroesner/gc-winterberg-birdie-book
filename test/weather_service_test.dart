// Prüft nur die reine WMO-Code -> Kategorie-Zuordnung (keine echten
// Netzwerkaufrufe, siehe weather_service.dart Dateikopf).

import 'package:flutter_test/flutter_test.dart';

import 'package:gc_winterberg_birdie_book/services/weather_service.dart';

void main() {
  test('ordnet bekannte WMO-Codes der erwarteten Kategorie zu', () {
    expect(weatherCategoryForCode(0), WeatherCategory.clear);
    expect(weatherCategoryForCode(1), WeatherCategory.partlyCloudy);
    expect(weatherCategoryForCode(2), WeatherCategory.partlyCloudy);
    expect(weatherCategoryForCode(3), WeatherCategory.cloudy);
    expect(weatherCategoryForCode(45), WeatherCategory.fog);
    expect(weatherCategoryForCode(48), WeatherCategory.fog);
    expect(weatherCategoryForCode(55), WeatherCategory.drizzle);
    expect(weatherCategoryForCode(63), WeatherCategory.rain);
    expect(weatherCategoryForCode(82), WeatherCategory.rain);
    expect(weatherCategoryForCode(75), WeatherCategory.snow);
    expect(weatherCategoryForCode(95), WeatherCategory.thunderstorm);
    expect(weatherCategoryForCode(99), WeatherCategory.thunderstorm);
  });

  test('fällt bei unbekanntem Code auf "bewölkt" zurück', () {
    expect(weatherCategoryForCode(-1), WeatherCategory.cloudy);
    expect(weatherCategoryForCode(999), WeatherCategory.cloudy);
  });

  test('jede Kategorie hat ein Icon sowie einen i18n- und einen Klartext-Label', () {
    for (final category in WeatherCategory.values) {
      expect(weatherIconFor(category), isNotNull);
      expect(weatherLabelKeyFor(category), isNotEmpty);
      expect(weatherLabelDe(category), isNotEmpty);
    }
  });
}
