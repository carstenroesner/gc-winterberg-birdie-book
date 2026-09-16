// 3-Flaggen-Sprachauswahl (Deutsch/Englisch/Niederländisch). Lebt bewusst
// NUR auf dem Startbildschirm (Entscheidung im Migrationsplan) – im
// bisherigen ⋮-Menü der Vanilla-JS-App war Sprache noch ein Menüpunkt,
// das entfällt mit dem neuen Standard-⋮-Menü.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/locale_service.dart';
import '../theme/golf_palette.dart';

class LangFlagRow extends StatelessWidget {
  const LangFlagRow({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final code in locale.availableLangs)
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: _FlagButton(
              code: code,
              active: locale.lang == code,
              onTap: () => locale.setLang(code),
            ),
          ),
      ],
    );
  }
}

class _FlagButton extends StatelessWidget {
  final String code;
  final bool active;
  final VoidCallback onTap;

  const _FlagButton({required this.code, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final flags = {'de': '🇩🇪', 'en': '🇬🇧', 'nl': '🇳🇱'};
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: active ? GolfPalette.gold : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(flags[code] ?? code, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
