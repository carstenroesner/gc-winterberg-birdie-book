// "Buchregister"-Reiterleiste (links: Zahnrad + Löcher 1-9 [+ Scorecard bei
// 9-Loch-Runde]; rechts: Löcher 10-18 + Scorecard bei 18-Loch-Runde).
// Nachbau von renderHoleColumns()/holeListItem()/settingsListItem()/
// scorecardListItem() aus js/app.js: die Reiter bilden EINE durchgehende,
// flächige Leiste (nur die äußeren Enden abgerundet, dünne Trennlinien
// zwischen den Zellen), die sich gleichmäßig über die volle Höhe verteilt;
// der aktive Reiter hebt sich per Gold-Farbe ab und "poppt" leicht heraus.

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
    final outerRadius = const Radius.circular(10);
    final borderRadius = side == BookTabSide.left
        ? BorderRadius.only(topLeft: outerRadius, bottomLeft: outerRadius)
        : BorderRadius.only(topRight: outerRadius, bottomRight: outerRadius);

    return SizedBox(
      width: 30,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Material(
          color: GolfPalette.surface,
          elevation: 2,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _buildTab(context, items[i], isLast: i == items.length - 1),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, BookTabItem item, {required bool isLast}) {
    final isActive = item.pageIndex == activePage;

    final label = switch (item.kind) {
      BookTabKind.settings => const Icon(Icons.settings, size: 15),
      BookTabKind.scorecard => const Icon(Icons.table_chart_outlined, size: 15),
      BookTabKind.hole => Text(
          '${item.holeNumber}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isActive ? GolfPalette.gold : GolfPalette.surface,
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: GolfPalette.line, width: 1)),
      ),
      child: InkWell(
        onTap: () => onSelectPage(item.pageIndex),
        child: Center(
          child: Transform.translate(
            offset: isActive
                ? Offset(side == BookTabSide.left ? -2 : 2, 0)
                : Offset.zero,
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
