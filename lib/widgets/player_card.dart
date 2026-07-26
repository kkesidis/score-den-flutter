import 'package:flutter/material.dart';
import '../models/player.dart';
import './stylized_card.dart';
import '../l10n/app_localizations.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSelect;

  const PlayerCard({
    super.key,
    required this.player,
    required this.onEdit,
    required this.onDelete,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final highlightColor = Color(player.colorValue);

    return StylizedCard(
      shadowColor: highlightColor,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              player.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: highlightColor,
                  ),
                  tooltip: l10n.editPlayer,
                  onPressed: () {
                    onEdit();
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error
                  ),
                  tooltip: l10n.removePlayer,
                  onPressed: () {
                    onDelete();
                  },
                ),
                const Icon(Icons.chevron_right)
              ],
            ),
            onTap: () {
              onSelect();
            },
          ),
        ],
      ),
    );
  }
}