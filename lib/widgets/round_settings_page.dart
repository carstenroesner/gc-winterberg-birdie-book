// Seite "Rundeneinstellungen" (immer Pager-Seite 0). Einzige aktuell
// vorhandene Einstellung: 9-Loch/18-Loch-Umschalter (siehe
// PFLICHTENHEFT.md §3.1a) – 1:1-Verhalten aus buildSettingsPage() in
// js/app.js.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/locale_service.dart';
import '../services/rounds_service.dart';
import '../theme/golf_palette.dart';

class RoundSettingsPage extends StatelessWidget {
  /// Wird aufgerufen, nachdem die Rundenlänge geändert wurde, damit der
  /// Pager (wie in js/app.js `renderPager()`) auf Seite 0 zurückspringen
  /// kann, falls sich die Seitenanzahl ändert.
  final VoidCallback? onHoleCountChanged;

  const RoundSettingsPage({super.key, this.onHoleCountChanged});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final rounds = context.watch<RoundsService>();
    final hc = rounds.currentHoleCount;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GCWBB',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: GolfPalette.goldDeep,
              ),
            ),
            const SizedBox(height: 6),
            Text(locale.t('settingsTitle'), style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              locale.t('settingsSub'),
              style: TextStyle(color: GolfPalette.inkSoft),
            ),
            const SizedBox(height: 24),
            Text(
              locale.t('roundType'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: [
                ButtonSegment(value: 9, label: Text(locale.t('nineHoleRound'))),
                ButtonSegment(value: 18, label: Text(locale.t('eighteenHoleRound'))),
              ],
              selected: {hc},
              onSelectionChanged: (selection) async {
                final newHc = selection.first;
                if (newHc == hc) return;
                await rounds.setCurrentHoleCount(newHc);
                onHoleCountChanged?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
