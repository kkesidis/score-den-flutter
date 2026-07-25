import 'package:flutter/material.dart';
import '../main.dart';
import '../models/board_game.dart';
import '../l10n/app_localizations.dart';
import '../widgets/player_session_card.dart';
import '../widgets/player_session_score_history.dart';
import '../widgets/player_session_form.dart';
import '../widgets/score_form.dart';
import '../widgets/base_layout.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/player_quick_selection.dart';

class PlayerScoresScreen extends StatefulWidget {
  final int gameId;
  final int sessionIndex;

  const PlayerScoresScreen({
    super.key,
    required this.gameId,
    required this.sessionIndex,
  });

  @override
  State<PlayerScoresScreen> createState() => _PlayerScoresScreenState();
}

class _PlayerScoresScreenState extends State<PlayerScoresScreen> {
  BoardGame? _game;

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

  void _listenToDatabaseChanges() {
    isar.boardGames.watchObjectLazy(widget.gameId).listen((_) {
      _loadGameData();
    });
  }

  void _showPlayerFormBottomSheet({int? playerIndexInDatabase}) {
    if (_game == null) return;

    PlayerSession? existingPlayer;
    final currentMatchSession = _game!.sessions[widget.sessionIndex];
    final playerIdsInGame = currentMatchSession.players.map((player) => player.playerId).whereType<int>().toList();

    if (playerIndexInDatabase != null) {
      existingPlayer = currentMatchSession.players[playerIndexInDatabase];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return DefaultTabController(
              length: 2, // Number of tabs
              child: Column(
                children: [
                  // The Drag Handle (Optional visual indicator)
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  TabBar(
                    labelColor: Theme.of(context).colorScheme.onPrimary,
                    unselectedLabelColor: Theme.of(context).colorScheme.onSecondary,
                    tabs: [
                      Tab(text: AppLocalizations.of(context)!.guestTab),
                      Tab(text: AppLocalizations.of(context)!.playersTab),
                    ],
                  ),

                  Expanded(
                    child: TabBarView(
                      children: [
                        PlayerSessionForm(
                          game: _game!,
                          existingPlayer: existingPlayer,
                          onSubmit: (playerToSave) async {
                            final sessionsList = _game!.sessions.toList();
                            final currentMatchSession = sessionsList[widget.sessionIndex];
                            final playersList = (currentMatchSession.players).toList();

                            if (playerIndexInDatabase != null) {
                              playersList[playerIndexInDatabase] = playerToSave;
                            } else {
                              playersList.add(playerToSave);
                            }

                            currentMatchSession.players = playersList;
                            sessionsList[widget.sessionIndex] =
                                currentMatchSession;
                            _game!.sessions = sessionsList;

                            await isar.writeTxn(() async {
                              await isar.boardGames.put(_game!);
                            });

                            if (context.mounted) Navigator.pop(context);
                          },
                        ),
                        PlayerQuickSelection(
                          unavailablePlayerIds: playerIdsInGame,
                          onSelect: (player) async {
                            final sessionsList = _game!.sessions.toList();
                            final currentMatchSession = sessionsList[widget.sessionIndex];
                            final playersList = (currentMatchSession.players).toList();

                            final PlayerSession playerToSave = PlayerSession()
                              ..playerName = player.name
                              ..playerColorValue = player.colorValue
                              ..playerId = player.id;

                            playersList.add(playerToSave);

                            currentMatchSession.players = playersList;
                            sessionsList[widget.sessionIndex] =
                                currentMatchSession;
                            _game!.sessions = sessionsList;

                            await isar.writeTxn(() async {
                              await isar.boardGames.put(_game!);
                            });

                            setDialogState(() {
                              playerIdsInGame.add(player.id);
                            });
                          },
                          onCLose: () {
                            if (context.mounted) Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showScoreEntryFormBottomSheet(
    PlayerSession player,
    int playerIndexInDatabase, {
    int? scoreIndex, // Optional named param for editing
    StateSetter? setSheetState, // Optional named param for history panels
  }) {
    final ScoreEntry? existingEntry = scoreIndex != null
      ? player.scores[scoreIndex]
      : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return ScoreForm(
              game: _game!,
              player: player,
              score: existingEntry,
              onSubmit: (scoreToSave) async {
                if (_game == null) {
                  return;
                }

                final sessionsList = _game!.sessions.toList();
                final currentMatchSession = sessionsList[widget.sessionIndex];
                final playersList = currentMatchSession.players.toList();
                final targetPlayer = playersList[playerIndexInDatabase];
                final updatedScores = targetPlayer.scores.toList();

                if (scoreIndex != null) {
                  updatedScores[scoreIndex] = scoreToSave;
                } else {
                  updatedScores.add(scoreToSave);
                }

                targetPlayer.scores = updatedScores;
                playersList[playerIndexInDatabase] = targetPlayer;

                currentMatchSession.players = playersList;
                sessionsList[widget.sessionIndex] =
                    currentMatchSession;
                _game!.sessions = sessionsList;

                await isar.writeTxn(() async {
                  await isar.boardGames.put(_game!);
                });

                // Fire localized view updates back up to the calling history panel
                if (setSheetState != null) {
                  setSheetState(() {});
                }

                if (context.mounted) Navigator.pop(context);
              }
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int actualIndex, String playerName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.removePlayerTitle),
          content: Text(
            AppLocalizations.of(context)!.removePlayerDescription(playerName)
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
                _deletePlayer(actualIndex);
                Navigator.pop(context); // Close the dialog
              },
              child: Text(AppLocalizations.of(context)!.remove),
            ),
          ],
        );
      },
    );
  }

  void _deletePlayer(int playerIndexInList) async {
    if (_game == null) return;

    final sessionsList = _game!.sessions.toList();
    final currentMatchSession = sessionsList[widget.sessionIndex];
    final playersList = currentMatchSession.players.toList();

    playersList.removeAt(playerIndexInList);

    currentMatchSession.players = playersList;
    sessionsList[widget.sessionIndex] = currentMatchSession;
    _game!.sessions = sessionsList;

    await isar.writeTxn(() async {
      await isar.boardGames.put(_game!);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.playerRemoved)),
      );
    }
  }

  void _showPlayerHistorySheet(
    PlayerSession player,
    int playerIndexInDatabase,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to resize when keyboards push up
      useRootNavigator: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // StatefulBuilder allows the bottom sheet content to refresh in real-time
        // when a single entry is edited or deleted without closing the sheet!
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            if (_game == null) return const SizedBox.shrink();

            // Re-fetch the fresh live player instance from our synced state
            final currentMatch = _game!.sessions[widget.sessionIndex];
            final livePlayer = currentMatch.players[playerIndexInDatabase];

            return PlayerSessionScoreHistory(
              player: livePlayer,
              onEdit: (index) {
                _showScoreEntryFormBottomSheet(
                  livePlayer, // 1. Required positional player data object
                  playerIndexInDatabase, // 2. Required positional target database index slot
                  scoreIndex: index, // Named parameter identifying which entry is targeted
                  setSheetState: setSheetState, // Named parameter callback to force live data rebuilds below
                );
              },
              onDelete: (index) {
                _deleteSingleScoreEntry(
                  playerIndexInDatabase,
                  index,
                  setSheetState,
                );
              }
            );
          },
        );
      },
    );
  }

  // Deletes a single specific round entry out of the player's list
  void _deleteSingleScoreEntry(
    int playerIdx,
    int scoreIdx,
    StateSetter setSheetState,
  ) async {
    if (_game == null) return;

    final sessionsList = _game!.sessions.toList();
    final currentMatch = sessionsList[widget.sessionIndex];
    final playersList = currentMatch.players.toList();

    final targetPlayer = playersList[playerIdx];
    final updatedScores = targetPlayer.scores.toList();

    // Pull out just this specific round entry
    updatedScores.removeAt(scoreIdx);

    targetPlayer.scores = updatedScores;
    playersList[playerIdx] = targetPlayer;
    currentMatch.players = playersList;
    sessionsList[widget.sessionIndex] = currentMatch;
    _game!.sessions = sessionsList;

    await isar.writeTxn(() async {
      await isar.boardGames.put(_game!);
    });

    // Instantly refresh the bottom sheet log display
    setSheetState(() {});
  }

  // Creates a fresh match session pre-populated with the current players
  void _startRematch(List<PlayerSession> currentPlayers) async {
    if (_game == null) return;

    final existingPlayers = currentPlayers
        .where((p) => p.playerName?.isNotEmpty ?? false)
        .toList();

    if (existingPlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.addPlayersBeforeRematch),
        ),
      );
      return;
    }

    final sessionsList = _game!.sessions.toList();
    final nextMatchNumber = sessionsList.length + 1;

    final cleanRematchPlayers = existingPlayers.map((existingPlayer) {
      return PlayerSession()
        ..playerName = existingPlayer.playerName
        ..playerColorValue = existingPlayer.playerColorValue
        ..scores = [];
    }).toList();

    final newMatchSession = MatchSession()
      ..name = AppLocalizations.of(context)!.indexedSession(nextMatchNumber)
      ..dateTime = DateTime.now()
      ..players = cleanRematchPlayers;

    sessionsList.add(newMatchSession);
    _game!.sessions = sessionsList;

    await isar.writeTxn(() async {
      await isar.boardGames.put(_game!);
    });

    if (!mounted) return;

    // Pop the current screen off the stack, and replace it
    // with a brand new viewport targeted at the last index of the updated list!
    final newSessionIndex = sessionsList.length - 1;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerScoresScreen(
          gameId: widget.gameId,
          sessionIndex: newSessionIndex,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.startedRematch(nextMatchNumber)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_game == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentMatchSession = _game!.sessions[widget.sessionIndex];
    final basePlayers = currentMatchSession.players;
    final sessionName = currentMatchSession.name?.isEmpty ?? true ? AppLocalizations.of(context)!.indexedSession(widget.sessionIndex + 1) : currentMatchSession.name!;
    int? topPlayerIndex;

    final List<MapEntry<int, PlayerSession>> indexedPlayers = basePlayers
        .asMap()
        .entries
        .toList();

    if (indexedPlayers.isNotEmpty) {
      final MapEntry<int, PlayerSession> topPlayerEntry = _game!.highestScoreWins
        ? indexedPlayers.reduce((currentMax, next) => next.value.totalScore > currentMax.value.totalScore ? next : currentMax)
        : indexedPlayers.reduce((currentMin, next) => next.value.totalScore < currentMin.value.totalScore ? next : currentMin);

      topPlayerIndex = topPlayerEntry.key;
    }

    return BaseLayout(
      title: Text(sessionName),
      subtitle: Text(
        _game?.name ?? AppLocalizations.of(context)!.boardGame,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.onSurface.withValues(
            alpha: 0.6,
          ), // Fades out the subtitle nicely
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            _showPlayerFormBottomSheet, // Floating Action Button now strictly registers new names
        child: const Icon(Icons.add),
      ),
      additionalActions: [
        if (basePlayers.isNotEmpty)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: AppLocalizations.of(context)!.sessionOptions,
            onSelected: (String value) {
              if (value == 'rematch') {
                _startRematch(basePlayers);
              } 
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'rematch',
                child: Row(
                  children: [
                    const Icon(Icons.replay, size: 20),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.rematch),
                  ],
                ),
              ),
            ],
          )
      ],
      child: indexedPlayers.isEmpty
        ? EmptyStateCard(child: Text(AppLocalizations.of(context)!.noPlayersAddedYet))
        : ListView.builder(
            itemCount: indexedPlayers.length,
            itemBuilder: (context, index) {
              final entry = indexedPlayers[index];
              final trueIndexInDatabase = entry.key;
              final playerSession = entry.value;

              final playerName = playerSession.playerName ?? AppLocalizations.of(context)!.genericPlayerName;
              final isWinner = topPlayerIndex == index;

              return PlayerSessionCard(
                game: _game!,
                player: playerSession,
                isWinner: isWinner,
                onEdit: () {
                  _showPlayerFormBottomSheet(
                    playerIndexInDatabase: trueIndexInDatabase,
                  );
                },
                onDelete: () {
                  _showDeleteConfirmationDialog(
                    trueIndexInDatabase,
                    playerName,
                  );
                },
                onHistory: () {
                  _showPlayerHistorySheet(
                    playerSession,
                    trueIndexInDatabase,
                  );
                },
                onScore: () {
                  _showScoreEntryFormBottomSheet(
                    playerSession,
                    trueIndexInDatabase,
                  );
                }
              );
            },
          ),
    );
  }
}
