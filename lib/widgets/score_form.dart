import 'package:flutter/material.dart';
import '../models/board_game.dart';
import '../l10n/app_localizations.dart';

enum ScoreOp { add, subtract }

class ScoreForm extends StatefulWidget {
  final BoardGame game;
  final PlayerSession player;
  final ScoreEntry? score;
  final ScoreOp? initialScoreOp;
  final ValueChanged<ScoreEntry> onSubmit;

  const ScoreForm({
    super.key,
    required this.game,
    required this.player,
    this.score,
    this.initialScoreOp,
    required this.onSubmit,
  });

  @override
  State<ScoreForm> createState() => _ScoreFormState();
}

class _ScoreFormState extends State<ScoreForm> {
  final scoreController = TextEditingController();
  final descController = TextEditingController();
  ScoreOp currentOp = ScoreOp.add;
  late bool isEditing;
  int currentScore = 0;

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  void _initForm() {
    if (widget.initialScoreOp != null) {
      currentOp = widget.initialScoreOp!;  
    }
    
    isEditing = widget.score != null;
    currentScore = widget.player.scores.fold<int>(0, (sum, score) => sum + (score.value ?? 0));

    if (isEditing) {
      final entryValue = widget.score!.value ?? 0;
      scoreController.text = entryValue.toString();
      descController.text = widget.score!.description ?? '';

      currentOp = entryValue < 0 ? ScoreOp.subtract : ScoreOp.add;
    }
  }

  Widget _buildEqualWidthChip(
    int value,
    ScoreOp currentOp,
    TextEditingController scoreController,
    StateSetter setModalState,
  ) {
    final String prefix = currentOp == ScoreOp.add ? '+' : '-';
    final isAdd = currentOp == ScoreOp.add;

    return ActionChip(
      // Enforces centered alignment inside the expanded boundaries
      label: Center(
        child: Text(
          '$prefix$value',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            // Switches typography colors depending on the operational math state
            color: isAdd 
                ? Theme.of(context).colorScheme.onSecondary 
                : Theme.of(context).colorScheme.onError,
          ),
        ),
      ),
      // Solid structural background injection based on the operation type
      backgroundColor: isAdd 
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.error,
      // We completely strip the border side tinting line since we are using solid fills
      side: BorderSide.none, 
      onPressed: () {
        setModalState(() {
          scoreController.text = value.toString();
          scoreController.selection = TextSelection.fromPosition(
            TextPosition(offset: scoreController.text.length),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Re-render header calculations dynamically as text is typed
    scoreController.addListener(() {
      if (context.mounted) setState(() {});
    });

    final rawValue = int.tryParse(scoreController.text.trim()) ?? 0;
    final parsedValue = rawValue.abs();

    final finalValueModifier = currentOp == ScoreOp.add
      ? parsedValue
      : -parsedValue;
    final newScore = currentScore + finalValueModifier;

    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 24.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. TITLE & CALCULATION HEADER
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing
                  ? l10n.editScore(widget.player.playerName ?? l10n.genericPlayerName)
                  : (widget.player.playerName ?? l10n.genericPlayerName),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${l10n.scoreChange}: $currentScore → $newScore',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.54),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 2. THE OPERATION CONTROLLER (ADD / SUBTRACT)
          SegmentedButton<ScoreOp>(
            segments: <ButtonSegment<ScoreOp>>[
              ButtonSegment<ScoreOp>(
                value: ScoreOp.add,
                label: Text(l10n.add),
                icon: const Icon(Icons.add),
              ),
              ButtonSegment<ScoreOp>(
                value: ScoreOp.subtract,
                label: Text(l10n.subtract),
                icon: const Icon(Icons.remove),
              ),
            ],
            selected: <ScoreOp>{currentOp},
            onSelectionChanged: (Set<ScoreOp> newSelection) {
              setState(() {
                currentOp = newSelection.first;
              });
            },
          ),

          const SizedBox(height: 20),

          // 3. MAIN INPUT FIELD
          TextField(
            controller: scoreController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.pointsLabel,
              hintText: l10n.pointsHint,
              prefixIcon: Icon(
                currentOp == ScoreOp.add ? Icons.add : Icons.remove,
                color: currentOp == ScoreOp.add
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.error,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          TextField(
            controller: descController,
            decoration: InputDecoration(
              labelText: l10n.pointDescriptionLabel,
              hintText: l10n.pointDescriptionHint,
              prefixIcon: const Icon(Icons.notes_outlined),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),

          // 4. QUICK SELECT CHIPS
          Text(
            l10n.quickSelect,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [5, 10, 15, 20].map((int value) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: _buildEqualWidthChip(
                    value,
                    currentOp,
                    scoreController,
                    setState,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // 5. ACTION BUTTON CONTROLS FOOTER
          OverflowBar(
            alignment: MainAxisAlignment.end,
            spacing: 8.0,
            overflowSpacing: 8.0,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () async {
                  final score = scoreController.text.trim();

                  if (score.isEmpty) return;

                  final scoreToSave = ScoreEntry()
                    ..value = finalValueModifier
                    ..description = descController.text.isEmpty ? null : descController.text.trim();

                  widget.onSubmit(scoreToSave);
                },
                child: Text(isEditing ? l10n.save : l10n.logScore),
              ),
            ],
          ),
        ],
      ),
    );
  }
}