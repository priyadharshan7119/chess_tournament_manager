class MatchModel {
  final int? id;
  final int tournamentId;
  final int player1Id;
  final int player2Id;
  final int winnerId;
  final String round;

  MatchModel({
    this.id,
    required this.tournamentId,
    required this.player1Id,
    required this.player2Id,
    required this.winnerId,
    required this.round,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tournamentId': tournamentId,
      'player1Id': player1Id,
      'player2Id': player2Id,
      'winnerId': winnerId,
      'round': round,
    };
  }

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      id: map['id'],
      tournamentId: map['tournamentId'],
      player1Id: map['player1Id'],
      player2Id: map['player2Id'],
      winnerId: map['winnerId'],
      round: map['round'],
    );
  }
}