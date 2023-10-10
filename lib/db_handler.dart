import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Board {
  int boardId;
  String name;
  String description;
  DateTime creationDate;
  DateTime lastUpdate;

  // Constructor
  Board({
    required this.boardId,
    required this.name,
    required this.description,
    required this.creationDate,
    required this.lastUpdate,
  });

  // Convert a Board object to a Map
  Map<String, dynamic> toMap() {
    return {
      'board_id': boardId,
      'name': name,
      'description': description,
      'creation_date': creationDate.toIso8601String(),
      'last_update': lastUpdate.toIso8601String(),
    };
  }

  // Create a Board object from a Map
  factory Board.fromMap(Map<String, dynamic> map) {
    return Board(
      boardId: map['board_id'],
      name: map['name'],
      description: map['description'],
      creationDate: DateTime.parse(map['creation_date']),
      lastUpdate: DateTime.parse(map['last_update']),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'local_boards_db.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE Boards('
        'board_id INTEGER PRIMARY KEY,'
        'name TEXT,'
        'description TEXT,'
        'creation_date DATETIME,'
        'last_update DATETIME);');
    await db.execute('CREATE TABLE Headers ('
        'header_id INTEGER PRIMARY KEY,'
        'board_id INTEGER,'
        'name TEXT,'
        'FOREIGN KEY (board_id) REFERENCES Boards(board_id));');
    await db.execute('CREATE TABLE Tasks ('
        'task_id INTEGER PRIMARY KEY,'
        'header_id INTEGER,'
        'name TEXT,'
        'description TEXT,'
        'assigned_user_id INTEGER, -- To be implemented in the future'
        'FOREIGN KEY (header_id) REFERENCES Headers(header_id),'
        'FOREIGN KEY (assigned_user_id) REFERENCES Users(user_id));');
  }

  Future<void> insertBoard(Board board) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert(
      'Boards',
      board.toMap(), // Converts Board object to a Map
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Board>> getAllBoards() async {
    final Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('Boards');
    return List.generate(maps.length, (i) {
      return Board.fromMap(maps[i]); // Converts Map to a Board object
    });
  }

  Future<void> updateBoard(Board board) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      'Boards',
      board.toMap(), // Converts Board object to a Map
      where: 'board_id = ?',
      whereArgs: [board.boardId],
    );
  }

  Future<void> deleteBoard(int boardId) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.delete(
      'Boards',
      where: 'board_id = ?',
      whereArgs: [boardId],
    );
  }
}
