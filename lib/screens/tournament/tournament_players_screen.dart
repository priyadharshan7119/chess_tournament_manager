import 'package:flutter/material.dart';

import 'package:chess_tournament_manager/database/database_helper.dart';
import 'package:chess_tournament_manager/models/player.dart';
import 'package:chess_tournament_manager/models/tournament.dart';

class TournamentPlayersScreen extends StatefulWidget {
  final Tournament tournament;

  const TournamentPlayersScreen({
    super.key,
    required this.tournament,
  });

  @override
  State<TournamentPlayersScreen> createState() =>
      _TournamentPlayersScreenState();
}

class _TournamentPlayersScreenState
    extends State<TournamentPlayersScreen> {

  List<Player> players = [];
  List<int> selectedPlayers = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final db = await DatabaseHelper.instance.database;

    final playerResult = await db.query("players");

    final tournamentPlayerResult = await db.query(
      "tournament_players",
      where: "tournamentId=?",
      whereArgs: [widget.tournament.id],
    );

    players = playerResult
        .map((e) => Player.fromMap(e))
        .toList();

    selectedPlayers = tournamentPlayerResult
        .map((e) => e["playerId"] as int)
        .toList();

    setState(() {});
  }

  Future<void> togglePlayer(Player player) async {
    final db = await DatabaseHelper.instance.database;

    if (selectedPlayers.contains(player.id)) {

      await db.delete(
        "tournament_players",
        where: "tournamentId=? AND playerId=?",
        whereArgs: [
          widget.tournament.id,
          player.id,
        ],
      );

      selectedPlayers.remove(player.id);

    } else {

      await db.insert(
        "tournament_players",
        {
          "tournamentId": widget.tournament.id,
          "playerId": player.id,
        },
      );

      selectedPlayers.add(player.id!);

    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: Text(widget.tournament.name),
        centerTitle: true,
      ),

      body: players.isEmpty
          ? const Center(
        child: Text(
          "No Players Available",
          style: TextStyle(fontSize: 18),
        ),
      )
          : Column(
        children: [

          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius:
              BorderRadius.circular(18),
            ),
            child: Row(
              children: [

                const Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 35,
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Select Players",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "${selectedPlayers.length} Selected",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding:
              const EdgeInsets.symmetric(horizontal: 16),
              itemCount: players.length,
              itemBuilder: (context, index) {

                final player = players[index];

                final added = selectedPlayers
                    .contains(player.id);

                return Card(
                  elevation: 3,
                  margin:
                  const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.all(16),

                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor:
                      added
                          ? Colors.green
                          : Colors.deepPurple,
                      child: Text(
                        player.name[0]
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    title: Text(
                      player.name,
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    subtitle: Padding(
                      padding:
                      const EdgeInsets.only(top: 6),
                      child: Chip(
                        avatar: const Icon(
                          Icons.star,
                          size: 18,
                          color: Colors.orange,
                        ),
                        label: Text(
                          "Rating ${player.rating}",
                        ),
                      ),
                    ),

                    trailing: AnimatedContainer(
                      duration: const Duration(
                          milliseconds: 300),
                      decoration: BoxDecoration(
                        color: added
                            ? Colors.green
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      padding:
                      const EdgeInsets.all(8),
                      child: Icon(
                        added
                            ? Icons.check
                            : Icons.add,
                        color: added
                            ? Colors.white
                            : Colors.black54,
                      ),
                    ),

                    onTap: () {
                      togglePlayer(player);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}