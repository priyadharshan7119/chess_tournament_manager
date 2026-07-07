import 'package:chess_tournament_manager/database/database_helper.dart';

class TournamentPlayerRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<void> addPlayer(
      int tournamentId,
      int playerId) async {

    final db = await dbHelper.database;

    await db.insert(
      'tournament_players',
      {
        'tournamentId': tournamentId,
        'playerId': playerId,
      },
    );
  }

  Future<List<int>> getPlayers(
      int tournamentId) async {

    final db = await dbHelper.database;

    final result = await db.query(
      'tournament_players',
      where: 'tournamentId=?',
      whereArgs: [tournamentId],
    );

    return result
        .map((e) => e['playerId'] as int)
        .toList();
  }

  Future<void> removePlayer(
      int tournamentId,
      int playerId) async {

    final db = await dbHelper.database;

    await db.delete(
      'tournament_players',
      where:
      'tournamentId=? AND playerId=?',
      whereArgs: [
        tournamentId,
        playerId,
      ],
    );
  }
}