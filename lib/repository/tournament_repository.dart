import 'package:chess_tournament_manager/database/database_helper.dart';
import 'package:chess_tournament_manager/models/tournament.dart';

class TournamentRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<List<Tournament>> getTournaments() async {
    final db = await dbHelper.database;

    final result = await db.query(
      'tournaments',
      orderBy: 'id DESC',
    );

    return result
        .map((e) => Tournament.fromMap(e))
        .toList();
  }

  Future<void> insertTournament(Tournament tournament) async {
    final db = await dbHelper.database;

    await db.insert(
      'tournaments',
      tournament.toMap(),
    );
  }

  Future<void> updateTournament(Tournament tournament) async {
    final db = await dbHelper.database;

    await db.update(
      'tournaments',
      tournament.toMap(),
      where: 'id = ?',
      whereArgs: [tournament.id],
    );
  }

  Future<void> deleteTournament(int id) async {
    final db = await dbHelper.database;

    await db.delete(
      'tournaments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}