// Prüft buildIssueUri(): korrekter Owner/Repo, korrekte Labels je Typ, und
// vor allem: NIEMALS ein Zugriffstoken im erzeugten String (Standard
// Abschnitt 3/4 – bewusst kein Token im Client, Übermittlung erfolgt mit
// dem eigenen GitHub-Konto der meldenden Person).

import 'package:flutter_test/flutter_test.dart';

import 'package:gc_winterberg_birdie_book/screens/report_issue_dialog.dart';

void main() {
  test('baut eine korrekte GitHub-New-Issue-URL für ein "Problem"', () {
    final uri = buildIssueUri(title: 'App stürzt ab', body: 'Details...', isIdea: false);

    expect(uri.scheme, 'https');
    expect(uri.host, 'github.com');
    expect(uri.path, '/carstenroesner/gc-winterberg-birdie-book/issues/new');
    expect(uri.queryParameters['title'], 'App stürzt ab');
    expect(uri.queryParameters['body'], 'Details...');
    expect(uri.queryParameters['labels'], 'bug');
  });

  test('baut eine korrekte GitHub-New-Issue-URL für eine "Anregung"', () {
    final uri = buildIssueUri(title: 'Idee', body: '...', isIdea: true);
    expect(uri.queryParameters['labels'], 'enhancement');
  });

  test('die URL enthält niemals ein Zugriffstoken', () {
    final uri = buildIssueUri(title: 'x', body: 'y', isIdea: false);
    final full = uri.toString().toLowerCase();
    expect(full, isNot(contains('ghp_')));
    expect(full, isNot(contains('gho_')));
    expect(full, isNot(contains('token')));
    expect(full, isNot(contains('access_token')));
  });
}
