import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(
      await getDatabasesPath(),
      'chess_tournament.db',
    );

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Players
    await db.execute('''
      CREATE TABLE players(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        rating INTEGER NOT NULL
      )
    ''');

    // Tournaments
    await db.execute('''
      CREATE TABLE tournaments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        location TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    // Tournament Players
    await db.execute('''
      CREATE TABLE tournament_players(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tournamentId INTEGER NOT NULL,
        playerId INTEGER NOT NULL
      )
    ''');

    // Matches
    await db.execute('''
      CREATE TABLE matches(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tournamentId INTEGER NOT NULL,
        player1Id INTEGER NOT NULL,
        player2Id INTEGER NOT NULL,
        winnerId INTEGER NOT NULL,
        round TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(
      Database db,
      int oldVersion,
      int newVersion,
      ) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE tournaments(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          location TEXT NOT NULL,
          date TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE tournament_players(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tournamentId INTEGER NOT NULL,
          playerId INTEGER NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE matches(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tournamentId INTEGER NOT NULL,
          player1Id INTEGER NOT NULL,
          player2Id INTEGER NOT NULL,
          winnerId INTEGER NOT NULL,
          round TEXT NOT NULL
        )
      ''');
    }
  }
}