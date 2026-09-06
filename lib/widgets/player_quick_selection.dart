import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';
import '../main.dart';
import '../l10n/app_localizations.dart';
import '../models/player.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/stylized_card.dart';

class PlayerQuickSelection extends StatefulWidget {
  final ValueChanged<Player> onSelect;
  final VoidCallback onCLose;
  final List<int> unavailablePlayerIds;

  const PlayerQuickSelection({
    super.key,
    required this.onSelect,
    required this.onCLose,
    required this.unavailablePlayerIds,
  });

  @override
  State<PlayerQuickSelection> createState() => _PlayerQuickSelectionState();
}

class _PlayerQuickSelectionState extends State<PlayerQuickSelection> {
  List<Player> _players = [];

  @override
  void initState() {
    super.initState();
    _readPlayersFromDatabase();
  }

  void _readPlayersFromDatabase() async {
    final allPlayers = await isar.players.where().findAll();
    setState(() {
      _players = allPlayers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final availablePlayers = _players
      .where((player) => !widget.unavailablePlayerIds.contains(player.id))
      .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

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
          Expanded(
            child: availablePlayers.isEmpty
              ? EmptyStateCard(child: Text(AppLocalizations.of(context)!.noAvailablePlayers))
              : ListView.builder(
                  itemCount: availablePlayers.length,
                  itemBuilder: (context, index) {
                    final Player player = availablePlayers[index];

                    return StylizedCard(
                      shadowColor: Color(player.colorValue),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(player.name),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              widget.onSelect(player);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ),
          OverflowBar(
            alignment: MainAxisAlignment.end,
            spacing: 8.0,
            overflowSpacing: 8.0,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () async {
                  widget.onCLose();
                },
                child: Text(AppLocalizations.of(context)!.close),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
