// "Über diese App"-Dialog (Standard-⋮-Menü). Enthält zusätzlich die
// bisherigen "Kontakt"-Inhalte (Entscheidung: Kontakt faltet in Über,
// siehe PFLICHTENHEFT.md / Migrationsplan) – App-Name, © Jahr, Kurztext,
// Vereins-Kontaktdaten, "Schließen"-Button.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../content/course_data.dart';
import '../services/locale_service.dart';

Future<void> showAboutAppDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const _AboutAppDialog(),
  );
}

class _AboutAppDialog extends StatelessWidget {
  const _AboutAppDialog();

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final year = DateTime.now().year;
    final contact = locale.tFormat('contactText', {
      'address': courseInfo.address,
      'phone': courseInfo.phone,
      'email': courseInfo.email,
      'web': courseInfo.web,
    });

    return AlertDialog(
      title: const Text('GC Winterberg Birdie Book'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('© $year Carsten Rösner'),
            const SizedBox(height: 12),
            Text(locale.t('aboutText')),
            const SizedBox(height: 16),
            Text(
              locale.t('contact'),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(contact),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(locale.t('close')),
        ),
      ],
    );
  }
}
