// "Buchregister"-Reiterleiste (links: Zahnrad + Löcher 1-9 [+ Scorecard bei
// 9-Loch-Runde]; rechts: Löcher 10-18 + Scorecard bei 18-Loch-Runde).
// Nachbau von renderHoleColumns()/holeListItem()/settingsListItem()/
// scorecardListItem() aus js/app.js: jeder Reiter ist ein eigenständiges,
// zur Buchmitte hin eckiges, außen abgerundetes Element mit Schatten; der
// aktive Reiter hebt sich per Gold-Farbe ab und "poppt" leicht heraus.

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

  const BookTabRail({
    super.key,
    required this.side,
    required this.items,
    required this.activePage,
    required this.onSelectPage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          side == BookTabSide.left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        for (final item in items) _buildTab(context, item),
      ],
    );
  }

  Widget _buildTab(BuildContext context, BookTabItem item) {
    final isActive = item.pageIndex == activePage;
    final outerRadius = const Radius.circular(10);
    final borderRadius = side == BookTabSide.left
        ? BorderRadius.only(topLeft: outerRadius, bottomLeft: outerRadius)
        : BorderRadius.only(topRight: outerRadius, bottomRight: outerRadius);

    final label = switch (item.kind) {
      BookTabKind.settings => const Icon(Icons.settings, size: 15),
      BookTabKind.scorecard => const Icon(Icons.table_chart_outlined, size: 15),
      BookTabKind.hole => Text(
          '${item.holeNumber}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: isActive ? GolfPalette.gold : GolfPalette.surface,
        elevation: isActive ? 3 : 1,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () => onSelectPage(item.pageIndex),
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            transform: isActive
                ? Matrix4.translationValues(side == BookTabSide.left ? -2 : 2, 0, 0)
                : Matrix4.identity(),
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
    );
  }
}
