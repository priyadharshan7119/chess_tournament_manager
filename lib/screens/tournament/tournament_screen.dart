import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chess_tournament_manager/models/tournament.dart';
import 'package:chess_tournament_manager/providers/tournament_provider.dart';
import 'package:chess_tournament_manager/screens/match/match_screen.dart';
import 'package:chess_tournament_manager/screens/ranking/ranking_screen.dart';
import 'package:chess_tournament_manager/screens/tournament/tournament_players_screen.dart';

class TournamentScreen extends ConsumerWidget {
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournaments = ref.watch(tournamentProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text("Tournaments"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text("Tournament"),
      ),

      body: tournaments.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.emoji_events_outlined,
              size: 80,
              color: Colors.grey,
            ),

            SizedBox(height: 20),

            Text(
              "No Tournament Found",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Create your first tournament",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tournaments.length,
        itemBuilder: (context, index) {
          final tournament = tournaments[index];

          return Card(
            elevation: 5,
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [

                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.emoji_events,
                          color: Colors.deepPurple,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Text(
                          tournament.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [

                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(tournament.location),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(Icons.calendar_month),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(tournament.date),
                          ),
                        ],
                      ),

                      const Divider(height: 30),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [

                          FilledButton.icon(
                            icon: const Icon(Icons.people),
                            label: const Text("Players"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TournamentPlayersScreen(
                                        tournament: tournament,
                                      ),
                                ),
                              );
                            },
                          ),

                          FilledButton.icon(
                            icon: const Icon(Icons.casino),
                            label: const Text("Matches"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MatchScreen(
                                    tournament: tournament,
                                  ),
                                ),
                              );
                            },
                          ),

                          FilledButton.icon(
                            icon: const Icon(Icons.workspace_premium),
                            label: const Text("Ranking"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RankingScreen(
                                    tournament: tournament,
                                  ),
                                ),
                              );
                            },
                          ),

                          OutlinedButton.icon(
                            icon: const Icon(Icons.edit),
                            label: const Text("Edit"),
                            onPressed: () {
                              _showDialog(
                                context,
                                ref,
                                tournament: tournament,
                              );
                            },
                          ),

                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            icon: const Icon(Icons.delete),
                            label: const Text("Delete"),
                            onPressed: () async {
                              await ref
                                  .read(tournamentProvider.notifier)
                                  .deleteTournament(
                                  tournament.id!);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDialog(
      BuildContext context,
      WidgetRef ref, {
        Tournament? tournament,
      }) {
    final nameController =
    TextEditingController(text: tournament?.name ?? "");

    final locationController =
    TextEditingController(text: tournament?.location ?? "");

    final dateController =
    TextEditingController(text: tournament?.date ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          tournament == null
              ? "Add Tournament"
              : "Edit Tournament",
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Tournament Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Date",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          FilledButton(
            onPressed: () async {

              if (nameController.text.trim().isEmpty ||
                  locationController.text.trim().isEmpty ||
                  dateController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please fill all fields"),
                  ),
                );
                return;
              }

              final data = Tournament(
                id: tournament?.id,
                name: nameController.text.trim(),
                location: locationController.text.trim(),
                date: dateController.text.trim(),
              );

              if (tournament == null) {
                await ref
                    .read(tournamentProvider.notifier)
                    .addTournament(data);
              } else {
                await ref
                    .read(tournamentProvider.notifier)
                    .updateTournament(data);
              }

              Navigator.pop(context);
            },
            child: Text(
              tournament == null ? "Save" : "Update",
            ),
          ),
        ],
      ),
    );
  }
}