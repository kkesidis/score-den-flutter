import 'dart:math';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../l10n/app_localizations.dart';
import '../models/board_game.dart';
import '../widgets/base_layout.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/stylized_card.dart';

enum MatchResult { win, loss, tie }

class GameStats {
  final BoardGame game;
  final int sessionsPlayed;
  final int wins;
  final int losses;
  final int ties;
  final int highScore;
  final double averageScore;
  final int totalPoints;

  GameStats({
    required this.game,
    required this.sessionsPlayed,
    required this.wins,
    required this.losses,
    required this.ties,
    required this.highScore,
    required this.averageScore,
    required this.totalPoints,
  });

  double get winRate => sessionsPlayed > 0 ? (wins / sessionsPlayed) * 100 : 0.0;
}

class PlayerMatchHistory {
  final BoardGame game;
  final MatchSession session;
  final PlayerSession playerSession;
  final MatchResult result;

  PlayerMatchHistory({
    required this.game,
    required this.session,
    required this.playerSession,
    required this.result,
  });
}

class PlayerScreen extends StatefulWidget {
  final int playerId;

  const PlayerScreen({
    super.key,
    required this.playerId,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<BoardGame> _games = [];

  @override
  void initState() {
    super.initState();
    _readGamesFromDatabase();
    _listenToDatabaseChanges();
  }

  void _readGamesFromDatabase() async {
    final allGames = await isar.boardGames.where().findAll();
    if (mounted) {
      setState(() {
        _games = allGames;
      });
    }
  }

  void _listenToDatabaseChanges() {
    isar.boardGames.watchLazy().listen((_) => _readGamesFromDatabase());
  }

  /// Calculates statistics for a single game for this player.
  /// Returns null if the player has 0 sessions in this game.
  GameStats? _calculateStatsForGame(BoardGame game) {
    int sessionsPlayed = 0;
    int wins = 0;
    int losses = 0;
    int ties = 0;
    int totalPoints = 0;
    int? bestScore;

    for (final session in game.sessions) {
      // Find current player in this session
      final playerSession = session.players.firstWhere(
        (p) => p.playerId == widget.playerId,
        orElse: () => PlayerSession(),
      );

      // If player didn't participate in this session, skip
      if (playerSession.playerId == null) continue;

      sessionsPlayed++;
      final playerScore = playerSession.totalScore;
      totalPoints += playerScore;

      // Track high/best score (accounts for lowestScoreWins games)
      if (bestScore == null) {
        bestScore = playerScore;
      } else if (game.highestScoreWins) {
        bestScore = max(bestScore, playerScore);
      } else {
        bestScore = min(bestScore, playerScore);
      }

      // Compute Win / Loss / Tie status against all players in session
      if (session.players.length == 1) {
        // Single player session counts as a win
        wins++;
      } else {
        final allScores = session.players.map((p) => p.totalScore).toList();
        final winningScore = game.highestScoreWins
            ? allScores.reduce(max)
            : allScores.reduce(min);

        if (playerScore == winningScore) {
          // Check if multiple players tied for top score
          final topScorersCount = allScores.where((s) => s == winningScore).length;
          if (topScorersCount > 1) {
            ties++;
          } else {
            wins++;
          }
        } else {
          losses++;
        }
      }
    }

    if (sessionsPlayed == 0) return null; // Ignore empty games

    return GameStats(
      game: game,
      sessionsPlayed: sessionsPlayed,
      wins: wins,
      losses: losses,
      ties: ties,
      highScore: bestScore ?? 0,
      averageScore: totalPoints / sessionsPlayed,
      totalPoints: totalPoints,
    );
  }

  List<PlayerMatchHistory> _extractMatchHistory() {
    final List<PlayerMatchHistory> history = [];

    for (final game in _games) {
      for (final session in game.sessions) {
        final playerSession = session.players.firstWhere(
          (p) => p.playerId == widget.playerId,
          orElse: () => PlayerSession(),
        );

        // Skip if this player didn't participate in this session
        if (playerSession.playerId == null) continue;

        final playerScore = playerSession.totalScore;
        MatchResult result;

        if (session.players.length == 1) {
          result = MatchResult.win;
        } else {
          final allScores = session.players.map((p) => p.totalScore).toList();
          final winningScore = game.highestScoreWins
              ? allScores.reduce(max)
              : allScores.reduce(min);

          if (playerScore == winningScore) {
            final topScorersCount = allScores.where((s) => s == winningScore).length;
            result = topScorersCount > 1 ? MatchResult.tie : MatchResult.win;
          } else {
            result = MatchResult.loss;
          }
        }

        history.add(PlayerMatchHistory(
          game: game,
          session: session,
          playerSession: playerSession,
          result: result,
        ));
      }
    }

    // Sort chronologically (newest sessions first)
    history.sort((a, b) {
      final dateA = a.session.dateTime ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dateB = b.session.dateTime ?? DateTime.fromMillisecondsSinceEpoch(0);
      return dateB.compareTo(dateA);
    });

    return history;
  }

  @override
  Widget build(BuildContext context) {
    final gameStatsList = _games
      .map((g) => _calculateStatsForGame(g))
      .whereType<GameStats>()
      .toList()
      ..sort((a, b) => a.game.name.toLowerCase().compareTo(b.game.name.toLowerCase()));

    // Aggregated Overall Stats
    final totalSessions = gameStatsList.fold(0, (sum, g) => sum + g.sessionsPlayed);
    final totalWins = gameStatsList.fold(0, (sum, g) => sum + g.wins);
    final totalLosses = gameStatsList.fold(0, (sum, g) => sum + g.losses);
    final totalTies = gameStatsList.fold(0, (sum, g) => sum + g.ties);
    final overallWinRate = totalSessions > 0 ? (totalWins / totalSessions) * 100 : 0.0;

    final matchHistoryList = _extractMatchHistory();

    return BaseLayout(
      title: const Text('ScoreDen'),
      subtitle: Text(
        AppLocalizations.of(context)!.playerInformation,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      child: gameStatsList.isEmpty
          ? EmptyStateCard(child: Text(AppLocalizations.of(context)!.noPlayedSessions))
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildOverallSummaryCard(
                      context,
                      totalSessions: totalSessions,
                      totalWins: totalWins,
                      totalLosses: totalLosses,
                      totalTies: totalTies,
                      overallWinRate: overallWinRate,
                      uniqueGamesCount: gameStatsList.length,
                    ),
                  ),

                  TabBar(
                    tabs: [
                      Tab(text: AppLocalizations.of(context)!.gamesBreakdown),
                      Tab(text: AppLocalizations.of(context)!.matchHistory),
                    ],
                  ),

                  Expanded(
                    child: TabBarView(
                      children: [
                        ListView.separated(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: gameStatsList.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 6),
                          itemBuilder: (context, index) {
                            return _buildGameExpansionTile(context, gameStatsList[index]);
                          },
                        ),

                        _buildMatchHistoryList(context, matchHistoryList),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildOverallSummaryCard(
    BuildContext context, {
    required int totalSessions,
    required int totalWins,
    required int totalLosses,
    required int totalTies,
    required double overallWinRate,
    required int uniqueGamesCount,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(context, '$totalSessions', AppLocalizations.of(context)!.sessionsPlayed),
                _buildStatColumn(context, '$totalWins', AppLocalizations.of(context)!.winsLong, color: Colors.green),
                _buildStatColumn(
                  context,
                  '${overallWinRate.toStringAsFixed(1)}%',
                  AppLocalizations.of(context)!.winRate,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '$uniqueGamesCount ${AppLocalizations.of(context)!.gamesPlayed}',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$totalLosses ${AppLocalizations.of(context)!.lossesLong} • $totalTies ${AppLocalizations.of(context)!.tiesLong}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildGameExpansionTile(BuildContext context, GameStats stats) {
    final theme = Theme.of(context);
    final gameColor = stats.game.colorValue != null
      ? Color(stats.game.colorValue!)
      : theme.colorScheme.primary;

    return StylizedCard(
      shadowColor: gameColor,
      child: ExpansionTile(
        title: Text(
          stats.game.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${stats.sessionsPlayed} ${AppLocalizations.of(context)!.sessions} • ${stats.wins}${AppLocalizations.of(context)!.winsShort} - ${stats.losses}${AppLocalizations.of(context)!.lossesShort} - ${stats.ties}${AppLocalizations.of(context)!.tiesShort}',
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _getWinRateColor(stats.winRate).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${stats.winRate.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _getWinRateColor(stats.winRate),
            ),
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          const Divider(),
          const SizedBox(height: 8),

          // Chips Section
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildMetricChip(context, '${stats.wins} ${AppLocalizations.of(context)!.winsLong}', Colors.green),
              const SizedBox(width: 8),
              _buildMetricChip(context, '${stats.losses} ${AppLocalizations.of(context)!.lossesLong}', Colors.redAccent),
              const SizedBox(width: 8),
              _buildMetricChip(context, '${stats.ties} ${AppLocalizations.of(context)!.tiesLong}', Colors.grey),
            ],
          ),
          const SizedBox(height: 16),

          // Detailed 2x2 Performance Grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildGridCell(
                        context,
                        stats.game.highestScoreWins ? AppLocalizations.of(context)!.highestWins : AppLocalizations.of(context)!.lowestWins,
                        '${stats.highScore} ${AppLocalizations.of(context)!.points}',
                      ),
                    ),
                    Expanded(
                      child: _buildGridCell(
                        context,
                        AppLocalizations.of(context)!.averageScore,
                        '${stats.averageScore.toStringAsFixed(1)} ${AppLocalizations.of(context)!.points}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildGridCell(
                        context,
                        AppLocalizations.of(context)!.winRate,
                        '${stats.winRate.toStringAsFixed(1)}%',
                      ),
                    ),
                    Expanded(
                      child: _buildGridCell(
                        context,
                        AppLocalizations.of(context)!.totalPointsScored,
                        '${stats.totalPoints} ${AppLocalizations.of(context)!.points}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildGridCell(BuildContext context, String title, String value) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getWinRateColor(double winRate) {
    if (winRate >= 50.0) return Colors.green;
    if (winRate >= 25.0) return Colors.orange;
    return Colors.red;
  }

  Widget _buildMatchHistoryList(
    BuildContext context,
    List<PlayerMatchHistory> history,
  ) {
    final theme = Theme.of(context);

    if (history.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noMatchHistoryAvailable));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: history.length,
      separatorBuilder: (_, _) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final item = history[index];
        final gameColor = item.game.colorValue != null
            ? Color(item.game.colorValue!)
            : theme.colorScheme.primary;

        final formattedDate = item.session.dateTime != null
            ? '${item.session.dateTime!.day}/${item.session.dateTime!.month}/${item.session.dateTime!.year}'
            : AppLocalizations.of(context)!.notAvailable;

        final (statusLabel, statusColor) = switch (item.result) {
          MatchResult.win => (AppLocalizations.of(context)!.won, Colors.green),
          MatchResult.loss => (AppLocalizations.of(context)!.lost, Colors.redAccent),
          MatchResult.tie => (AppLocalizations.of(context)!.tied, Colors.grey),
        };

        return StylizedCard(
          shadowColor: gameColor,
          child: ListTile(
            title: Text(
              item.game.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              spacing: 6.0,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.playerSession.totalScore} ${AppLocalizations.of(context)!.points}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${item.session.players.length} ${AppLocalizations.of(context)!.players}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
