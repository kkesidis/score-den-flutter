import 'package:flutter/material.dart';
import '../models/board_game.dart';
import '../l10n/app_localizations.dart';

class PlayerSessionScoreHistory extends StatelessWidget {
  final PlayerSession player;
  final void Function(int) onEdit;
  final void Function(int) onDelete;

  const PlayerSessionScoreHistory({
    super.key,
    required this.player,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scores = player.scores;

    return Padding(
      padding: EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom:
            MediaQuery.of(context).viewInsets.bottom +
            16.0, // Keyboard safety
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.scoreHistory(player.playerName ?? l10n.genericPlayerName),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          scores.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(AppLocalizations.of(context)!.noScoresYet),
                ),
              )
            : Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: scores.length,
                itemBuilder: (context, index) {
                  final reversedIndex = scores.length - 1 - index;
                  final entry = scores[reversedIndex];

                  final valueString = (entry.value ?? 0) >= 0
                      ? '+${entry.value}'
                      : '${entry.value}';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: (entry.value ?? 0) >= 0
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.error,
                      child: Text(
                        '#${reversedIndex + 1}',
                        style: TextStyle(
                          color: (entry.value ?? 0) >= 0
                            ? Theme.of(context).colorScheme.onSecondary
                            : Theme.of(context).colorScheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      '$valueString ${AppLocalizations.of(context)!.points}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: entry.description != null
                      ? Text(
                        entry.description!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        )
                      )
                      : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // EDIT ENTRY BUTTON
                        IconButton(
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          onPressed: () {
                            onEdit(reversedIndex);
                          },
                        ),
                        // DELETE ENTRY BUTTON
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Theme.of(context).colorScheme.error,
                            size: 20,
                          ),
                          onPressed: () {
                            onDelete(reversedIndex);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}