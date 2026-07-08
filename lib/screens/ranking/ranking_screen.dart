import 'package:flutter/material.dart';

import 'package:chess_tournament_manager/models/tournament.dart';
import 'package:chess_tournament_manager/repository/match_repository.dart';

class RankingScreen extends StatefulWidget {
  final Tournament tournament;

  const RankingScreen({
    super.key,
    required this.tournament,
  });

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final MatchRepository repository = MatchRepository();

  List<Map<String, dynamic>> rankings = [];

  @override
  void initState() {
    super.initState();
    loadRanking();
  }

  Future<void> loadRanking() async {
    rankings = await repository.getRanking(widget.tournament.id!);

    if (mounted) {
      setState(() {});
    }
  }

  Color medalColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey;
      case 2:
        return const Color(0xffCD7F32);
      default:
        return Colors.blueGrey;
    }
  }

  IconData medalIcon(int index) {
    switch (index) {
      case 0:
        return Icons.emoji_events;
      case 1:
        return Icons.workspace_premium;
      case 2:
        return Icons.military_tech;
      default:
        return Icons.person;
    }
  }

  String position(int index) {
    switch (index) {
      case 0:
        return "Champion";
      case 1:
        return "Runner Up";
      case 2:
        return "Third Place";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF6D28D9),
        foregroundColor: Colors.white,
        title: const Text(
          "Tournament Ranking",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      body: rankings.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.emoji_events_outlined,
              size: 90,
              color: Colors.grey,
            ),

            SizedBox(height: 20),

            Text(
              "No Ranking Available",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(22),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff4F46E5),
                      Color(0xff7C3AED),
                    ],
                  ),
                  borderRadius:
                  BorderRadius.circular(22),
                ),
                child: Column(
                  children: [

                    const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 70,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Tournament Champion",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      rankings.first["name"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Chip(
                      avatar: const Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                      label: Text(
                        "${rankings.first["wins"]} Wins",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            ...List.generate(rankings.length, (index) {

              final player = rankings[index];

              return Card(
                elevation: 4,
                margin:
                const EdgeInsets.only(bottom: 18),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(18),
                ),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.all(18),

                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor:
                    medalColor(index),
                    child: Icon(
                      medalIcon(index),
                      color: Colors.white,
                    ),
                  ),

                  title: Text(
                    player["name"],
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  subtitle: Text(
                    position(index),
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.w500,
                    ),
                  ),

                  trailing: Chip(
                    avatar: const Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 18,
                    ),
                    label: Text(
                      "${player["wins"]} Wins",
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}