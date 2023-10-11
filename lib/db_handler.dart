import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Board {
  int boardId;
  String name;
  String description;
  DateTime creationDate;
  DateTime lastUpdate;
  List<Header> headers;

  Board({
    required this.boardId,
    required this.name,
    required this.description,
    required this.creationDate,
    required this.lastUpdate,
    this.headers = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'board_id': boardId,
      'name': name,
      'description': description,
      'creation_date': creationDate.toIso8601String(),
      'last_update': lastUpdate.toIso8601String(),
    };
  }

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

class Bookmark {
  int bookmarkId;
  int boardId;

  Bookmark({
    required this.bookmarkId,
    required this.boardId,
  });

  Map<String, dynamic> toMap() {
    return {
      'bookmark_id': bookmarkId,
      'board_id': boardId,
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      bookmarkId: map['bookmark_id'],
      boardId: map['board_id'],
    );
  }
}

class Header {
  int headerId;
  int boardId;
  String name;
  int orderIndex;
  List<Task> tasks;

  Header({
    required this.headerId,
    required this.boardId,
    required this.name,
    required this.orderIndex,
    this.tasks = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'header_id': headerId,
      'board_id': boardId,
      'name': name,
      'order_index': orderIndex,
    };
  }

  factory Header.fromMap(Map<String, dynamic> map) {
    return Header(
      headerId: map['header_id'],
      boardId: map['board_id'],
      name: map['name'],
      orderIndex: map['order_index'],
    );
  }
}

class Task {
  int taskId;
  int headerId;
  String name;
  String description;
  int assignedUserId;
  int orderIndex;

  Task({
    required this.taskId,
    required this.headerId,
    required this.name,
    required this.description,
    required this.assignedUserId,
    required this.orderIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'task_id': taskId,
      'header_id': headerId,
      'name': name,
      'description': description,
      'assigned_user_id': assignedUserId,
      'order_index': orderIndex,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskId: map['task_id'],
      headerId: map['header_id'],
      name: map['name'],
      description: map['description'],
      assignedUserId: map['assigned_user_id'],
      orderIndex: map['order_index'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  List<Board> boards = [];
  List<Header> headers = [];
  List<Task> tasks = [];

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'local_boards_db.db');
    //databaseFactory.deleteDatabase(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> initializeDatabase() {
    return _initDatabase();
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE Boards('
        'board_id INTEGER PRIMARY KEY,'
        'name TEXT,'
        'description TEXT,'
        'creation_date DATETIME,'
        'last_update DATETIME);');
    await db.execute('CREATE TABLE Bookmarks('
        'bookmark_id INTEGER PRIMARY KEY,'
        'board_id INTEGER);');
    await db.execute('CREATE TABLE Headers ('
        'header_id INTEGER PRIMARY KEY,'
        'board_id INTEGER,'
        'name TEXT,'
        'order_index INTEGER,'
        'FOREIGN KEY (board_id) REFERENCES Boards(board_id));');
    await db.execute('CREATE TABLE Tasks ('
        'task_id INTEGER PRIMARY KEY,'
        'header_id INTEGER,'
        'name TEXT,'
        'description TEXT,'
        'assigned_user_id INTEGER,'
        'order_index INTEGER,'
        'FOREIGN KEY (header_id) REFERENCES Headers(header_id),'
        'FOREIGN KEY (assigned_user_id) REFERENCES Users(user_id));');
  }

  Future<void> insertBoard(Board board) async {
    boards.add(board);
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

    final headers =
        await db.query('Headers', where: 'board_id = ?', whereArgs: [boardId]);
    for (final header in headers) {
      final headerId = header['header_id'] as int;

      await db.delete('Tasks', where: 'header_id = ?', whereArgs: [headerId]);
      await db.delete('Headers', where: 'header_id = ?', whereArgs: [headerId]);
    }

    await db.delete('Boards', where: 'board_id = ?', whereArgs: [boardId]);
  }

  Future<void> createBookmark(Bookmark bookmark) async {
    final db = await database;
    await db.insert('Bookmarks', bookmark.toMap());
  }

  // Get all bookmarked boards
  Future<List<Bookmark>> getAllBookmarks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Bookmarks');
    return List.generate(maps.length, (i) {
      return Bookmark(
        bookmarkId: maps[i]['bookmark_id'],
        boardId: maps[i]['board_id'],
      );
    });
  }

  // Delete a bookmark
  Future<void> deleteBookmark(int bookmarkId) async {
    final db = await database;
    await db
        .delete('Bookmarks', where: 'bookmark_id = ?', whereArgs: [bookmarkId]);
  }

  void addHeader(Header header) {
    header.orderIndex = headers.length;
    headers.add(header);
  }

  void addTaskToHeader(Task task, Header header) {
    final targetHeader = headers.firstWhere(
      (h) => h.headerId == header.headerId,
      orElse: () => throw Exception('Header not found'),
    );
    task.orderIndex = targetHeader.tasks.length;
    targetHeader.tasks.add(task);
  }

  Future<void> updateOrderInDatabase() async {
    final Database db = await DatabaseHelper.instance.database;

    // Update order_index for headers
    for (int i = 0; i < headers.length; i++) {
      final header = headers[i];
      await db.update(
        'Headers',
        {'order_index': i},
        where: 'header_id = ?',
        whereArgs: [header.headerId],
      );
    }

    // Update order_index for tasks
    for (final header in headers) {
      for (int i = 0; i < header.tasks.length; i++) {
        final task = header.tasks[i];
        await db.update(
          'Tasks',
          {'order_index': i},
          where: 'task_id = ?',
          whereArgs: [task.taskId],
        );
      }
    }
  }

  // Update the order_index of tasks in the database for a specific header
  Future<void> updateTaskOrderInDatabase(Header header) async {
    final Database db = await DatabaseHelper.instance.database;

    // Update order_index for tasks within the specified header
    for (int i = 0; i < header.tasks.length; i++) {
      final task = header.tasks[i];
      await db.update(
        'Tasks',
        {'order_index': i},
        where: 'task_id = ?',
        whereArgs: [task.taskId],
      );
    }
  }

  // Create a new header
  Future<void> createHeader(Header header) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert('Headers', header.toMap());
  }

  // Read headers for a specific board
  Future<List<Header>> getHeadersForBoard(int boardId) async {
    final Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Headers',
      where: 'board_id = ?',
      whereArgs: [boardId],
    );

    return List.generate(maps.length, (i) {
      return Header.fromMap(maps[i]);
    });
  }

  // Update a header's name
  Future<void> updateHeaderName(int headerId, String newName) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      'Headers',
      {'name': newName},
      where: 'header_id = ?',
      whereArgs: [headerId],
    );
  }

  // Delete a header
  Future<void> deleteHeader(int headerId) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.delete('Headers', where: 'header_id = ?', whereArgs: [headerId]);
  }

  // Create a new task
  Future<void> createTask(Task task) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert('Tasks', task.toMap());
  }

  // Read tasks for a specific header
  Future<List<Task>> getTasksForHeader(int headerId) async {
    final Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Tasks',
      where: 'header_id = ?',
      whereArgs: [headerId],
      orderBy: 'order_index', // Order by order_index to maintain order
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Update a task's name
  Future<void> updateTaskName(int taskId, String newName) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      'Tasks',
      {'name': newName},
      where: 'task_id = ?',
      whereArgs: [taskId],
    );
  }

  // Delete a task
  Future<void> deleteTask(int taskId) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.delete('Tasks', where: 'task_id = ?', whereArgs: [taskId]);
  }
}
