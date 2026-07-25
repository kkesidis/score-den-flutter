import 'package:flutter/material.dart';
import '../models/board_game.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import './color_picker_field.dart';

class PlayerSessionForm extends StatefulWidget {
  final BoardGame game;
  final PlayerSession? existingPlayer;
  final ValueChanged<PlayerSession> onSubmit;

  const PlayerSessionForm({
    super.key,
    required this.game,
    this.existingPlayer,
    required this.onSubmit,
  });

  @override
  State<PlayerSessionForm> createState() => _PlayerSessionFormState();
}

class _PlayerSessionFormState extends State<PlayerSessionForm> {
  final nameController = TextEditingController();
  late bool isEditing;
  bool highestWins = true;
  Color currentColor = AppTheme.palette.first;

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  void _initForm() {
    isEditing = widget.existingPlayer != null;

    if (isEditing) {
      nameController.text = widget.existingPlayer!.playerName ?? AppLocalizations.of(context)!.genericPlayerName;

      final inheritedColor = widget.existingPlayer!.playerColorValue ?? widget.game.colorValue;
      currentColor = inheritedColor != null ? Color(inheritedColor) : currentColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        top: 24.0,
        left: 16.0,
        right: 16.0,
        bottom:
          MediaQuery.of(context).viewInsets.bottom +
          24.0, // Keyboard safety
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEditing ? l10n.renamePlayer : l10n.addPlayer,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.playerNameLabel,
              hintText: l10n.playerNameHint,
              border: const OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 10),

          ColorPickerField(
            initialColor: currentColor,
            onColorSelected: (newColor) {
              currentColor = newColor; 
            },
          ),

          const SizedBox(height: 24),

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
                  final textInput = nameController.text.trim();

                  if (textInput.isEmpty) return;

                  final playerToSave = isEditing
                    ? widget.existingPlayer!
                    : PlayerSession();

                  playerToSave.playerName = textInput;
                  playerToSave.playerColorValue = currentColor.toARGB32();

                  widget.onSubmit(playerToSave);
                },
                child: Text(isEditing ? l10n.save : l10n.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}