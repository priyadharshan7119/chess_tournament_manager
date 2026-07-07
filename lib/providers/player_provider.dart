import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/player.dart';
import '../repository/player_repository.dart';

final playerProvider =
StateNotifierProvider<PlayerNotifier, List<Player>>(
      (ref) => PlayerNotifier(),
);

class PlayerNotifier extends StateNotifier<List<Player>> {
  PlayerNotifier() : super([]) {
    loadPlayers();
  }

  final repository = PlayerRepository();

  Future<void> loadPlayers() async {
    state = await repository.getPlayers();
  }

  Future<void> addPlayer(Player player) async {
    await repository.insertPlayer(player);
    await loadPlayers();
  }

  Future<void> updatePlayer(Player player) async {
    await repository.updatePlayer(player);
    await loadPlayers();
  }

  Future<void> deletePlayer(int id) async {
    await repository.deletePlayer(id);
    await loadPlayers();
  }
}