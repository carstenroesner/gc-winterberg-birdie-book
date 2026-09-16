// Ziel des Menüpunkts "Funktionsumfang" (Standard-⋮-Menü). Inhalte kommen
// aus lib/content/feature_overview_content.dart und müssen fachlich
// deckungsgleich mit PFLICHTENHEFT.md bleiben (siehe dortige Doku-Kommentare).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../content/feature_overview_content.dart';
import '../services/locale_service.dart';
import '../theme/golf_palette.dart';

class FeatureOverviewScreen extends StatelessWidget {
  const FeatureOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    return Scaffold(
      appBar: AppBar(title: Text(locale.t('featureOverviewTitle'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(featureOverviewIntro, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          for (final section in featureOverviewSections) ...[
            Text(
              section.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            for (final point in section.points)
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6, right: 8),
                      child: Icon(Icons.circle, size: 5, color: GolfPalette.green2),
                    ),
                    Expanded(child: Text(point)),
                  ],
                ),
              ),
            const SizedBox(height: 16),
          ],
          Text(
            locale.t('knownLimitations'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          for (final limitation in featureOverviewKnownLimitations)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6, right: 8),
                    child: Icon(Icons.circle, size: 5, color: GolfPalette.inkFaint),
                  ),
                  Expanded(child: Text(limitation)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
