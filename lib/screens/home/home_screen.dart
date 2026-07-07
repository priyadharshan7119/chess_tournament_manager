import 'package:flutter/material.dart';
import 'package:chess_tournament_manager/screens/player/player_screen.dart';
import 'package:chess_tournament_manager/screens/tournament/tournament_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff4F46E5),
                      Color(0xff7C3AED),
                    ],
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 50,
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Chess Tournament",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Manage Players, Tournaments and Rankings",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              LayoutBuilder(
                builder: (context, constraints) {

                  int crossAxisCount =
                  constraints.maxWidth > 700 ? 2 : 1;

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2.4,
                    children: [

                      _dashboardCard(
                        context,
                        color: Colors.blue,
                        icon: Icons.people,
                        title: "Players",
                        subtitle: "Manage Players",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const PlayerScreen(),
                            ),
                          );
                        },
                      ),

                      _dashboardCard(
                        context,
                        color: Colors.orange,
                        icon: Icons.emoji_events,
                        title: "Tournament",
                        subtitle: "Manage Tournament",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const TournamentScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              // const Text(
              //   "About",
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 22,
              //   ),
              // ),
              //
              // const SizedBox(height: 15),
              //
              // Card(
              //   elevation: 4,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: const Padding(
              //     padding: EdgeInsets.all(20),
              //     child: Row(
              //       children: [
              //
              //         CircleAvatar(
              //           radius: 30,
              //           backgroundColor: Colors.deepPurple,
              //           child: Icon(
              //             Icons.sports_esports,
              //             color: Colors.white,
              //           ),
              //         ),
              //
              //         SizedBox(width: 20),
              //
              //         Expanded(
              //           child: Text(
              //             "This application manages chess tournaments by allowing player management, tournament creation, random match generation and ranking display.",
              //             style: TextStyle(
              //               fontSize: 15,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              SizedBox(height: size.height * .02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dashboardCard(
      BuildContext context, {
        required Color color,
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [

              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(.15),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}