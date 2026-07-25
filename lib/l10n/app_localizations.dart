import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_el.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('el'),
    Locale('en'),
  ];

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @boardGame.
  ///
  /// In en, this message translates to:
  /// **'Board Game'**
  String get boardGame;

  /// No description provided for @deleteBoardGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Board Game'**
  String get deleteBoardGameTitle;

  /// No description provided for @deleteBoardGameDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This will permanently remove all associated sessions.'**
  String deleteBoardGameDescription(Object name);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @subtract.
  ///
  /// In en, this message translates to:
  /// **'Subtract'**
  String get subtract;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @gameDeleted.
  ///
  /// In en, this message translates to:
  /// **'Game deleted successfully'**
  String get gameDeleted;

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get newGame;

  /// No description provided for @editGame.
  ///
  /// In en, this message translates to:
  /// **'Edit Game'**
  String get editGame;

  /// No description provided for @deleteGame.
  ///
  /// In en, this message translates to:
  /// **'Delete Game'**
  String get deleteGame;

  /// No description provided for @gameNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Game name'**
  String get gameNameLabel;

  /// No description provided for @gameNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ticket to Ride'**
  String get gameNameHint;

  /// No description provided for @gameDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get gameDescriptionLabel;

  /// No description provided for @gameDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Short description of the game..'**
  String get gameDescriptionHint;

  /// No description provided for @highestWins.
  ///
  /// In en, this message translates to:
  /// **'Highest score'**
  String get highestWins;

  /// No description provided for @highestScoretWins.
  ///
  /// In en, this message translates to:
  /// **'Highest score wins'**
  String get highestScoretWins;

  /// No description provided for @lowestWins.
  ///
  /// In en, this message translates to:
  /// **'Lowest score'**
  String get lowestWins;

  /// No description provided for @lowestScoretWins.
  ///
  /// In en, this message translates to:
  /// **'Lowest score wins'**
  String get lowestScoretWins;

  /// No description provided for @gamesTracked.
  ///
  /// In en, this message translates to:
  /// **'{number} games tracked'**
  String gamesTracked(Object number);

  /// No description provided for @noGamesYet.
  ///
  /// In en, this message translates to:
  /// **'No games added yet. Tap + to begin!'**
  String get noGamesYet;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'sessions'**
  String get sessions;

  /// No description provided for @sessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsTitle;

  /// No description provided for @indexedSession.
  ///
  /// In en, this message translates to:
  /// **'Session #{number}'**
  String indexedSession(Object number);

  /// No description provided for @renameSession.
  ///
  /// In en, this message translates to:
  /// **'Rename Session'**
  String get renameSession;

  /// No description provided for @deleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete Session'**
  String get deleteSession;

  /// No description provided for @newSession.
  ///
  /// In en, this message translates to:
  /// **'New Session'**
  String get newSession;

  /// No description provided for @sessionNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Session Name'**
  String get sessionNameLabel;

  /// No description provided for @sessionNameHint.
  ///
  /// In en, this message translates to:
  /// **'Defaults to \"Session #{number}\"'**
  String sessionNameHint(Object number);

  /// No description provided for @deleteSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete session'**
  String get deleteSessionTitle;

  /// No description provided for @deleteSessionDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This will erase all player scores for this session.'**
  String deleteSessionDescription(Object name);

  /// No description provided for @sessionRemoved.
  ///
  /// In en, this message translates to:
  /// **'Session removed'**
  String get sessionRemoved;

  /// No description provided for @noSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No sessions recorded for this game.'**
  String get noSessionsYet;

  /// No description provided for @noWinnerYet.
  ///
  /// In en, this message translates to:
  /// **'No winner yet'**
  String get noWinnerYet;

  /// No description provided for @players.
  ///
  /// In en, this message translates to:
  /// **'players'**
  String get players;

  /// No description provided for @renamePlayer.
  ///
  /// In en, this message translates to:
  /// **'Rename Player'**
  String get renamePlayer;

  /// No description provided for @addPlayer.
  ///
  /// In en, this message translates to:
  /// **'Add Player'**
  String get addPlayer;

  /// No description provided for @editScore.
  ///
  /// In en, this message translates to:
  /// **'Edito score for {name}'**
  String editScore(Object name);

  /// No description provided for @scoreChange.
  ///
  /// In en, this message translates to:
  /// **'Score change'**
  String get scoreChange;

  /// No description provided for @genericPlayerName.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get genericPlayerName;

  /// No description provided for @removePlayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Player'**
  String get removePlayerTitle;

  /// No description provided for @removePlayerDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove \"{name}\"? This will permanently delete all their logged scores for this session.'**
  String removePlayerDescription(Object name);

  /// No description provided for @playerRemoved.
  ///
  /// In en, this message translates to:
  /// **'Player removed from session'**
  String get playerRemoved;

  /// No description provided for @quickSelect.
  ///
  /// In en, this message translates to:
  /// **'Quick Select'**
  String get quickSelect;

  /// No description provided for @logScore.
  ///
  /// In en, this message translates to:
  /// **'Log Score'**
  String get logScore;

  /// No description provided for @scoreHistory.
  ///
  /// In en, this message translates to:
  /// **'{name} score history'**
  String scoreHistory(Object name);

  /// No description provided for @noScoresYet.
  ///
  /// In en, this message translates to:
  /// **'No scores logged for this session yet'**
  String get noScoresYet;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get points;

  /// No description provided for @addPlayersBeforeRematch.
  ///
  /// In en, this message translates to:
  /// **'Add at least one player before starting a session!'**
  String get addPlayersBeforeRematch;

  /// No description provided for @startedRematch.
  ///
  /// In en, this message translates to:
  /// **'Started Session {number} with existing players!'**
  String startedRematch(Object number);

  /// No description provided for @sessionScores.
  ///
  /// In en, this message translates to:
  /// **'Session Scores'**
  String get sessionScores;

  /// No description provided for @rematch.
  ///
  /// In en, this message translates to:
  /// **'Rematch (same players)'**
  String get rematch;

  /// No description provided for @noPlayersAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No players added yet. Tap + to add participants!'**
  String get noPlayersAddedYet;

  /// No description provided for @editPlayer.
  ///
  /// In en, this message translates to:
  /// **'Edit Player'**
  String get editPlayer;

  /// No description provided for @viewScoreHistory.
  ///
  /// In en, this message translates to:
  /// **'View Score History'**
  String get viewScoreHistory;

  /// No description provided for @removePlayer.
  ///
  /// In en, this message translates to:
  /// **'Remove Player'**
  String get removePlayer;

  /// No description provided for @rounds.
  ///
  /// In en, this message translates to:
  /// **'rounds'**
  String get rounds;

  /// No description provided for @playerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Player Name'**
  String get playerNameLabel;

  /// No description provided for @playerNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Alice'**
  String get playerNameHint;

  /// No description provided for @pointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get pointsLabel;

  /// No description provided for @pointsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5'**
  String get pointsHint;

  /// No description provided for @pointDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Note / Description (optional)'**
  String get pointDescriptionLabel;

  /// No description provided for @pointDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Round 1, Pentalty'**
  String get pointDescriptionHint;

  /// No description provided for @boardGames.
  ///
  /// In en, this message translates to:
  /// **'Board Games'**
  String get boardGames;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'-'**
  String get notAvailable;

  /// No description provided for @couldNotFindGame.
  ///
  /// In en, this message translates to:
  /// **''**
  String get couldNotFindGame;

  /// No description provided for @chooseColor.
  ///
  /// In en, this message translates to:
  /// **'Choose color'**
  String get chooseColor;

  /// No description provided for @sessionOptions.
  ///
  /// In en, this message translates to:
  /// **'Session options'**
  String get sessionOptions;

  /// No description provided for @whoWins.
  ///
  /// In en, this message translates to:
  /// **'Who wins?'**
  String get whoWins;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @boardGameScoreTracker.
  ///
  /// In en, this message translates to:
  /// **'Board Game Score Tracker'**
  String get boardGameScoreTracker;

  /// No description provided for @deletePlayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Player'**
  String get deletePlayerTitle;

  /// No description provided for @deletePlayerDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This will permanently remove all associated session entries.'**
  String deletePlayerDescription(Object name);

  /// No description provided for @playerDeleted.
  ///
  /// In en, this message translates to:
  /// **'Player deleted successfully'**
  String get playerDeleted;

  /// No description provided for @playersScreen.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get playersScreen;

  /// No description provided for @noPlayersYet.
  ///
  /// In en, this message translates to:
  /// **'No players added yet. Tap + to begin!'**
  String get noPlayersYet;

  /// No description provided for @playersTracked.
  ///
  /// In en, this message translates to:
  /// **'{number} players'**
  String playersTracked(Object number);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['el', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
