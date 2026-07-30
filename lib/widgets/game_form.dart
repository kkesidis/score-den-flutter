import 'package:flutter/material.dart';
import '../models/board_game.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import './color_picker_field.dart';

class GameForm extends StatefulWidget {
  final BoardGame? existingGame;
  final ValueChanged<BoardGame> onSubmit;

  const GameForm({
    super.key,
    this.existingGame,
    required this.onSubmit,
  });

  @override
  State<GameForm> createState() => _GameFormState();
}

class _GameFormState extends State<GameForm> {
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
    isEditing = widget.existingGame != null;

    if (isEditing) {
      nameController.text = widget.existingGame!.name;
      highestWins = widget.existingGame!.highestScoreWins;
      currentColor = widget.existingGame!.colorValue != null ? Color(widget.existingGame!.colorValue!) : currentColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing ? l10n!.editGame : l10n!.newGame,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            autofocus: true,
            controller: nameController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.gameNameLabel,
              hintText: l10n.gameNameHint,
            ),
          ),

          const SizedBox(height: 10),

          ColorPickerField(
            initialColor: currentColor,
            onColorSelected: (newColor) {
              currentColor = newColor; 
            },
          ),

          const SizedBox(height: 15),

          InputDecorator(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.whoWins, // The decorator handles the label alignment perfectly
              border: const OutlineInputBorder(),   // Draws the exact same border box as your text field
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0), // Adds a tiny gap below the label line
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          highestWins = true;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: highestWins
                            ? Theme.of(context).colorScheme.primaryFixed
                            : Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              size: 14,
                              color: highestWins
                                ? Theme.of(context).colorScheme.onPrimaryFixed
                                : Theme.of(context).colorScheme.onSecondaryContainer
                            ),
                            const SizedBox(width: 6),
                            Text(
                              l10n.highestWins,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: highestWins
                                  ? Theme.of(context).colorScheme.onPrimaryFixed
                                  : Theme.of(context).colorScheme.onSecondaryContainer
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          highestWins = false;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: !highestWins
                            ? Theme.of(context).colorScheme.secondaryFixed
                            : Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_down_rounded,
                              size: 14,
                              color: !highestWins
                                ? Theme.of(context).colorScheme.onSecondaryFixed
                                : Theme.of(context).colorScheme.onSecondaryContainer
                            ),
                            const SizedBox(width: 6),
                            Text(
                              l10n.lowestWins,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: !highestWins
                                  ? Theme.of(context).colorScheme.onSecondaryFixed
                                  : Theme.of(context).colorScheme.onSecondaryContainer
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                  if (nameController.text.trim().isEmpty) return;

                  final gameToSave = isEditing
                      ? widget.existingGame!
                      : BoardGame();

                  gameToSave.name = nameController.text.trim();
                  gameToSave.highestScoreWins = highestWins;
                  gameToSave.colorValue = currentColor.toARGB32();

                  widget.onSubmit(gameToSave);
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