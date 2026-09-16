// Einzelne Loch-Seite im Pager: Lochnummer, Par/HCP, Skizze,
// Charakteristik-Text, Herren-/Damen-Distanz-Chips. 1:1-Verhalten aus
// buildHolePage() in js/app.js – physische Lochnummer n (1..18), vordere
// Neun = "front"-Seite, hintere Neun (n>9) = "back"-Seite derselben Bahn.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../content/course_data.dart';
import '../services/locale_service.dart';
import '../theme/golf_palette.dart';
import 'hole_sketch.dart';

class HolePage extends StatelessWidget {
  final int n;

  const HolePage({super.key, required this.n});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final holeData = holeForPhysicalNumber(((n - 1) % 9) + 1);
    final side = n > 9 ? 'back' : 'front';
    final sc = holeData.scorecard;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.t('hole'),
                          style: TextStyle(fontSize: 12, color: GolfPalette.inkFaint),
                        ),
                        Text(
                          '$n',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _MetaLine(
                          label: locale.t('par'),
                          value: sc == null ? '–' : '${sc.par}',
                        ),
                        _MetaLine(
                          label: locale.t('hcp'),
                          value: sc == null
                              ? '–'
                              : '${side == 'back' ? sc.hcp.back : sc.hcp.front}',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: HoleSketch(physicalHoleNumber: ((n - 1) % 9) + 1),
                  ),
                ),
                const SizedBox(height: 16),
                Text(holeData.text, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _TeeChip(
                        label: locale.t('herren'),
                        value: sc == null
                            ? '–'
                            : '${side == 'back' ? sc.herren.back : sc.herren.front} m',
                        color: GolfPalette.gold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TeeChip(
                        label: locale.t('damen'),
                        value: sc == null
                            ? '–'
                            : '${side == 'back' ? sc.damen.back : sc.damen.front} m',
                        color: GolfPalette.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  final String label;
  final String value;

  const _MetaLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$label ',
        style: TextStyle(color: GolfPalette.inkSoft, fontSize: 13),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w700, color: GolfPalette.ink),
          ),
        ],
      ),
    );
  }
}

class _TeeChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TeeChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: GolfPalette.inkSoft)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
