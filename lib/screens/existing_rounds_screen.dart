// "Bestehende Runden": Verlaufsliste gespeicherter Runden zur Auswahl,
// oder ein Empty-State mit Einstieg in eine neue Runde. 1:1-Verhalten aus
// renderRoundsList() in js/app.js.
//
// Seit 17.09.2026 (siehe PFLICHTENHEFT.md, Abschnitt 3.1/5): jede Runde
// lässt sich nach links wischen, um sie zu löschen oder als PDF-Scorecard
// über die System-Weiterleitungsfunktion des Geräts zu versenden
// (WhatsApp/E-Mail/... je nach Betriebssystem bzw. Browser).

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/round.dart';
import '../services/locale_service.dart';
import '../services/rounds_service.dart';
import '../services/scorecard_pdf_service.dart';
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

  Future<void> _shareRound(BuildContext context, LocaleService locale, Round round) async {
    try {
      await ScorecardPdfService.shareRound(round);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(locale.t('shareError'))),
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    LocaleService locale,
    RoundsService rounds,
    Round round,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(locale.t('deleteRoundTitle')),
        content: Text(locale.t('deleteRoundBody')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(locale.t('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(locale.t('delete')),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await rounds.deleteRound(round.id);
    }
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
                final cardRadius = BorderRadius.circular(20);

                return ClipRRect(
                  borderRadius: cardRadius,
                  child: Slidable(
                    key: ValueKey(round.id),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) => _shareRound(context, locale, round),
                          backgroundColor: GolfPalette.green,
                          foregroundColor: GolfPalette.surface,
                          icon: Icons.ios_share,
                          label: locale.t('send'),
                        ),
                        SlidableAction(
                          onPressed: (_) => _confirmDelete(context, locale, rounds, round),
                          backgroundColor: GolfPalette.danger,
                          foregroundColor: GolfPalette.surface,
                          icon: Icons.delete_outline,
                          label: locale.t('delete'),
                        ),
                      ],
                    ),
                    child: Card(
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
                    ),
                  ),
                );
              },
            ),
    );
  }

  static String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}
