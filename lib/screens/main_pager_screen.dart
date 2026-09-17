// Hauptbildschirm: Kopfzeile (Logo/Clubname/Kontextzeile, Neue-Runde-Icon,
// Standard-⋮-Menü) + horizontaler Pager (Rundeneinstellungen -> Löcher ->
// Scorecard) + "Buchregister"-Reiterleisten links/rechts. Fügt die in
// lib/widgets/ gebauten Seiten zusammen (1:1-Verhalten aus renderPager()/
// navigateToPage()/renderHoleColumns() in js/app.js).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/locale_service.dart';
import '../services/rounds_service.dart';
import '../theme/golf_palette.dart';
import '../widgets/book_tab_rail.dart';
import '../widgets/hole_page.dart';
import '../widgets/round_settings_page.dart';
import '../widgets/scorecard_page.dart';
import 'about_dialog.dart';
import 'clubs_screen.dart';
import 'feature_overview_screen.dart';
import 'report_issue_dialog.dart';

class MainPagerScreen extends StatefulWidget {
  const MainPagerScreen({super.key});

  @override
  State<MainPagerScreen> createState() => _MainPagerScreenState();
}

class _MainPagerScreenState extends State<MainPagerScreen> {
  late final PageController _controller;
  int _activePage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _jumpToPage(int index) {
    setState(() => _activePage = index);
    _controller.jumpToPage(index);
  }

  void _onHoleCountChanged() {
    // Entspricht `state.activePage = 0; renderPager();` in js/app.js.
    _jumpToPage(0);
  }

  Future<void> _onNewRound(RoundsService rounds) async {
    await rounds.createNewRound();
    _jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final rounds = context.watch<RoundsService>();
    final hc = rounds.currentHoleCount;
    final lastPage = hc + 1;
    if (_activePage > lastPage) _activePage = lastPage;

    final pages = <Widget>[
      RoundSettingsPage(onHoleCountChanged: _onHoleCountChanged),
      for (var n = 1; n <= hc; n++) HolePage(n: n),
      ScorecardPage(holeCount: hc),
    ];

    final leftItems = <BookTabItem>[
      const BookTabItem.settings(pageIndex: 0),
      for (var n = 1; n <= (hc < 9 ? hc : 9); n++) BookTabItem.hole(pageIndex: n, holeNumber: n),
      if (hc <= 9) BookTabItem.scorecard(pageIndex: lastPage),
    ];
    final rightItems = <BookTabItem>[
      if (hc > 9)
        for (var n = 10; n <= hc; n++) BookTabItem.hole(pageIndex: n, holeNumber: n),
      if (hc > 9) BookTabItem.scorecard(pageIndex: lastPage),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('GC Winterberg', style: TextStyle(fontSize: 16)),
            Text(
              _contextLabel(locale, hc),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: GolfPalette.inkSoft),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: locale.t('newRound'),
            onPressed: () => _onNewRound(rounds),
          ),
          _MoreMenuButton(locale: locale),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            child: BookTabRail(
              side: BookTabSide.left,
              items: leftItems,
              activePage: _activePage,
              onSelectPage: _jumpToPage,
            ),
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _activePage = i),
              children: pages,
            ),
          ),
          if (rightItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              child: BookTabRail(
                side: BookTabSide.right,
                items: rightItems,
                activePage: _activePage,
                onSelectPage: _jumpToPage,
              ),
            ),
        ],
      ),
    );
  }

  String _contextLabel(LocaleService locale, int hc) {
    if (_activePage == 0) return locale.t('settingsTitle');
    if (_activePage == hc + 1) return locale.t('scorecardTitle');
    return '${locale.t('hole')} $_activePage';
  }
}

class _MoreMenuButton extends StatelessWidget {
  final LocaleService locale;

  const _MoreMenuButton({required this.locale});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'features':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FeatureOverviewScreen()),
            );
            break;
          case 'clubs':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ClubsScreen()),
            );
            break;
          case 'report':
            showReportIssueDialog(context);
            break;
          case 'about':
            showAboutAppDialog(context);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'features',
          child: ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: Text(locale.t('menuFeatureOverview')),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: 'clubs',
          child: ListTile(
            leading: const Icon(Icons.sports_golf_outlined),
            title: Text(locale.t('menuClubs')),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: 'report',
          child: ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: Text(locale.t('menuReportIssue')),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: 'about',
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(locale.t('menuAbout')),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
