import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/board_game.dart';

class WhoPlaysFirst extends StatefulWidget {
  final BoardGame game;
  final List<PlayerSession> players;
  final ValueChanged<int> onLetsPlay;

  const WhoPlaysFirst({
    super.key,
    required this.game,
    required this.players,
    required this.onLetsPlay,
  });

  @override
  State<WhoPlaysFirst> createState() => _WhoPlaysFirstState();
}

class _WhoPlaysFirstState extends State<WhoPlaysFirst> {
  int _currentIndex = 0;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    // Start the spinning animation as soon as the dialog pops up
    _startSpinning();
  }

  Future<void> _startSpinning() async {
    final random = Random();

    // 1. Pick the winner in advance
    final winningIndex = random.nextInt(widget.players.length);

    // 2. Decide how many total name-swaps to perform before stopping (e.g., 25 to 30 times)
    final totalSteps = 25 + random.nextInt(6);

    // 3. Loop through the steps, increasing the delay between each frame
    for (int step = 0; step < totalSteps; step++) {
      // Quadratic growth formula: starts fast (~40ms delay), ends slow (~400ms delay)
      int delayMilliseconds = 40 + (step * step * 0.5).round();

      await Future.delayed(Duration(milliseconds: delayMilliseconds));

      // Guard against the user closing the dialog mid-animation
      if (!mounted) return;

      setState(() {
        if (step == totalSteps - 1) {
          // Final step: Lock on the predetermined winner
          _currentIndex = winningIndex;
          _isFinished = true;
        } else {
          // Intermediate steps: Cycle through list index using modulo (%)
          _currentIndex = (_currentIndex + 1) % widget.players.length;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentPlayer = widget.players[_currentIndex];
    final playerName = currentPlayer.playerName ?? l10n.genericPlayerName;
    final Color playerColor = currentPlayer.getColor(widget.game);

    return Column(
      mainAxisSize: MainAxisSize.min, // Takes only necessary vertical space
      children: [
        // Name display card
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity, // Allows the card to expand horizontally
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: _isFinished
                ? Colors.transparent
                : Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 1.5,
              color: _isFinished
                ? playerColor
                : Colors.transparent
            )
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              playerName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _isFinished
                    ? playerColor
                    : Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Confirm Button (Only visible after the animation completes)
        ElevatedButton(
          onPressed: _isFinished ? 
            () => widget.onLetsPlay(_currentIndex)
            : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50), 
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(l10n.letsPlay),
        ),
      ],
    );
  }
}