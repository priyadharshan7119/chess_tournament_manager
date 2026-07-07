import 'package:flutter/material.dart';

import 'package:chess_tournament_manager/models/tournament.dart';
import 'package:chess_tournament_manager/repository/match_repository.dart';
import 'package:chess_tournament_manager/screens/ranking/ranking_screen.dart';

class MatchScreen extends StatefulWidget {
  final Tournament tournament;

  const MatchScreen({
    super.key,
    required this.tournament,
  });

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final MatchRepository repository = MatchRepository();

  List<Map<String, dynamic>> matches = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadMatches();
  }

  Future<void> loadMatches() async {
    matches = await repository.getMatches(widget.tournament.id!);

    if (mounted) setState(() {});
  }

  Future<void> generateMatches() async {
    setState(() => loading = true);

    try {
      await repository.generateMatches(widget.tournament.id!);
      await loadMatches();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tournament Generated Successfully"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: Text(widget.tournament.name),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: loading ? null : generateMatches,
        icon: loading
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.casino),
        label: Text(
          loading ? "Generating..." : "Generate",
        ),
      ),

      body: matches.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.sports_esports,
              size: 90,
              color: Colors.grey,
            ),

            SizedBox(height: 20),

            Text(
              "No Matches Generated",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Tap Generate to create the tournament",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: matches.length,
        itemBuilder: (context, index) {

          final match = matches[index];

          final showRound = index == 0 ||
              match["round"] !=
                  matches[index - 1]["round"];

          return Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              if (showRound)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 15,
                    top: 10,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                    child: Text(
                      match["round"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                margin:
                const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding:
                  const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                        Colors.blue.shade100,
                        child: Text(
                          match["player1"]
                              .toString()[0]
                              .toUpperCase(),
                          style: const TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        match["player1"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const Padding(
                        padding:
                        EdgeInsets.symmetric(
                            vertical: 18),
                        child: Icon(
                          Icons.sports,
                          size: 34,
                          color: Colors.red,
                        ),
                      ),

                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                        Colors.orange.shade100,
                        child: Text(
                          match["player2"]
                              .toString()[0]
                              .toUpperCase(),
                          style: const TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        match["player2"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const Divider(height: 35),

                      Chip(
                        avatar: const Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                        ),
                        label: Text(
                          "Winner : ${match["winner"]}",
                          style:
                          const TextStyle(
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: matches.isEmpty
          ? null
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            icon: const Icon(Icons.workspace_premium),
            label: const Text(
              "View Rankings",
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RankingScreen(
                    tournament: widget.tournament,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}