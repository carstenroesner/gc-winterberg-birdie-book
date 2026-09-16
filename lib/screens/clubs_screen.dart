// "Schläger"-Bildschirm: Anzeige-Liste (mit rein visueller Auswahl) oder
// Sammel-Bearbeitungsmodus (Bulk-Edit: hinzufügen/entfernen/editieren,
// Speichern/Abbrechen). 1:1-Verhalten aus renderClubs() in js/app.js.
// Erreichbar über das Standard-⋮-Menü (Punkt "Schläger"), siehe
// PFLICHTENHEFT.md / Migrationsplan.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/clubs_service.dart';
import '../services/locale_service.dart';
import '../widgets/club_edit_row.dart';
import '../widgets/club_list_item.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  String? _selectedClubId;
  String? _lastAddedClubId;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final clubsService = context.watch<ClubsService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.t('clubsTitle')),
        actions: [
          if (!clubsService.editMode)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: locale.t('edit'),
              onPressed: clubsService.startEdit,
            ),
        ],
      ),
      body: clubsService.editMode
          ? _buildEditMode(context, locale, clubsService)
          : _buildDisplayMode(context, locale, clubsService),
      bottomNavigationBar: clubsService.editMode
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: clubsService.cancelEdit,
                        child: Text(locale.t('cancel')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          await clubsService.saveEdit();
                          setState(() => _selectedClubId = null);
                        },
                        child: Text(locale.t('save')),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildDisplayMode(
    BuildContext context,
    LocaleService locale,
    ClubsService clubsService,
  ) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(
          locale.t('clubsSub'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        for (final club in clubsService.clubs)
          ClubListItem(
            club: club,
            selected: _selectedClubId == club.id,
            noDistanceLabel: locale.t('noDistance'),
            onTap: () => setState(() {
              _selectedClubId = _selectedClubId == club.id ? null : club.id;
            }),
          ),
      ],
    );
  }

  Widget _buildEditMode(
    BuildContext context,
    LocaleService locale,
    ClubsService clubsService,
  ) {
    final buffer = clubsService.editBuffer;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (var i = 0; i < buffer.length; i++)
          ClubEditRow(
            key: ValueKey(buffer[i].id),
            club: buffer[i],
            locale: locale,
            autofocusName: buffer[i].id == _lastAddedClubId,
            onNameChanged: (v) => clubsService.updateBufferName(i, v),
            onMinChanged: (v) => clubsService.updateBufferMin(i, v),
            onMaxChanged: (v) => clubsService.updateBufferMax(i, v),
            onRemove: () => clubsService.removeFromBuffer(i),
          ),
        OutlinedButton.icon(
          onPressed: () {
            clubsService.addBlankToBuffer();
            setState(() => _lastAddedClubId = clubsService.editBuffer.last.id);
          },
          icon: const Icon(Icons.add),
          label: Text(locale.t('addClub')),
        ),
      ],
    );
  }
}
