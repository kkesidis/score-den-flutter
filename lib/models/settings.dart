import 'package:isar_community/isar.dart';

// This tells Isar to generate code for this collection
part 'settings.g.dart';

@collection
class AppSettings {
  Id id = Isar.autoIncrement; // Isar needs an ID field

  // Store the language code here (e.g., "en" or "el")
  String languageCode = 'en'; 

  // Store the dark mode toggle
  bool isDarkMode = false;
}