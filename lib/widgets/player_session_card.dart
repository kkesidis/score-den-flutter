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
  final VoidCallback onQuickAdd;
  final VoidCallback onQuickSubtract;

  const PlayerSessionCard({
    super.key,
    required this.game,
    required this.player,
    required this.isWinner,
    required this.onEdit,
    required this.onDelete,
    required this.onHistory,
    required this.onScore,
    required this.onQuickAdd,
    required this.onQuickSubtract,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final playerName = player.playerName ?? l10n.genericPlayerName;

    final inheritedColor = player.playerColorValue ?? game.colorValue;
    final Color highlightColor = inheritedColor != null ? Color(inheritedColor) : AppTheme.palette.first;

    const double scoreSize = 50;

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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                
                if (isWinner)
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 18,
                  ),
              ],
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
              child: SizedBox(
                height: scoreSize,
                child: Row(
                  spacing: 8,
                  children: [
                    SizedBox(
                      width: scoreSize,
                      height: scoreSize,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: highlightColor, width: 1.5),
                          ),
                        ),
                        icon: Icon(Icons.remove, color: highlightColor),
                        onPressed: () {
                          onQuickSubtract();
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: scoreSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: highlightColor,
                            width: 1.5,
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
                    SizedBox(
                      width: scoreSize,
                      height: scoreSize,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: highlightColor, width: 1.5),
                          ),
                        ),
                        icon: Icon(Icons.add, color: highlightColor),
                        onPressed: () {
                          onQuickAdd();
                        },
                      ),
                    ),
                  ],
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