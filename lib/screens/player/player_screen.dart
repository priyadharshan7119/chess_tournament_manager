import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/player.dart';
import '../../providers/player_provider.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playerProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text("Players"),
        centerTitle: true,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showPlayerDialog(context, ref);
        },
        icon: const Icon(Icons.person_add),
        label: const Text("Add Player"),
      ),

      body: players.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              "No Players Found",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Tap the + button to add players",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [

                  Row(
                    children: [

                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          player.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Text(
                              player.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Chip(
                              avatar: const Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.orange,
                              ),
                              label: Text(
                                "Rating ${player.rating}",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 30),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.end,
                    children: [

                      FilledButton.icon(
                        onPressed: () {
                          _showPlayerDialog(
                            context,
                            ref,
                            player: player,
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit"),
                      ),

                      const SizedBox(width: 10),

                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          _deletePlayer(
                            context,
                            ref,
                            player.id!,
                          );
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Delete"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPlayerDialog(
      BuildContext context,
      WidgetRef ref, {
        Player? player,
      }) {
    final nameController =
    TextEditingController(text: player?.name ?? "");

    final ratingController =
    TextEditingController(
      text: player?.rating.toString() ?? "",
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          player == null
              ? "Add Player"
              : "Edit Player",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Player Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: ratingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Rating",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          FilledButton(
            onPressed: () async {
              final newPlayer = Player(
                id: player?.id,
                name: nameController.text.trim(),
                rating: int.parse(ratingController.text),
              );

              if (player == null) {
                await ref
                    .read(playerProvider.notifier)
                    .addPlayer(newPlayer);
              } else {
                await ref
                    .read(playerProvider.notifier)
                    .updatePlayer(newPlayer);
              }

              Navigator.pop(context);
            },
            child: Text(
              player == null ? "Save" : "Update",
            ),
          ),
        ],
      ),
    );
  }

  void _deletePlayer(
      BuildContext context,
      WidgetRef ref,
      int id,
      ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Delete Player"),
        content: const Text(
          "Are you sure you want to delete this player?",
        ),
        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),

          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              await ref
                  .read(playerProvider.notifier)
                  .deletePlayer(id);

              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}