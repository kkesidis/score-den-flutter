import 'package:flutter/material.dart';
import '../main.dart'; // Imports our global 'isar' instance
import '../models/board_game.dart';
import 'dart:async';
import '../l10n/app_localizations.dart';
import '../widgets/session_card.dart';
import '../widgets/session_form.dart';
import 'player_scores_screen.dart';
import '../widgets/base_layout.dart';
import '../widgets/empty_state_card.dart';

class MatchSessionsScreen extends StatefulWidget {
  final int gameId;

  const MatchSessionsScreen({super.key, required this.gameId});

  @override
  State<MatchSessionsScreen> createState() => _MatchSessionsScreenState();
}

class _MatchSessionsScreenState extends State<MatchSessionsScreen> {
  BoardGame? _game;
  StreamSubscription? _dbSubscription;

  @override
  void initState() {
    super.initState();
    _loadGameData();
    _listenToDatabaseChanges();
  }

  void _loadGameData() async {
    final game = await isar.boardGames.get(widget.gameId);
    if (mounted) {
      setState(() {
        _game = game;
      });
    }
  }

  // Set up a listener so if the parent game updates, this screen reflects it instantly
  void _listenToDatabaseChanges() {
    _dbSubscription = isar.boardGames.watchObjectLazy(widget.gameId).listen((_) async {
      final updatedGame = await isar.boardGames.get(widget.gameId);
      if (updatedGame != null && mounted) {
        setState(() {
          _game = updatedGame;
        });
      }
    });
  }

  @override
  void dispose() {
    _dbSubscription?.cancel(); // <-- Stop listening when screen is destroyed
    super.dispose();
  }

  void _showSessionDialog({int? actualIndex}) {
    final nameController = TextEditingController();
    final isEditing = actualIndex != null;
    MatchSession? existingSession;

    if (isEditing) {
      existingSession = _game!.sessions[actualIndex];
      nameController.text = existingSession.name ?? '';
    }

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
              child: SessionForm(
                game: _game!,
                existingSession: existingSession,
                onAdd: (newSession) async {
                  final updatedSessions = _game!.sessions.toList();
                  updatedSessions.add(newSession);

                  _game!.sessions = updatedSessions;
                  await isar.writeTxn(() async {
                    await isar.boardGames.put(_game!);
                  });

                  if (context.mounted) Navigator.pop(context);
                },
                onSave: (sessionToSave) async {
                  final updatedSessions = _game!.sessions.toList();
                  updatedSessions[actualIndex!] = sessionToSave;

                  _game!.sessions = updatedSessions;
                  await isar.writeTxn(() async {
                    await isar.boardGames.put(_game!);
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

  void _showDeleteConfirmationDialog(int actualIndex, String sessionName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteSessionTitle),
          content: Text(
            AppLocalizations.of(context)!.deleteSessionDescription(sessionName),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () {
                _deleteSession(actualIndex);
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );
  }

  // 3. ACTUAL ISAR DELETE TRANSACTION
  void _deleteSession(int actualIndex) async {
    final updatedSessions = _game!.sessions.toList();
    updatedSessions.removeAt(actualIndex); // Pull it out of the array slot
    _game!.sessions = updatedSessions;

    await isar.writeTxn(() async {
      await isar.boardGames.put(_game!);
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.sessionRemoved)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_game == null) {
      return Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context)!.couldNotFindGame),
        ),
      );
    }

    // Read the list from our dynamically updated local game variable
    final sessions = _game!.sessions;

    return BaseLayout(
      title: Text(AppLocalizations.of(context)!.sessionsTitle),
      subtitle: Text(
        _game!.name,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.onSurface.withValues(
            alpha: 0.6,
          ), // Fades out the subtitle nicely
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSessionDialog,
        child: const Icon(Icons.add),
      ),
      child: sessions.isEmpty
        ? EmptyStateCard(child: Text(AppLocalizations.of(context)!.noSessionsYet))
        : ListView.builder(
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            // REVERSE ORDER LOGIC:
            // Instead of counting 0, 1, 2... from the front,
            // we count backwards from the last item in the list.
            final reversedIndex = sessions.length - 1 - index;
            final session = sessions[reversedIndex];

            // Use the true list placement index for the default naming fallback
            final sessionName = session.name ?? AppLocalizations.of(context)!.indexedSession(reversedIndex + 1);

            return SessionCard(
              game: _game!,
              session: session,
              sessionIndex: reversedIndex,
              onSelect: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerScoresScreen(
                      gameId: _game!.id,
                      sessionIndex: reversedIndex,
                    ),
                  ),
                );
              },
              onEdit: () {
                _showSessionDialog(actualIndex: reversedIndex);
              },
              onDelete: () {
                _showDeleteConfirmationDialog(
                  reversedIndex,
                  sessionName,
                );
              }
            );
          },
        )
    );
  }
}
