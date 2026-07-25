import 'package:flutter/material.dart';
import '../models/board_game.dart';
import '../theme/app_theme.dart';
import './stylized_card.dart';
import '../l10n/app_localizations.dart';

class PlayerSessionCard extends StatelessWidget {
  final BoardGame game;
  final PlayerSession player;
  final bool isWinner;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onHistory;
  final VoidCallback onScore;

  const PlayerSessionCard({
    super.key,
    required this.game,
    required this.player,
    required this.isWinner,
    required this.onEdit,
    required this.onDelete,
    required this.onHistory,
    required this.onScore,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final playerName = player.playerName ?? l10n.genericPlayerName;
    final totalRounds = player.scores.length;

    final inheritedColor = player.playerColorValue ?? game.colorValue;
    final Color highlightColor = inheritedColor != null ? Color(inheritedColor) : AppTheme.palette.first;

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
                  playerName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                
                if (isWinner)
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 18,
                  ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      // Standard translucent chip background: rgba(255, 255, 255, 0.07)
                      color: Theme.of(context).colorScheme.secondaryContainer, 
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Wraps container tightly around content
                      children: [
                        Icon(
                          Icons.layers_outlined,
                          size: 13,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 6),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '$totalRounds ',
                                style: TextStyle(
                                  color: highlightColor,
                                  fontWeight: FontWeight.w600, // Pop highlighting matching your other metric chips
                                ),
                              ),
                              TextSpan(
                                text: l10n.rounds, // Simplified text to fit standard metadata patterns
                              ),
                            ],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
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
                    Icons.history,
                    color: highlightColor,
                  ),
                  tooltip: l10n.viewScoreHistory,
                  onPressed: () {
                    onHistory();
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
          ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: highlightColor, // Replace with your desired border color
                    width: 1.5,                           // Border thickness
                  ),
                ),
                child: Text(
                  '${player.totalScore}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: highlightColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            onTap: () {
              onScore();
            },
          )
        ],
      ),
    );
  }
}