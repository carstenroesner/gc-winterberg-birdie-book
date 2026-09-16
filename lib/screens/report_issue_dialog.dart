// "Problem melden"-Dialog (Standard-⋮-Menü). Öffnet eine vorausgefüllte
// GitHub-"New Issue"-URL im Browser – bewusst OHNE Zugriffstoken in der
// App (die Übermittlung erfolgt mit dem eigenen GitHub-Konto der meldenden
// Person). 1:1-Verhalten aus der bisherigen Vanilla-JS-Implementierung
// (js/app.js, Abschnitt "Problem/Anregung melden") und exakt nach dem
// Muster von spraytattoo_katalog/lib/screens/report_issue_dialog.dart.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/locale_service.dart';

const String _githubOwner = 'carstenroesner';
const String _githubRepo = 'gc-winterberg-birdie-book';

enum _ReportKind { bug, idea }

Future<void> showReportIssueDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const _ReportIssueDialog(),
  );
}

/// Baut die GitHub-"New Issue"-URL. Öffentlich für Tests (prüft Owner/Repo/
/// Labels und dass niemals ein Token im String steht).
Uri buildIssueUri({required String title, required String body, required bool isIdea}) {
  return Uri.https('github.com', '/$_githubOwner/$_githubRepo/issues/new', {
    'title': title,
    'body': body,
    'labels': isIdea ? 'enhancement' : 'bug',
  });
}

class _ReportIssueDialog extends StatefulWidget {
  const _ReportIssueDialog();

  @override
  State<_ReportIssueDialog> createState() => _ReportIssueDialogState();
}

class _ReportIssueDialogState extends State<_ReportIssueDialog> {
  _ReportKind _kind = _ReportKind.bug;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();

    return AlertDialog(
      title: Text(locale.t('reportIssueTitle')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<_ReportKind>(
              segments: [
                ButtonSegment(value: _ReportKind.bug, label: Text(locale.t('reportBug'))),
                ButtonSegment(value: _ReportKind.idea, label: Text(locale.t('reportIdea'))),
              ],
              selected: {_kind},
              onSelectionChanged: (s) => setState(() => _kind = s.first),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: locale.t('issueTitleLabel')),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: locale.t('issueDescLabel')),
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            Text(
              locale.t('reportIssueHint'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(locale.t('cancel')),
        ),
        FilledButton(
          onPressed: () async {
            final title = _titleController.text.trim();
            if (title.isEmpty) return;
            final uri = buildIssueUri(
              title: title,
              body: _descController.text.trim(),
              isIdea: _kind == _ReportKind.idea,
            );
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(locale.t('issueOpenBtn')),
        ),
      ],
    );
  }
}
