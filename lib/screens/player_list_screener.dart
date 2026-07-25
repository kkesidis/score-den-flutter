import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../l10n/app_localizations.dart';
import '../widgets/base_layout.dart';
import '../widgets/empty_state_card.dart';
import '../models/player.dart';
import '../widgets/player_form.dart';
import '../widgets/player_card.dart';

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({super.key});

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  List<Player> _players = [];

  @override
  void initState() {
    super.initState();
    _readPlayersFromDatabase();
    _listenToDatabaseChanges();
  }

  void _readPlayersFromDatabase() async {
    final allPlayers = await isar.players.where().findAll();

    // Guard against calling setState after the widget is popped/disposed
    if (!mounted) return;

    setState(() {
      _players = allPlayers;
    });
  }

  void _listenToDatabaseChanges() {
    isar.players.watchLazy().listen((_) {
      _readPlayersFromDatabase();
    });
  }

  void _showDeleteConfirmationDialog(Player player) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deletePlayerTitle),
          content: Text(AppLocalizations.of(context)!.deletePlayerDescription(player.name)),
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
                _deletePlayer(player.id); // Run the actual Isar delete code
                Navigator.pop(context); // Close the dialog
              },
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );
  }

  void _deletePlayer(int id) async {
    await isar.writeTxn(() async {
      await isar.players.delete(id);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.playerDeleted)),
      );
    }
  }

  void _showPlayerDialog({Player? existingPlayer}) {
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
            return PlayerForm(
              existingPlayer: existingPlayer,
              onSubmit: (playerToSave) async {
                await isar.writeTxn(() async {
                  await isar.players.put(playerToSave);
                });

                if (context.mounted) Navigator.pop(context);
              }
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedPlayers = List.from(_players)..sort((a, b) => 
      a.name.toLowerCase().compareTo(b.name.toLowerCase())
    );

    return BaseLayout(
      title: const Text('ScoreDen'),
      subtitle: Text(
        AppLocalizations.of(context)!.playersTracked(_players.length),
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
            _showPlayerDialog(),
        child: const Icon(Icons.add),
      ),
      child: sortedPlayers.isEmpty
        ? EmptyStateCard(child: Text(AppLocalizations.of(context)!.noPlayersYet))
        : ListView.builder(
            itemCount: sortedPlayers.length,
            itemBuilder: (context, index) {
              final Player player = sortedPlayers[index];

              return PlayerCard(
                player: player,
                // onSelect: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) {
                //         // TODO  
                //       }
                //     ),
                //   );
                // },
                onEdit: () {
                  _showPlayerDialog(existingPlayer: player);
                },
                onDelete: () {
                  _showDeleteConfirmationDialog(player);
                },
              );
            },
          )
    );
  }
}
