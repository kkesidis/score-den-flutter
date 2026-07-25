import 'package:flutter/material.dart';
import '../models/player.dart';
import './stylized_card.dart';
import '../l10n/app_localizations.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PlayerCard({
    super.key,
    required this.player,
    required this.onEdit,
    required this.onDelete,
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
            title: Row(
              spacing: 8.0,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // subtitle: Padding(
            //   padding: const EdgeInsets.only(top: 8.0),
            //   child: Row(
            //     children: [
            //       Container(
            //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            //         decoration: BoxDecoration(
            //           // Standard translucent chip background: rgba(255, 255, 255, 0.07)
            //           color: Theme.of(context).colorScheme.secondaryContainer, 
            //           borderRadius: BorderRadius.circular(16),
            //         ),
            //         child: Row(
            //           mainAxisSize: MainAxisSize.min, // Wraps container tightly around content
            //           children: [
            //             Icon(
            //               Icons.layers_outlined,
            //               size: 13,
            //               color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            //             ),
            //             const SizedBox(width: 6),
            //             Text.rich(
            //               TextSpan(
            //                 children: [
            //                   TextSpan(
            //                     text: '$totalRounds ',
            //                     style: TextStyle(
            //                       color: highlightColor,
            //                       fontWeight: FontWeight.w600, // Pop highlighting matching your other metric chips
            //                     ),
            //                   ),
            //                   TextSpan(
            //                     text: l10n.rounds, // Simplified text to fit standard metadata patterns
            //                   ),
            //                 ],
            //                 style: TextStyle(
            //                   fontSize: 12,
            //                   fontWeight: FontWeight.w500,
            //                   color: Theme.of(context).colorScheme.onSecondaryContainer,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   )
            // ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}