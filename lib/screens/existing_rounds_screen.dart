// "Bestehende Runden": Verlaufsliste gespeicherter Runden zur Auswahl,
// oder ein Empty-State mit Einstieg in eine neue Runde. 1:1-Verhalten aus
// renderRoundsList() in js/app.js.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/round.dart';
import '../services/locale_service.dart';
import '../services/rounds_service.dart';
import '../theme/golf_palette.dart';
import 'main_pager_screen.dart';

class ExistingRoundsScreen extends StatelessWidget {
  const ExistingRoundsScreen({super.key});

  Future<void> _selectRound(BuildContext context, Round round) async {
    final rounds = context.read<RoundsService>();
    await rounds.selectRound(round.id);
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MainPagerScreen()),
    );
  }

  Future<void> _startNewRound(BuildContext context) async {
    final rounds = context.read<RoundsService>();
    await rounds.createNewRound();
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MainPagerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final rounds = context.watch<RoundsService>();

    return Scaffold(
      appBar: AppBar(title: Text(locale.t('roundsTitle'))),
      body: rounds.rounds.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      locale.t('roundsEmpty'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: GolfPalette.inkSoft),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => _startNewRound(context),
                      child: Text(locale.t('startNewInstead')),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: rounds.rounds.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final round = rounds.rounds[index];
                final scored = round.scores.length;
                final hc = round.holeCount;
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.event_note_outlined, color: GolfPalette.green),
                    title: Text(_fmtDate(round.date)),
                    subtitle: Text(
                      '$scored / $hc ${locale.t('score')} · '
                      '${hc == 9 ? locale.t('nineHoleRound') : locale.t('eighteenHoleRound')}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _selectRound(context, round),
                  ),
                );
              },
            ),
    );
  }

  static String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}
