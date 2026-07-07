import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tournament.dart';
import '../repository/tournament_repository.dart';

final tournamentProvider =
StateNotifierProvider<
    TournamentNotifier,
    List<Tournament>>(
      (ref) => TournamentNotifier(),
);

class TournamentNotifier
    extends StateNotifier<List<Tournament>> {

  TournamentNotifier() : super([]) {
    loadTournaments();
  }

  final repository =
  TournamentRepository();

  Future<void> loadTournaments() async {
    state =
    await repository.getTournaments();
  }

  Future<void> addTournament(
      Tournament tournament) async {

    await repository
        .insertTournament(tournament);

    await loadTournaments();
  }

  Future<void> updateTournament(
      Tournament tournament) async {

    await repository
        .updateTournament(tournament);

    await loadTournaments();
  }

  Future<void> deleteTournament(
      int id) async {

    await repository
        .deleteTournament(id);

    await loadTournaments();
  }
}