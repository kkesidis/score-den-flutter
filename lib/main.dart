import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'models/board_game.dart';
import 'theme/app_theme.dart';
import 'models/settings.dart';
import 'l10n/app_localizations.dart';
import 'screens/game_list_screen.dart';
import 'models/player.dart';

final ValueNotifier<String> appLanguageNotifier = ValueNotifier('en');
final ValueNotifier<bool> darkThemeNotifier = ValueNotifier(false);
late Isar isar;

void main() async {
  // 1. Ensure Flutter services are completely initialized before asynchronous operations
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Get the standard document directory for your OS (Linux, Android, iOS, etc.)
  final dir = await getApplicationDocumentsDirectory();

  // 3. Open the database instance with our specific BoardGame collection schema
  isar = await Isar.open([BoardGameSchema, AppSettingsSchema, PlayerSchema], directory: dir.path);

  final savedSettings = await isar.appSettings.where().findFirst();

  if (savedSettings != null) {
    appLanguageNotifier.value = savedSettings.languageCode;
    darkThemeNotifier.value = savedSettings.isDarkMode;
  }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Only enables in debug/profile mode, not production!
      builder: (context) => const ScoreDenApp(), 
    ),
  );
}

class ScoreDenApp extends StatelessWidget {
  const ScoreDenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([appLanguageNotifier, darkThemeNotifier]),
      builder: (context, child) {
        return MaterialApp(
          title: 'ScoreDen',
          debugShowCheckedModeBanner: false,
          home: const GameListScreen(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(appLanguageNotifier.value),
          themeMode: darkThemeNotifier.value ? ThemeMode.dark : ThemeMode.light,
          theme: buildThemeData(AppTheme.lightThemeColors, ThemeType.light),
          darkTheme: buildThemeData(AppTheme.darkThemeColors, ThemeType.dark),
        );
      }
    );
  }
}

Future<void> changeLanguage(String newLanguageCode) async {
  appLanguageNotifier.value = newLanguageCode;

  await isar.writeTxn(() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    
    final settings = existingSettings ?? AppSettings();
    settings.languageCode = newLanguageCode;
    
    await isar.appSettings.put(settings); 
  });
}

Future<void> changeTheme(bool isDark) async {
  darkThemeNotifier.value = isDark;

  await isar.writeTxn(() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    
    final settings = existingSettings ?? AppSettings();
    settings.isDarkMode = isDark;
    
    await isar.appSettings.put(settings); 
  });
}
