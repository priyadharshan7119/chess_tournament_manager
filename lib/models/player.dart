class Player {
  final int? id;
  final String name;
  final int rating;

  Player({
    this.id,
    required this.name,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      rating: map['rating'],
    );
  }

  Player copyWith({
    int? id,
    String? name,
    int? rating,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      rating: rating ?? this.rating,
    );
  }
}