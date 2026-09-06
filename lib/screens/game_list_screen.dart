import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';
import '../main.dart';
import '../models/board_game.dart';
import '../l10n/app_localizations.dart';
import '../widgets/game_card.dart';
import '../widgets/game_form.dart';
import 'match_sessions_screen.dart';
import '../widgets/base_layout.dart';
import '../widgets/empty_state_card.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  State<GameListScreen> createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  List<BoardGame> _games = [];

  @override
  void initState() {
    super.initState();
    _readGamesFromDatabase();
    _listenToDatabaseChanges();
  }

  void _readGamesFromDatabase() async {
    final allGames = await isar.boardGames.where().findAll();
    setState(() {
      _games = allGames;
    });
  }

  void _listenToDatabaseChanges() {
    isar.boardGames.watchLazy().listen((_) {
      _readGamesFromDatabase();
    });
  }

  void _showDeleteConfirmationDialog(BoardGame game) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteBoardGameTitle),
          content: Text(AppLocalizations.of(context)!.deleteBoardGameDescription(game.name)),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), // Close the dialog, do nothing
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () {
                _deleteGame(game.id); // Run the actual Isar delete code
                Navigator.pop(context); // Close the dialog
              },
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );
  }

  void _deleteGame(int id) async {
    await isar.writeTxn(() async {
      await isar.boardGames.delete(id);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.gameDeleted)),
      );
    }
  }

  void _showGameDialog({BoardGame? existingGame}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to resize when keyboards push up
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return SafeArea(
              top: true,
              bottom: true,
              child: GameForm(
                existingGame: existingGame,
                onSubmit: (gameToSave) async {
                  await isar.writeTxn(() async {
                    await isar.boardGames.put(gameToSave);
                  });

                  if (context.mounted) Navigator.pop(context);
                }
              )
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedGames = List.from(_games)..sort((a, b) => 
      a.name.toLowerCase().compareTo(b.name.toLowerCase())
    );

    return BaseLayout(
      title: const Text('ScoreDen'),
      subtitle: Text(
        AppLocalizations.of(context)!.gamesTracked(_games.length),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.onSurface.withValues(
            alpha: 0.6,
          ), // Fades out the subtitle nicely
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showGameDialog(),
        child: const Icon(Icons.add),
      ),
      child: sortedGames.isEmpty
        ? EmptyStateCard(child: Text(AppLocalizations.of(context)!.noGamesYet))
        : ListView.builder(
            itemCount: sortedGames.length,
            itemBuilder: (context, index) {
              final BoardGame game = sortedGames[index];

              return GameCard(
                game: game,
                onSelect: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MatchSessionsScreen(gameId: game.id),
                    ),
                  );
                },
                onEdit: () {
                  _showGameDialog(existingGame: game);
                },
                onDelete: () {
                  _showDeleteConfirmationDialog(game);
                },
              );
            },
          )
    );
  }
}
