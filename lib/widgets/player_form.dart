import 'package:flutter/material.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import './color_picker_field.dart';

class PlayerForm extends StatefulWidget {
  final Player? existingPlayer;
  final ValueChanged<Player> onSubmit;

  const PlayerForm({
    super.key,
    this.existingPlayer,
    required this.onSubmit,
  });

  @override
  State<PlayerForm> createState() => _PlayerFormState();
}

class _PlayerFormState extends State<PlayerForm> {
  final nameController = TextEditingController();
  late bool isEditing;
  Color currentColor = AppTheme.palette.first;

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  void _initForm() {
    isEditing = widget.existingPlayer != null;

    if (isEditing) {
      nameController.text = widget.existingPlayer!.name;
      currentColor = Color(widget.existingPlayer!.colorValue);
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
            isEditing ? l10n.editPlayer : l10n.addPlayer,
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

                  if (isEditing) {
                    final playerToEdit = widget.existingPlayer!;
                    playerToEdit.name = textInput;
                    playerToEdit.colorValue = currentColor.toARGB32();
                    widget.onSubmit(playerToEdit);
                    return;
                  }

                  final playerToAdd = Player(name: textInput, colorValue: currentColor.toARGB32());
                  widget.onSubmit(playerToAdd);
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