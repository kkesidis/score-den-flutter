// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageName => 'English';

  @override
  String get boardGame => 'Board Game';

  @override
  String get deleteBoardGameTitle => 'Delete Board Game';

  @override
  String deleteBoardGameDescription(Object name) {
    return 'Are you sure you want to delete \"$name\"? This will permanently remove all associated sessions.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get subtract => 'Subtract';

  @override
  String get delete => 'Delete';

  @override
  String get remove => 'Remove';

  @override
  String get gameDeleted => 'Game deleted successfully';

  @override
  String get newGame => 'New Game';

  @override
  String get editGame => 'Edit Game';

  @override
  String get deleteGame => 'Delete Game';

  @override
  String get gameNameLabel => 'Game name';

  @override
  String get gameNameHint => 'e.g. Ticket to Ride';

  @override
  String get gameDescriptionLabel => 'Description';

  @override
  String get gameDescriptionHint => 'Short description of the game..';

  @override
  String get highestWins => 'Highest score';

  @override
  String get highestScoretWins => 'Highest score wins';

  @override
  String get lowestWins => 'Lowest score';

  @override
  String get lowestScoretWins => 'Lowest score wins';

  @override
  String gamesTracked(Object number) {
    return '$number games tracked';
  }

  @override
  String get noGamesYet => 'No games added yet. Tap + to begin!';

  @override
  String get sessions => 'sessions';

  @override
  String get sessionsTitle => 'Sessions';

  @override
  String indexedSession(Object number) {
    return 'Session #$number';
  }

  @override
  String get renameSession => 'Rename Session';

  @override
  String get deleteSession => 'Delete Session';

  @override
  String get newSession => 'New Session';

  @override
  String get sessionNameLabel => 'Session Name';

  @override
  String sessionNameHint(Object number) {
    return 'Defaults to \"Session #$number\"';
  }

  @override
  String get deleteSessionTitle => 'Delete session';

  @override
  String deleteSessionDescription(Object name) {
    return 'Are you sure you want to delete \"$name\"? This will erase all player scores for this session.';
  }

  @override
  String get sessionRemoved => 'Session removed';

  @override
  String get noSessionsYet => 'No sessions recorded for this game.';

  @override
  String get noWinnerYet => 'No winner yet';

  @override
  String get players => 'players';

  @override
  String get renamePlayer => 'Rename Player';

  @override
  String get addPlayer => 'Add Player';

  @override
  String editScore(Object name) {
    return 'Edito score for $name';
  }

  @override
  String get scoreChange => 'Score change';

  @override
  String get genericPlayerName => 'Player';

  @override
  String get removePlayerTitle => 'Remove Player';

  @override
  String removePlayerDescription(Object name) {
    return 'Are you sure you want to remove \"$name\"? This will permanently delete all their logged scores for this session.';
  }

  @override
  String get playerRemoved => 'Player removed from session';

  @override
  String get quickSelect => 'Quick Select';

  @override
  String get logScore => 'Log Score';

  @override
  String scoreHistory(Object name) {
    return '$name score history';
  }

  @override
  String get noScoresYet => 'No scores logged for this session yet';

  @override
  String get points => 'pts';

  @override
  String get addPlayersBeforeRematch =>
      'Add at least one player before starting a session!';

  @override
  String startedRematch(Object number) {
    return 'Started Session $number with existing players!';
  }

  @override
  String get sessionScores => 'Session Scores';

  @override
  String get rematch => 'Rematch (same players)';

  @override
  String get noPlayersAddedYet =>
      'No players added yet. Tap + to add participants!';

  @override
  String get editPlayer => 'Edit Player';

  @override
  String get viewScoreHistory => 'View Score History';

  @override
  String get removePlayer => 'Remove Player';

  @override
  String get playerNameLabel => 'Player Name';

  @override
  String get playerNameHint => 'e.g. Alice';

  @override
  String get pointsLabel => 'Points';

  @override
  String get pointsHint => 'e.g. 5';

  @override
  String get pointDescriptionLabel => 'Note / Description (optional)';

  @override
  String get pointDescriptionHint => 'e.g. Round 1, Pentalty';

  @override
  String get boardGames => 'Board Games';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get notAvailable => '-';

  @override
  String get couldNotFindGame => '';

  @override
  String get chooseColor => 'Choose color';

  @override
  String get sessionOptions => 'Session options';

  @override
  String get whoWins => 'Who wins?';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get boardGameScoreTracker => 'Board Game Score Tracker';

  @override
  String get deletePlayerTitle => 'Delete Player';

  @override
  String deletePlayerDescription(Object name) {
    return 'Are you sure you want to delete \"$name\"? This will permanently remove all associated session entries.';
  }

  @override
  String get playerDeleted => 'Player deleted successfully';

  @override
  String get playersScreen => 'Players';

  @override
  String get noPlayersYet => 'No players added yet. Tap + to begin!';

  @override
  String playersTracked(Object number) {
    return '$number players';
  }

  @override
  String get guestTab => 'Guest';

  @override
  String get playersTab => 'Players';

  @override
  String get noAvailablePlayers => 'There aren\'t any available players';

  @override
  String get playerInformation => 'Player information';

  @override
  String get noPlayedSessions => 'No played sessions found for this player';

  @override
  String get gamesBreakdown => 'Games Breakdown';

  @override
  String get matchHistory => 'Match History';

  @override
  String get gamesPlayed => 'games played';

  @override
  String get sessionsPlayed => 'Sessions';

  @override
  String get winRate => 'Win rate';

  @override
  String get winsLong => 'Wins';

  @override
  String get winsShort => 'W';

  @override
  String get lossesLong => 'Losses';

  @override
  String get lossesShort => 'L';

  @override
  String get tiesLong => 'Ties';

  @override
  String get tiesShort => 'T';

  @override
  String get won => 'Won';

  @override
  String get lost => 'Lost';

  @override
  String get tied => 'Tied';

  @override
  String get averageScore => 'Average Score';

  @override
  String get totalPointsScored => 'Total Points Scored';

  @override
  String get noMatchHistoryAvailable => 'No match history available.';

  @override
  String get whoPlaysFirst => 'Who plays first?';

  @override
  String get letsPlay => 'Let\'s play!';
}
