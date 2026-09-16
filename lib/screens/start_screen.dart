// Startbildschirm: Logo/Hero, "Neue Runde" / "Bestehende Runden",
// Sprachzeile oben rechts (siehe lang_flag_row.dart – Sprache lebt nur
// hier). 1:1-Verhalten aus dem Vanilla-JS-Startbildschirm.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/locale_service.dart';
import '../services/rounds_service.dart';
import '../theme/golf_palette.dart';
import '../widgets/lang_flag_row.dart';
import 'existing_rounds_screen.dart';
import 'main_pager_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

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

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 12,
              child: const LangFlagRow(),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/logo.png', width: 96, height: 96),
                    const SizedBox(height: 20),
                    Text(
                      'GC Winterberg Birdie Book',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      locale.t('heroSub'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: GolfPalette.inkSoft),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _startNewRound(context),
                        child: Text(locale.t('newRound')),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ExistingRoundsScreen(),
                          ),
                        ),
                        child: Text(locale.t('existingRounds')),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      locale.t('madeWith'),
                      style: TextStyle(fontSize: 12, color: GolfPalette.inkFaint),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
