class Tournament {
  final int? id;
  final String name;
  final String location;
  final String date;

  Tournament({
    this.id,
    required this.name,
    required this.location,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'date': date,
    };
  }

  factory Tournament.fromMap(
      Map<String, dynamic> map) {
    return Tournament(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      date: map['date'],
    );
  }

  Tournament copyWith({
    int? id,
    String? name,
    String? location,
    String? date,
  }) {
    return Tournament(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      date: date ?? this.date,
    );
  }
}