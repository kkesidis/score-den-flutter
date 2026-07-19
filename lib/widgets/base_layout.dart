import 'package:flutter/material.dart';
import '../screens/language_screen.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';

class BaseLayout extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget child;
  final Widget? floatingActionButton;
  final List<Widget>? additionalActions;

  const BaseLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.floatingActionButton,
    this.additionalActions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2.0,
          children: [
            title,
            // ignore: use_null_aware_elements
            if (subtitle != null) subtitle!,
          ],
        ),
        actions: [
          ...?additionalActions,
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // This built-in command searches up the widget tree 
                // and opens our sidebar drawer
                Scaffold.of(context).openEndDrawer(); 
              },
            ),
          ),
        ],
      ),

      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.tertiaryContainer,
                    Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32.0), 
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ScoreDen',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Theme.of(context).colorScheme.onTertiaryContainer
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.boardGameScoreTracker,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onTertiaryContainer.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.casino),
              title: Text(AppLocalizations.of(context)!.boardGames),
              onTap: () {
                Navigator.pop(context);
                
                // Clear all screens on top until we hit the first/root screen (Home)
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(AppLocalizations.of(context)!.language),
              subtitle: Text(
                AppLocalizations.of(context)!.languageName,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5,),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageScreen(),
                  ),
                );
              },
            ),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.theme),
              subtitle: Text(
                darkThemeNotifier.value ? AppLocalizations.of(context)!.dark : AppLocalizations.of(context)!.light,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5,),
                ),
              ),
              secondary: Icon(darkThemeNotifier.value ? Icons.dark_mode : Icons.light_mode),
              value: darkThemeNotifier.value,
              onChanged: (bool newValue) async {
                await changeTheme(newValue);
              },
            ),
          ],
        ),
      ),

      floatingActionButton: floatingActionButton,

      body: child,
    );
  }
}
