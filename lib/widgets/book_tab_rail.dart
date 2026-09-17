// "Buchregister"-Reiterleiste (links: Zahnrad + Löcher 1-9 [+ Scorecard bei
// 9-Loch-Runde]; rechts: Löcher 10-18 + Scorecard bei 18-Loch-Runde).
// Nachbau von renderHoleColumns()/holeListItem()/settingsListItem()/
// scorecardListItem() aus js/app.js: einzelne, ringsum abgerundete
// "Karteikarten"-Reiter mit schmalen Zwischenräumen, die sich gleichmäßig
// über die volle Höhe verteilen; der aktive Reiter hebt sich per Gold-Farbe
// ab, ist breiter als die übrigen und "poppt" so sichtbar in Richtung
// Seiteninhalt heraus (Referenz-Screenshot des Nutzers vom 17.09.2026).

import 'package:flutter/material.dart';

import '../theme/golf_palette.dart';

enum BookTabSide { left, right }

enum BookTabKind { settings, hole, scorecard }

class BookTabItem {
  final BookTabKind kind;
  final int pageIndex;
  final int? holeNumber;

  const BookTabItem.settings({required this.pageIndex})
      : kind = BookTabKind.settings,
        holeNumber = null;

  const BookTabItem.hole({required this.pageIndex, required this.holeNumber})
      : kind = BookTabKind.hole;

  const BookTabItem.scorecard({required this.pageIndex})
      : kind = BookTabKind.scorecard,
        holeNumber = null;
}

class BookTabRail extends StatelessWidget {
  final BookTabSide side;
  final List<BookTabItem> items;
  final int activePage;
  final ValueChanged<int> onSelectPage;

  static const double _baseWidth = 30;
  static const double _activeExtraWidth = 10;

  const BookTabRail({
    super.key,
    required this.side,
    required this.items,
    required this.activePage,
    required this.onSelectPage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _baseWidth + _activeExtraWidth,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment:
            side == BookTabSide.left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          for (final item in items)
            Expanded(
              child: _buildTab(context, item),
            ),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, BookTabItem item) {
    final isActive = item.pageIndex == activePage;
    final radius = BorderRadius.circular(10);

    final label = switch (item.kind) {
      BookTabKind.settings => Icon(Icons.settings, size: isActive ? 17 : 15),
      BookTabKind.scorecard =>
        Icon(Icons.table_chart_outlined, size: isActive ? 17 : 15),
      BookTabKind.hole => Text(
          '${item.holeNumber}',
          style: TextStyle(
            fontSize: isActive ? 15 : 12,
            fontWeight: FontWeight.w700,
          ),
        ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
        width: isActive ? _baseWidth + _activeExtraWidth : _baseWidth,
        alignment: side == BookTabSide.left ? Alignment.centerLeft : Alignment.centerRight,
        child: Material(
          color: isActive ? GolfPalette.gold : GolfPalette.surface,
          elevation: isActive ? 4 : 1,
          shadowColor: GolfPalette.ink.withOpacity(0.35),
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: () => onSelectPage(item.pageIndex),
            child: Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  color: isActive ? GolfPalette.surface : GolfPalette.inkSoft,
                ),
                child: IconTheme(
                  data: IconThemeData(
                    color: isActive ? GolfPalette.surface : GolfPalette.inkSoft,
                  ),
                  child: label,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
