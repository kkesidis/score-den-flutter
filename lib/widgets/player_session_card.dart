import 'package:flutter/material.dart';
import '../models/board_game.dart';
import './stylized_card.dart';
import '../l10n/app_localizations.dart';
import './score_form.dart';

class PlayerSessionCard extends StatelessWidget {
  final BoardGame game;
  final PlayerSession player;
  final bool isWinner;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onHistory;
  final ValueChanged<ScoreOp> onScore;
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
    final Color highlightColor = player.getColor(game);
    final playsFirst = player.playsFirst ?? false;

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
                Flexible(
                  child: Text(
                    playerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),

                if (playsFirst)
                  const Icon(
                    Icons.flag_outlined,
                    color: Colors.amber,
                    size: 18,
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
                          backgroundColor: Theme.of(context).colorScheme.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(Icons.remove, color: Theme.of(context).colorScheme.onError),
                        onPressed: () {
                          onQuickSubtract();
                        },
                        onLongPress: () {
                          onScore(ScoreOp.subtract);
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
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
                        onPressed: () {
                          onQuickAdd();
                        },
                        onLongPress: () {
                          onScore(ScoreOp.add);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              onScore(ScoreOp.add);
            },
          )
        ],
      ),
    );
  }
}