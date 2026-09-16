// Ein Schläger in der Anzeige-Liste (nicht im Bearbeitungsmodus). Tippen
// wählt den Schläger nur visuell aus (rein optischer Zustand, keine
// Persistenz) – 1:1-Verhalten aus dem `.list-item`/`state.selectedClubId`
// in js/app.js.

import 'package:flutter/material.dart';

import '../models/club.dart';
import '../theme/golf_palette.dart';

String formatClubDistance(Club club, String noDistanceLabel) {
  if (club.min == null || club.max == null) return noDistanceLabel;
  return '${club.min}–${club.max} m';
}

class ClubListItem extends StatelessWidget {
  final Club club;
  final bool selected;
  final String noDistanceLabel;
  final VoidCallback onTap;

  const ClubListItem({
    super.key,
    required this.club,
    required this.selected,
    required this.noDistanceLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected ? GolfPalette.chip : null,
      child: ListTile(
        leading: const Icon(Icons.sports_golf, color: GolfPalette.green),
        title: Text(club.name),
        subtitle: Text('${club.category} · ${formatClubDistance(club, noDistanceLabel)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
