import 'package:flutter/material.dart';
import '../models/board_game.dart';
import '../l10n/app_localizations.dart';

class SessionForm extends StatefulWidget {
  final BoardGame game;
  final MatchSession? existingSession;
  final ValueChanged<MatchSession> onAdd;
  final ValueChanged<MatchSession> onSave;

  const SessionForm({
    super.key,
    required this.game,
    this.existingSession,
    required this.onAdd,
    required this.onSave,
  });

  @override
  State<SessionForm> createState() => _SessionFormState();
}

class _SessionFormState extends State<SessionForm> {
  final nameController = TextEditingController();
  late bool isEditing;

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  void _initForm() {
    isEditing = widget.existingSession != null;

    if (isEditing) {
      nameController.text = widget.existingSession!.name ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nextIndex = widget.game.sessions.length + 1;

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom:
          MediaQuery.of(context).viewInsets.bottom +
          16.0, // Keyboard safety
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing ? l10n.renameSession : l10n.newSession,
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
              labelText: l10n.sessionNameLabel,
              hintText: isEditing
                ? null
                : l10n.sessionNameHint(nextIndex),
            ),
          ),

          const SizedBox(height: 24),

          OverflowBar(
            alignment: MainAxisAlignment.end,
            spacing:
                8.0, // Horizontal gap between buttons when side-by-side
            overflowSpacing:
                8.0, // Vertical gap between buttons if they drop/stack vertically!
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

                  if (isEditing) {
                    if (textInput.isEmpty) return;

                    final sessionToSave = widget.existingSession!;
                    sessionToSave.name = textInput;

                    return widget.onSave(sessionToSave);
                  }

                  final newSession = MatchSession()
                    ..name = textInput 
                    ..dateTime = DateTime.now();

                  widget.onAdd(newSession);
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