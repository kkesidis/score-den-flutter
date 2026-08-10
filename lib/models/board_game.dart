import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

part 'board_game.g.dart';

@collection
class BoardGame {
  Id id = Isar.autoIncrement;

  late String name;
  String? description;
  bool highestScoreWins = true;

  // Store the game's theme color as a number (e.g., 0xFF4CAF50)
  int? colorValue;

  List<MatchSession> sessions = [];
}

@embedded
class MatchSession {
  String? name;
  DateTime? dateTime;

  List<PlayerSession> players = [];
}

@embedded
class PlayerSession {
  String? playerName;

  // links to the Player.id of the PlayerSchema
  int? playerId; 

  // Store a specific player's color for this session
  int? playerColorValue;

  // Flag that determines the player that goes first
  bool? playsFirst;

  List<ScoreEntry> scores = [];

  int get totalScore {
    return scores.fold(0, (sum, entry) => sum + (entry.value ?? 0)); 
  }

  Color getColor(BoardGame game) {
    final inheritedColor = playerColorValue ?? game.colorValue;
    return inheritedColor != null 
      ? Color(inheritedColor) 
      : AppTheme.palette.first;
  }
}

@embedded
class ScoreEntry {
  int? value;
  String? description;
}
