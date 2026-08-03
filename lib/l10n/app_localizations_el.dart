// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get languageName => 'Ελληνικά';

  @override
  String get boardGame => 'Επιτραπέζιο παιχνίδι';

  @override
  String get deleteBoardGameTitle => 'Διαγραφή επιτραπέζιου παιχνιδιού';

  @override
  String deleteBoardGameDescription(Object name) {
    return 'Είστε σίγουροι ότι θέλετε να διαγράψετε το παιχνίδι \"$name\"; Αυτή η ενέργεια θα διαγράψει οριστικά όλες τις σχετικές παρτίδες.';
  }

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get close => 'Κλείσιμο';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get add => 'Προσθήκη';

  @override
  String get subtract => 'Αφαίρεση';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get remove => 'Κατάργηση';

  @override
  String get gameDeleted => 'Το παιχνίδι διαγράφηκε επιτυχώς';

  @override
  String get newGame => 'Νέο παιχνίδι';

  @override
  String get editGame => 'Επεξεργασία παιχνιδιού';

  @override
  String get deleteGame => 'Διαγραφή παιχνιδιού';

  @override
  String get gameNameLabel => 'Όνομα παιχνιδιού';

  @override
  String get gameNameHint => 'π.χ. Ticket to Ride';

  @override
  String get gameDescriptionLabel => 'Περιγραφή';

  @override
  String get gameDescriptionHint => 'Σύντομη περιγραφή του παιχνιδιού...';

  @override
  String get highestWins => 'Υψηλότερο σκορ';

  @override
  String get highestScoretWins => 'Νικητής με το υψηλότερο σκορ';

  @override
  String get lowestWins => 'Χαμηλότερο σκορ';

  @override
  String get lowestScoretWins => 'Νικητής με το χαμηλότερο σκορ';

  @override
  String gamesTracked(Object number) {
    return 'Καταγράφηκαν $number παιχνίδια';
  }

  @override
  String get noGamesYet =>
      'Δεν έχουν προστεθεί παιχνίδια ακόμα. Πατήστε το + για να ξεκινήσετε!';

  @override
  String get sessions => 'παρτίδες';

  @override
  String get sessionsTitle => 'Παρτίδες';

  @override
  String indexedSession(Object number) {
    return 'Παρτίδα #$number';
  }

  @override
  String get renameSession => 'Μετονομασία παρτίδας';

  @override
  String get deleteSession => 'Διαγραφή παρτίδας';

  @override
  String get newSession => 'Νέα παρτίδα';

  @override
  String get sessionNameLabel => 'Όνομα παρτίδας';

  @override
  String sessionNameHint(Object number) {
    return 'Προεπιλογή: \"Παρτίδα #$number\"';
  }

  @override
  String get deleteSessionTitle => 'Διαγραφή παρτίδας';

  @override
  String deleteSessionDescription(Object name) {
    return 'Είστε σίγουροι ότι θέλετε να διαγράψετε την παρτίδα \"$name\"; Αυτή η ενέργεια θα διαγράψει όλα τα σκορ των παικτών για αυτή την παρτίδα.';
  }

  @override
  String get sessionRemoved => 'Η παρτίδα αφαιρέθηκε';

  @override
  String get noSessionsYet =>
      'Δεν έχουν καταγραφεί παρτίδες για αυτό το παιχνίδι.';

  @override
  String get noWinnerYet => 'Δεν υπάρχει νικητής ακόμα';

  @override
  String get players => 'παίκτες';

  @override
  String get renamePlayer => 'Μετονομασία παίκτη';

  @override
  String get addPlayer => 'Προσθήκη παίκτη';

  @override
  String editScore(Object name) {
    return 'Επεξεργασία σκορ για $name';
  }

  @override
  String get scoreChange => 'Αλλαγή σκορ';

  @override
  String get genericPlayerName => 'Παίκτης';

  @override
  String get removePlayerTitle => 'Κατάργηση παίκτη';

  @override
  String removePlayerDescription(Object name) {
    return 'Είστε σίγουροι ότι θέλετε να καταργήσετε τον παίκτη \"$name\"; Αυτή η ενέργεια θα διαγράψει οριστικά όλα τα καταγεγραμμένα σκορ του για αυτή την παρτίδα.';
  }

  @override
  String get playerRemoved => 'Ο παίκτης αφαιρέθηκε από την παρτίδα';

  @override
  String get quickSelect => 'Γρήγορη επιλογή';

  @override
  String get logScore => 'Καταγραφή σκορ';

  @override
  String scoreHistory(Object name) {
    return 'Ιστορικό σκορ για $name';
  }

  @override
  String get noScoresYet =>
      'Δεν έχουν καταγραφεί σκορ για αυτή την παρτίδα ακόμα';

  @override
  String get points => 'π.';

  @override
  String get addPlayersBeforeRematch =>
      'Προσθέστε τουλάχιστον έναν παίκτη πριν ξεκινήσετε την παρτίδα!';

  @override
  String startedRematch(Object number) {
    return 'Ξεκίνησε η Παρτίδα $number με τους υπάρχοντες παίκτες!';
  }

  @override
  String get sessionScores => 'Σκορ παρτίδας';

  @override
  String get rematch => 'Ρεβάνς (με τους ίδιους παίκτες)';

  @override
  String get noPlayersAddedYet =>
      'Δεν έχουν προστεθεί παίκτες ακόμα. Πατήστε το + για να προσθέσετε συμμετέχοντες!';

  @override
  String get editPlayer => 'Επεξεργασία παίκτη';

  @override
  String get viewScoreHistory => 'Προβολή ιστορικού σκορ';

  @override
  String get removePlayer => 'Κατάργηση παίκτη';

  @override
  String get playerNameLabel => 'Όνομα παίκτη';

  @override
  String get playerNameHint => 'π.χ. Μαρία';

  @override
  String get pointsLabel => 'Πόντοι';

  @override
  String get pointsHint => 'π.χ. 5';

  @override
  String get pointDescriptionLabel => 'Σημείωση / Περιγραφή (προαιρετικό)';

  @override
  String get pointDescriptionHint => 'π.χ. Γύρος 1, Ποινή';

  @override
  String get boardGames => 'Επιτραπέζια Παιχνίδια';

  @override
  String get settings => 'Ρυθμίσεις';

  @override
  String get language => 'Γλώσσα';

  @override
  String get notAvailable => '-';

  @override
  String get couldNotFindGame => 'Δεν βρέθηκε το παιχνίδι';

  @override
  String get chooseColor => 'Επιλέξτε χρώμα';

  @override
  String get sessionOptions => 'Ρυθμίσεις παρτίδας';

  @override
  String get whoWins => 'Ποιός κερδίζει;';

  @override
  String get theme => 'Θέμα';

  @override
  String get light => 'Φωτεινό';

  @override
  String get dark => 'Σκοτεινό';

  @override
  String get boardGameScoreTracker => 'Μετρητής σκορ επιτραπέζιων παιχνιδιών';

  @override
  String get deletePlayerTitle => 'Διαγραφή Παίχτη';

  @override
  String deletePlayerDescription(Object name) {
    return 'Είστε σίγουροι ότι θέλετε να καταργήσετε τον παίκτη \"$name\"? Αυτή η ενέργεια θα διαγράψει οριστικά όλες τις καταγεγραμμένες εγγραφές του.';
  }

  @override
  String get playerDeleted => 'Ο παίκτης διαγράφηκε επιτυχώς';

  @override
  String get playersScreen => 'Παίκτες';

  @override
  String get noPlayersYet =>
      'Δεν έχουν προστεθεί παίκτες ακόμα. Πατήστε το + για να ξεκινήσετε!';

  @override
  String playersTracked(Object number) {
    return '$number παίικτες';
  }

  @override
  String get guestTab => 'Επισκέπτης';

  @override
  String get playersTab => 'Παίκτες';

  @override
  String get noAvailablePlayers => 'Δεν υπάρχουν διαθέσιμοι παίκτες';

  @override
  String get playerInformation => 'Πληροφορίες παίκτη';

  @override
  String get noPlayedSessions => 'Δεν βρέθηκαν παρτίδες για αυτόν τον παίκτη';

  @override
  String get gamesBreakdown => 'Ανάλυση Παιχνιδιών';

  @override
  String get matchHistory => 'Ιστορικό Παρτίδων';

  @override
  String get gamesPlayed => 'παιχνίδια';

  @override
  String get sessionsPlayed => 'Συνεδρίες';

  @override
  String get winRate => 'Ποσοστό νικών';

  @override
  String get winsLong => 'Νίκες';

  @override
  String get winsShort => 'Ν';

  @override
  String get lossesLong => 'Ήττες';

  @override
  String get lossesShort => 'Η';

  @override
  String get tiesLong => 'Ισοπαλίες';

  @override
  String get tiesShort => 'Ι';

  @override
  String get won => 'Νίκησε';

  @override
  String get lost => 'Έχασε';

  @override
  String get tied => 'Ισοφάρισε';

  @override
  String get averageScore => 'Μέσος όρος σκορ';

  @override
  String get totalPointsScored => 'Συνολικοί πόντοι';

  @override
  String get noMatchHistoryAvailable => 'Δεν υπάρχει ιστορικό παρτίδων.';
}
