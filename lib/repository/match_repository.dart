import 'dart:math';

import 'package:chess_tournament_manager/database/database_helper.dart';
import 'package:chess_tournament_manager/models/match_model.dart';
import 'package:chess_tournament_manager/models/player.dart';

class MatchRepository {

  final dbHelper = DatabaseHelper.instance;
  final Random random = Random();

  Future<List<Player>> getTournamentPlayers(int tournamentId) async {

    final db = await dbHelper.database;

    final result = await db.rawQuery('''
    SELECT players.*
    FROM players
    INNER JOIN tournament_players
    ON players.id=tournament_players.playerId
    WHERE tournament_players.tournamentId=?
    ''',[tournamentId]);

    return result.map((e)=>Player.fromMap(e)).toList();

  }
  Future<List<Player>> playRound({
    required int tournamentId,
    required List<Player> players,
    required String round,
  }) async {

    final db = await dbHelper.database;

    List<Player> winners=[];

    for(int i=0;i<players.length;i+=2){

      final p1=players[i];
      final p2=players[i+1];

      final winner=random.nextBool()?p1:p2;

      winners.add(winner);

      await db.insert(
        "matches",
        MatchModel(
          tournamentId: tournamentId,
          player1Id: p1.id!,
          player2Id: p2.id!,
          winnerId: winner.id!,
          round: round,
        ).toMap(),
      );

    }

    return winners;

  }
  Future<void> generateMatches(int tournamentId) async {

    final db=await dbHelper.database;

    await db.delete(
      "matches",
      where: "tournamentId=?",
      whereArgs: [tournamentId],
    );

    List<Player> players=
    await getTournamentPlayers(tournamentId);

    if(players.length!=4 && players.length!=8){
      throw Exception(
          "Tournament must contain exactly 4 or 8 players."
      );
    }

    players.shuffle();

    if(players.length==8){

      final quarterWinners=await playRound(
        tournamentId: tournamentId,
        players: players,
        round: "Quarter Final",
      );

      final semiWinners=await playRound(
        tournamentId: tournamentId,
        players: quarterWinners,
        round: "Semi Final",
      );

      await playRound(
        tournamentId: tournamentId,
        players: semiWinners,
        round: "Final",
      );

    }else{

      final finalists=await playRound(
        tournamentId: tournamentId,
        players: players,
        round: "Semi Final",
      );

      await playRound(
        tournamentId: tournamentId,
        players: finalists,
        round: "Final",
      );

    }

  }
  Future<List<Map<String, dynamic>>> getMatches(
      int tournamentId) async {

    final db = await dbHelper.database;

    return await db.rawQuery('''
    SELECT

      m.id,
      m.round,

      p1.name AS player1,
      p2.name AS player2,
      w.name AS winner

    FROM matches m

    JOIN players p1
    ON p1.id = m.player1Id

    JOIN players p2
    ON p2.id = m.player2Id

    JOIN players w
    ON w.id = m.winnerId

    WHERE m.tournamentId = ?

    ORDER BY m.id
  ''', [tournamentId]);

  }
  Future<List<Map<String, dynamic>>> getRanking(
      int tournamentId) async {

    final db = await dbHelper.database;

    return await db.rawQuery('''
    SELECT

      p.id,
      p.name,

      COUNT(m.winnerId) AS wins

    FROM players p

    LEFT JOIN matches m

    ON p.id = m.winnerId

    AND m.tournamentId = ?

    GROUP BY p.id

    ORDER BY wins DESC

    LIMIT 3

  ''', [tournamentId]);

  }
}