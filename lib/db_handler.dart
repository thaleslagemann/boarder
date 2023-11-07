//import 'dart:html';

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
  List<Bookmark> bookmarks = [];
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

  void addBoard(Board board) {
    boards.add(board);
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
    int boardIndex = findBoardIndexByID(board.boardId);
    boards.removeAt(boardIndex);
    boards.insert(boardIndex, board);
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      'Boards',
      board.toMap(), // Converts Board object to a Map
      where: 'board_id = ?',
      whereArgs: [board.boardId],
    );
  }

  Future<void> deleteBoard(Board board) async {
    int boardId = board.boardId;
    boards.remove(board);

    final Database db = await DatabaseHelper.instance.database;
    // Search and delete the bookmark if it exists
    int bookmarkIndex = findBookmarkIndex(board.boardId);
    print(bookmarkIndex);
    if (bookmarkIndex != -1) {
      Bookmark bookmark = bookmarks[bookmarkIndex];
      bookmarks.remove(bookmark);
      print("Bookmarks:");
      for (var bookmark in bookmarks) {
        print("[${bookmark.boardId}]");
      }

      print('removed bookmark $bookmarkIndex');
    }

    List<Header> headerRemovalList = [];
    List<Task> taskRemovalList = [];

    for (var header in headers) {
      if (header.boardId == boardId) {
        for (var task in tasks) {
          if (task.headerId == header.headerId) {
            taskRemovalList.add(task);
          }
        }
        headerRemovalList.add(header);
      }
    }

    for (var i = 0; i < taskRemovalList.length; i++) {
      tasks.remove(taskRemovalList[i]);
      await db.delete('Tasks', where: 'header_id = ?', whereArgs: [taskRemovalList[i].headerId]);
    }

    for (var i = 0; i < headerRemovalList.length; i++) {
      headers.remove(headerRemovalList[i]);
      await db.delete('Headers', where: 'header_id = ?', whereArgs: [headerRemovalList[i].headerId]);
    }

    if (bookmarkIndex != -1) {
      await db.query('Bookmarks', where: 'bookmark_id = ?', whereArgs: [board.boardId]);
    }
    print('removed board ${board.boardId} from list');
    await db.delete('Boards', where: 'board_id = ?', whereArgs: [board.boardId]);
  }

  // Create a bookmark
  void createBookmark(Bookmark bookmark) async {
    bookmarks.add(bookmark);
    final db = await database;
    await db.insert('Bookmarks', bookmark.toMap());
    print('Added bookmark ${bookmark.bookmarkId}');
    for (var bookmark in bookmarks) {
      print('[${bookmark.boardId}]');
    }
  }

  // Delete a bookmark
  Future<void> deleteBookmark(int bookmarkId) async {
    bookmarks.removeAt(findBookmarkIndex(bookmarkId));
    final db = await database;
    int rows = await db.delete('Bookmarks', where: 'bookmark_id = ?', whereArgs: [bookmarkId]);
    print('Deleted bookmark $bookmarkId, rows affected: $rows');
    for (var bookmark in bookmarks) {
      print('[${bookmark.boardId}]');
    }
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

  int findBookmarkIndex(bookmarkId) {
    for (var i = 0; i < bookmarks.length; i++) {
      if (bookmarks[i].bookmarkId == bookmarkId) {
        return i;
      }
    }
    return -1;
  }

  int findBoardIndexByID(int id) {
    List<dynamic> list = boards;
    if (list.isEmpty) {
      print("At FindIndexByID(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].boardId == id) {
        return i;
      }
    }
    print("At FindIndexByElement(): Element not found; returning index (-1)");
    return -1;
  }

  int findHeaderIndexByID(int id) {
    List<dynamic> list = headers;
    if (list.isEmpty) {
      print("At FindIndexByID(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].headerId == id) {
        return i;
      }
    }
    print("At FindIndexByElement(): Element not found; returning index (-1)");
    return -1;
  }

  int findTaskIndexByID(int id) {
    List<dynamic> list = tasks;
    if (list.isEmpty) {
      print("At FindIndexByID(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].taskId == id) {
        return i;
      }
    }
    print("Element not found; returning index (-1)");
    return -1;
  }

  void addHeader(Header header) {
    headers.add(header);
  }

  // Create a new header
  Future<void> insertHeader(Header header) async {
    int boardIndex = findBoardIndexByID(header.boardId);
    if (boardIndex != -1) {
      boards[boardIndex].headers.add(header);
      print("Board's headers:");
      for (var header in boards[findBoardIndexByID(header.boardId)].headers) {
        print('${header.headerId}, ${header.name}, ${header.orderIndex}');
      }
    }
    final Database db = await DatabaseHelper.instance.database;
    await db.insert(
      'Headers',
      header.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void addKanbanPresetHeadersToBoard(Board board) {
    List<Header> presetHeaders = [];
    int headersLength = headers.length;

    Header presetHeader1 = Header(headerId: headersLength, boardId: board.boardId, name: 'Backlog', orderIndex: 0);
    presetHeaders.add(presetHeader1);

    Header presetHeader2 = Header(headerId: headersLength + 1, boardId: board.boardId, name: 'To do', orderIndex: 1);
    presetHeaders.add(presetHeader2);

    Header presetHeader3 = Header(headerId: headersLength + 2, boardId: board.boardId, name: 'In progress', orderIndex: 2);
    presetHeaders.add(presetHeader3);

    Header presetHeader4 = Header(headerId: headersLength + 3, boardId: board.boardId, name: 'Testing', orderIndex: 3);
    presetHeaders.add(presetHeader4);

    Header presetHeader5 = Header(headerId: headersLength + 4, boardId: board.boardId, name: 'Done', orderIndex: 4);
    presetHeaders.add(presetHeader5);

    for (Header header in presetHeaders) {
      addHeader(header);
      insertHeader(header);
    }
  }

  void sortHeadersAndTasks() {
    for (var board in boards) {
      if (board.headers.isNotEmpty) {
        board.headers.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        print("Sorted headers by order_index:");
        for (var header in board.headers) {
          print("[${header.headerId}, ${header.name}, ${header.orderIndex}]");
        }
        for (var header in board.headers) {
          if (header.tasks.isNotEmpty) {
            header.tasks.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
            print("Sorted tasks by order_index:");
            for (var task in header.tasks) {
              print("[${task.taskId}, ${task.name}, ${task.orderIndex}]");
            }
          }
        }
      } else {
        print("Board is empty!");
      }
    }
    updateOrderInDatabase();
  }

  void redefineTasksHeaders() {
    List<Task> taskListToRedefine = [];
    for (var board in boards) {
      for (var header in board.headers) {
        for (var task in header.tasks) {
          if (task.headerId != header.headerId) {
            print("Differing headerId found");
            print("${task.name} has ${task.headerId}, parent Id is ${header.headerId}");
            taskListToRedefine.add(task);
          }
        }
      }
    }
    for (var task in taskListToRedefine) {
      for (var header in headers) {
        if (header.tasks.contains(task)) {
          print("Found task [${task.name}] in header [${header.name}], deleting...");
          header.tasks.remove(task);
        }
      }
      print("Inserting [${task.name}] in header [${headers[findHeaderIndexByID(task.headerId)].name}]");
      headers[findHeaderIndexByID(task.headerId)].tasks.add(task);
    }
    updateHeadersInDatabase();
    updateTasksInDatabase();
  }

  void addTask(Task task) {
    tasks.add(task);
  }

  Future<void> createTask(Task task) async {
    tasks.add(task);
    headers[findHeaderIndexByID(task.headerId)].tasks.add(task);
    final Database db = await DatabaseHelper.instance.database;
    await db.insert(
      'Tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateOrderInDatabase() async {
    final Database db = await DatabaseHelper.instance.database;

    // Update order_index for headers
    for (var board in boards) {
      for (var header in board.headers) {
        await db.update(
          'Headers',
          {'order_index': header.orderIndex},
          where: 'header_id = ?',
          whereArgs: [header.headerId],
        );
        for (var task in header.tasks) {
          await db.update(
            'Tasks',
            {'order_index': task.orderIndex},
            where: 'task_id = ?',
            whereArgs: [task.taskId],
          );
        }
      }
    }
  }

  // Update the order_index of tasks in the database for a specific header
  Future<void> updateTaskOrderInDatabase(Task task, Header oldHeader, Header newHeader, int oldTaskIndex, int newTaskIndex) async {
    final Database db = await DatabaseHelper.instance.database;

    var updatedTask = task;
    updatedTask.orderIndex = newTaskIndex;

    if (oldHeader != newHeader) {
      oldHeader.tasks.removeAt(oldTaskIndex);
      newHeader.tasks.insert(newTaskIndex, task);

      for (var header in headers) {
        if (header.headerId == oldHeader.headerId) {
          int index = headers.indexOf(header);
          headers[index].tasks = oldHeader.tasks;
        }
        if (header.headerId == newHeader.headerId) {
          int index = headers.indexOf(header);
          headers[index].tasks = newHeader.tasks;
        }
      }

      await db.update('Tasks', {'header_id': newHeader.headerId});
    }
    for (int i = 0; i < tasks.length; i++) {
      final itbTask = tasks[i];
      await db.update(
        'Tasks',
        {'order_index': i},
        where: 'task_id = ?',
        whereArgs: [itbTask.taskId],
      );
    }
    await db.update('Tasks', {'order_index': newTaskIndex});
  }

  Future<void> updateHeadersInDatabase() async {
    final Database db = await DatabaseHelper.instance.database;

    int changes = 0;

    print("Updating headers in database...");
    for (var header in headers) {
      final List<Map<String, dynamic>> maps = await db.query(
        'Headers',
        where: 'header_id = ?',
        whereArgs: [header.headerId],
      );

      final int dbHeaderOrderIndex = maps.first['order_index'];
      if (dbHeaderOrderIndex != header.orderIndex) {
        print('Header [${header.name}] O_I.: $dbHeaderOrderIndex | ${header.orderIndex}');
        changes += await db.update(
          'Headers',
          {'name': header.name, 'order_index': header.orderIndex},
          where: 'header_id = ?',
          whereArgs: [header.headerId],
        );
      }
    }
    print("Headers update complete.");
    if (changes > 0) {
      print("$changes headers changed.");
    } else if (changes == 1) {
      print("$changes header changed.");
    } else {
      print("No header changed.");
    }
  }

  Future<void> updateTasksInDatabase() async {
    final Database db = await DatabaseHelper.instance.database;

    int changes = 0;

    print("Updating tasks in database...");
    for (var task in tasks) {
      final List<Map<String, dynamic>> maps = await db.query(
        'Tasks',
        where: 'task_id = ?',
        whereArgs: [task.taskId],
      );

      final int dbTaskHeaderId = maps.first['header_id'];
      final int dbTaskOrderIndex = maps.first['order_index'];
      if (dbTaskHeaderId != task.headerId || dbTaskOrderIndex != task.orderIndex) {
        print('Task [${task.name}] Head: $dbTaskHeaderId | ${task.headerId}');
        print('Task [${task.name}] O_I.: $dbTaskOrderIndex | ${task.orderIndex}');
        changes += await db.update(
          'Tasks',
          {
            'header_id': task.headerId,
            'name': task.name,
            'description': task.description,
            'assigned_user_id': task.assignedUserId,
            'order_index': task.orderIndex
          },
          where: 'task_id = ?',
          whereArgs: [task.taskId],
        );
      }
    }

    print("Tasks update complete.");
    if (changes > 0) {
      print("$changes tasks changed.");
    } else if (changes == 1) {
      print("$changes task changed.");
    } else {
      print("No task changed.");
    }
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
  void updateHeaderName(int headerId, String newName) async {
    headers[findHeaderIndexByID(headerId)].name = newName;
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      'Headers',
      {'name': newName},
      where: 'header_id = ?',
      whereArgs: [headerId],
    );
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
    tasks[findTaskIndexByID(taskId)].name = newName;
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      'Tasks',
      {'name': newName},
      where: 'task_id = ?',
      whereArgs: [taskId],
    );
  }

  // Update a task's description
  Future<void> updateTaskDescription(int taskId, String newDescription) async {
    tasks[findTaskIndexByID(taskId)].description = newDescription;
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      'Tasks',
      {'description': newDescription},
      where: 'task_id = ?',
      whereArgs: [taskId],
    );
  }

  // Delete a header
  void deleteHeader(Header header) async {
    List<Task> taskRemovalList = [];

    for (var task in header.tasks) {
      if (task.headerId == header.headerId) {
        taskRemovalList.add(task);
      }
    }

    headers.remove(header);
    boards[findBoardIndexByID(header.boardId)].headers.remove(header);
    final Database db = await DatabaseHelper.instance.database;
    await db.delete('Headers', where: 'header_id = ?', whereArgs: [header.headerId]);

    for (var i = 0; i < taskRemovalList.length; i++) {
      tasks.remove(taskRemovalList[i]);
      await db.delete('Tasks', where: 'header_id = ?', whereArgs: [taskRemovalList[i].headerId]);
    }
  }

  // Delete a task
  void deleteTask(Task task) async {
    tasks.remove(task);
    headers[findHeaderIndexByID(task.headerId)].tasks.remove(task);
    final Database db = await DatabaseHelper.instance.database;
    await db.delete('Tasks', where: 'task_id = ?', whereArgs: [task.taskId]);
  }

  void insertReorderTask(Task oldTask, int oldTaskIndex, int newTaskIndex, int boardIndex, int oldHeaderIndex, int newHeaderIndex) {
    // copy oldHeaderIndex.oldTaskIndex into a buffer
    Task oldTaskBuffer = oldTask;
    // delete oldHeaderIndex.oldTaskIndex from old position
    boards[boardIndex].headers[oldHeaderIndex].tasks.remove(oldTask);
    // iterate through the remaining positions after old position
    for (int i = 0; i < boards[boardIndex].headers[oldHeaderIndex].tasks.length; i++) {
      // decrement orderIndex of remaining positions
      if (i >= oldTaskIndex) {
        boards[boardIndex].headers[oldHeaderIndex].tasks[i].orderIndex = i;
      }
    }
    // change the task's headerId if it's different
    if (oldTaskBuffer.headerId != boards[boardIndex].headers[newHeaderIndex].headerId) {
      oldTaskBuffer.headerId = boards[boardIndex].headers[newHeaderIndex].headerId;
    }
    if (boards[boardIndex].headers[newHeaderIndex].tasks.isEmpty) {
      // insert oldHeaderIndex.oldTaskIndex into new position
      boards[boardIndex].headers[newHeaderIndex].tasks.add(oldTaskBuffer);
    } else {
      // insert oldHeaderIndex.oldTaskIndex into new position
      boards[boardIndex].headers[newHeaderIndex].tasks.insert(newTaskIndex, oldTaskBuffer);
      // loop through the whole array adjusting the orderIndex
      for (int i = 0; i < boards[boardIndex].headers[newHeaderIndex].tasks.length; i++) {
        // increment orderIndex of remaining positions
        boards[boardIndex].headers[newHeaderIndex].tasks[i].orderIndex = i;
      }
    }
  }
}
