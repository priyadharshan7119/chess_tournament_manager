import '../database/database_helper.dart';
import '../models/player.dart';

class PlayerRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<List<Player>> getPlayers() async {
    final db = await dbHelper.database;

    final result = await db.query(
      'players',
      orderBy: 'id DESC',
    );

    return result.map((e) => Player.fromMap(e)).toList();
  }

  Future<void> insertPlayer(Player player) async {
    final db = await dbHelper.database;

    await db.insert(
      'players',
      player.toMap(),
    );
  }

  Future<void> updatePlayer(Player player) async {
    final db = await dbHelper.database;

    await db.update(
      'players',
      player.toMap(),
      where: 'id=?',
      whereArgs: [player.id],
    );
  }

  Future<void> deletePlayer(int id) async {
    final db = await dbHelper.database;

    await db.delete(
      'players',
      where: 'id=?',
      whereArgs: [id],
    );
  }
}