// Eine Zeile im Schläger-Bearbeitungsmodus (Bulk-Edit): Name, Min-/Max-
// Distanz, Entfernen-Button. 1:1-Verhalten aus `.club-edit-row` in
// js/app.js. Bewusste bestehende Einschränkung (siehe PFLICHTENHEFT.md):
// nur Sammel-Bearbeitung, kein Dialog pro einzelnem Schläger.

import 'package:flutter/material.dart';

import '../models/club.dart';
import '../services/locale_service.dart';

class ClubEditRow extends StatefulWidget {
  final Club club;
  final LocaleService locale;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<int?> onMinChanged;
  final ValueChanged<int?> onMaxChanged;
  final VoidCallback onRemove;
  final bool autofocusName;

  const ClubEditRow({
    super.key,
    required this.club,
    required this.locale,
    required this.onNameChanged,
    required this.onMinChanged,
    required this.onMaxChanged,
    required this.onRemove,
    this.autofocusName = false,
  });

  @override
  State<ClubEditRow> createState() => _ClubEditRowState();
}

class _ClubEditRowState extends State<ClubEditRow> {
  late final TextEditingController _nameController;
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.club.name);
    _minController = TextEditingController(text: widget.club.min?.toString() ?? '');
    _maxController = TextEditingController(text: widget.club.max?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              autofocus: widget.autofocusName,
              maxLength: 30,
              decoration: InputDecoration(labelText: widget.locale.t('clubName')),
              onChanged: widget.onNameChanged,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: widget.locale.t('minDist')),
                    onChanged: (v) => widget.onMinChanged(v.isEmpty ? null : int.tryParse(v)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: widget.locale.t('maxDist')),
                    onChanged: (v) => widget.onMaxChanged(v.isEmpty ? null : int.tryParse(v)),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: widget.locale.t('delete'),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
