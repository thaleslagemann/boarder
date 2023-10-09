library config.globals;

import 'dart:convert';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kanban_flt/themes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

MyTheme globalAppTheme = MyTheme();

class Constants {
  static const String AddTask = 'Add Task';
  static const String Delete = 'Delete';
  static const String Rename = 'Rename';
  static const String Edit = 'Edit';
  static const String Bookmark = 'Bookmark';
  static const String Details = 'Details';

  static const List<String> headerChoices = <String>[
    AddTask,
    Delete,
    Rename,
  ];
  static const List<String> boardChoices = <String>[
    Details,
    Bookmark,
    Edit,
    Delete,
  ];
}

class BoardDataStructure {
  final int id;
  final String name;
  final String description;
  final DateTime creationDate;
  final DateTime lastUpdate;
  List<int> headerIdList;

  BoardDataStructure(
      {required this.id,
      required this.name,
      required this.description,
      required this.creationDate,
      required this.lastUpdate,
      required this.headerIdList});
}

class HeaderStructure {
  final int id;
  final String name;
  final int parentBoardID;
  List<int> taskIdList;

  HeaderStructure(
      {required this.id,
      required this.name,
      required this.parentBoardID,
      required this.taskIdList});
}

class TaskStructure {
  final int id;
  final int parentHeaderID;
  final String name;
  final String taskDescription;

  TaskStructure(
      {required this.id,
      required this.parentHeaderID,
      required this.name,
      required this.taskDescription});
}

class ConfigState extends ChangeNotifier {
  List<HeaderStructure> headers = [];
  List<TaskStructure> tasks = [];

  List<BoardDataStructure> boards = [];
  List<BoardDataStructure> favoriteBoards = [];
  late Database localDB;
  bool loadingDB = true;

  void loadDB() async {
    if (loadingDB) {
      print('Loading DB: $loadingDB');
      var databasesPath = await getDatabasesPath();
      print('DBs Path: $databasesPath');
      String path = join(databasesPath, 'local_boards_db.db');
      print('LocalDB path: $path');
      //databaseFactory.deleteDatabase(path);
      localDB = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // await db.execute('DROP TABLE boards');
        // await db.execute('DROP TABLE favoriteBoards');
        // await db.execute('DROP TABLE headers');
        // await db.execute('DROP TABLE tasks');
        await db.execute(
            'CREATE TABLE IF NOT EXISTS boards(id INTEGER PRIMARY KEY, name TEXT, description TEXT, creationDate TEXT, lastUpdate TEXT, headerIDs TEXT)');
        await db.execute(
            'CREATE TABLE IF NOT EXISTS favoriteBoards(id INTEGER PRIMARY KEY, name TEXT, description TEXT, creationDate TEXT, lastUpdate TEXT)');
        await db.execute(
            'CREATE TABLE IF NOT EXISTS headers(headerId INTEGER PRIMARY KEY, headerName TEXT, parentBoardId INTEGER, taskIDs TEXT)');
        await db.execute(
            'CREATE TABLE IF NOT EXISTS tasks(taskId INTEGER PRIMARY KEY, taskName TEXT, taskDescription TEXT, headerId INTEGER)');
      });
      // await localDB.execute('DELETE FROM favoriteBoards');
      // await localDB.execute('DELETE FROM boards');
      // await localDB.execute('DELETE FROM headers');
      // await localDB.execute('DELETE FROM tasks');
      List<Map> boardsQuery = await localDB.rawQuery('SELECT * FROM boards');
      convertRawQueryToBoard(boardsQuery);
      List<Map> favoriteBoards =
          await localDB.rawQuery('SELECT * FROM favoriteBoards');
      convertRawQueryToFavBoard(favoriteBoards);
      List<Map> tasks = await localDB.rawQuery('SELECT * FROM tasks');
      convertRawQueryToTask(tasks);
      List<Map> headersQuery = await localDB.rawQuery('SELECT * FROM headers');
      convertRawQueryToHeader(headersQuery);

      for (var board in boards) {
        print('Getting board [${board.name}]\'s headers');
        boards[findIndexByID(boards, board.id)].headerIdList =
            await getBoardsHeaderList(board.id);
      }
      print('Boards $boards');
      print('FavoriteBoards: $favoriteBoards');
      print('Headers: $headersQuery');
      print('Tasks: $tasks');
      print('DB loaded');
      loadingDB = false;
      print('Loading DB: $loadingDB');
      notifyListeners();
      localDB.close();
    }
  }

  void convertRawQueryToBoard(List<Map> rawQuery) {
    for (var i = 0; i < rawQuery.length; i++) {
      print(rawQuery[i].values);
      int id = rawQuery[i].values.elementAt(0);
      String name = rawQuery[i].values.elementAt(1).toString();
      String description = rawQuery[i].values.elementAt(2).toString();
      String creationDate = rawQuery[i].values.elementAt(3).toString();
      String lastUpdate = rawQuery[i].values.elementAt(4).toString();

      BoardDataStructure board = BoardDataStructure(
          id: id,
          name: name,
          description: description,
          creationDate: DateTime.parse(creationDate),
          lastUpdate: DateTime.parse(lastUpdate),
          headerIdList: []);

      if (!containsElement(boards, board)) {
        boards.add(board);
      }
      print('On Convert Board Statement: [${board.id},${board.name}]');
    }
    if (rawQuery.isEmpty) {
      print('Boards DB is empty');
    }
  }

  void convertRawQueryToFavBoard(List<Map> rawQuery) {
    for (var i = 0; i < rawQuery.length; i++) {
      int id = rawQuery[i].values.elementAt(0);
      String name = rawQuery[i].values.elementAt(1).toString();
      String description = rawQuery[i].values.elementAt(2).toString();
      String creationDate = rawQuery[i].values.elementAt(3).toString();
      String lastUpdate = rawQuery[i].values.elementAt(4).toString();

      BoardDataStructure board = BoardDataStructure(
          id: id,
          name: name,
          description: description,
          creationDate: DateTime.parse(creationDate),
          lastUpdate: DateTime.parse(lastUpdate),
          headerIdList: []);

      if (!containsElement(favoriteBoards, board)) {
        favoriteBoards.add(board);
      }
      print('On Convert Fav Statement: [${board.id},${board.name}]');
    }
    if (rawQuery.isEmpty) {
      print('Favorites DB is empty');
    }
  }

  void convertRawQueryToHeader(List<Map> rawQuery) {
    for (var i = 0; i < rawQuery.length; i++) {
      print(rawQuery[i].values);
      int id = rawQuery[i].values.elementAt(0);
      String name = rawQuery[i].values.elementAt(1).toString();
      int parentBoardID = rawQuery[i].values.elementAt(2);
      if (rawQuery[i].values.elementAt(3) != null) {
        var json = rawQuery[i].values.elementAt(3).toString().substring(
            1, rawQuery[i].values.elementAt(3).toString().length - 1);
        List<String> jsonList = json.split(',');
        print('json: ${jsonList}');
        List<int> taskIDs = [];
        for (var item in jsonList) {
          taskIDs.add(int.parse(item));
        }
        HeaderStructure header = HeaderStructure(
            id: id,
            name: name,
            parentBoardID: parentBoardID,
            taskIdList: taskIDs);
        print('at rawQueryToHeader: $taskIDs');
        if (!containsHeader(headers, header)) {
          headers.add(header);
        }
      } else {
        List<int> taskIDs = [];
        print('at rawQueryToHeader: $taskIDs');
      }

      HeaderStructure header = HeaderStructure(
        id: id,
        name: name,
        parentBoardID: parentBoardID,
        taskIdList: [],
      );

      if (!containsHeader(headers, header)) {
        headers.add(header);
      }
      print('On Convert Header Statement: [${header.id},${header.name}]');
    }
    if (rawQuery.isEmpty) {
      print('Headers DB is empty');
    }
  }

  void convertRawQueryToTask(List<Map> rawQuery) {
    for (var i = 0; i < rawQuery.length; i++) {
      print(rawQuery[i].values);
      int id = rawQuery[i].values.elementAt(0);
      String name = rawQuery[i].values.elementAt(1).toString();
      String taskDescription = rawQuery[i].values.elementAt(2).toString();
      int parentHeaderID = rawQuery[i].values.elementAt(3);

      TaskStructure task = TaskStructure(
        id: id,
        parentHeaderID: parentHeaderID,
        name: name,
        taskDescription: taskDescription,
      );

      if (!containsTask(tasks, task)) {
        tasks.add(task);
        print('On Convert Task Statement: Add [${task.id},${task.name}]');
      }
    }
    if (rawQuery.isEmpty) {
      print('Tasks DB is empty');
    }
  }

  Future<bool> tableIsEmpty(String table) async {
    int? count = Sqflite.firstIntValue(
        await localDB.rawQuery('SELECT COUNT(*) FROM $table'));

    if (count != null) {
      print('table is not empty');
      return false;
    }
    print('table is empty');
    return true;
  }

  Future<void> insertHeaderListDataOnBoard(
      int boardID, List<int> headerIdList) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    final jsonList = jsonEncode(headerIdList);

    await localDB.update(
      'boards',
      {'headerIDs': jsonList},
      where: 'id = ?',
      whereArgs: [boardID],
    );
    localDB.close();
  }

  Future<void> insertTaskListDataOnHeader(
      int headerID, List<int> taskIdList) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    final jsonList = jsonEncode(taskIdList);

    await localDB.update(
      'headers',
      {'taskIDs': jsonList},
      where: 'headerId = ?',
      whereArgs: [headerID],
    );
    print('Updated header tasklist at id: $headerID');
    print('Task order by id:');
    for (var task in taskIdList) {
      print(task);
    }
    localDB.close();
  }

  Future<List<int>> getHeaderListDataFromBoard() async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    final List<Map<String, dynamic>> result = await localDB.query('boards');
    if (result.isNotEmpty) {
      final jsonList = result[0]['headerIDs'] as String;
      final decodedList = jsonDecode(jsonList) as List<dynamic>;
      final headerIdList = decodedList.cast<int>();

      localDB.close();
      return headerIdList;
    } else {
      localDB.close();
      return [];
    }
  }

  Future<List<int>> getTaskListDataFromHeader(int headerID) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    print('header ID: $headerID');
    final List<Map<String, dynamic>> result = await localDB
        .rawQuery('SELECT taskId FROM tasks WHERE headerId = ?', [headerID]);
    //print('query returns: ${result[0].entries}');
    if (result.isNotEmpty) {
      print(result[0]);
      List<int> list = [];
      for (var task in result) {
        print('task.values ${task.values}');
        list.add(task.values.first as int);
      }
      //final decodedList = jsonDecode(jsonList) as List<dynamic>;
      final taskIdList = list;

      print('Task id order:');
      for (var task in taskIdList) {
        print(task);
      }

      localDB.close();
      return taskIdList;
    } else {
      print('Query returned empty');
      localDB.close();
      return [];
    }
  }

  void insertOnBoardsDB(BoardDataStructure object) async {
    print('Executing SQL Insertion...');
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    await localDB.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO boards(id, name, description, creationDate, lastUpdate, headerIDs) VALUES(?, ?, ?, ?, ?, ?)',
          [
            object.id,
            object.name,
            object.description,
            object.creationDate.toString(),
            object.lastUpdate.toString(),
            object.headerIdList.toString(),
          ]);
      print('Inserted: [${object.id}, ${object.name}] -> Boards');
    });
    localDB.close();
  }

  void insertOnFavsDB(BoardDataStructure object) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    await localDB.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO favoriteBoards(id, name, description, creationDate, lastUpdate) VALUES(?, ?, ?, ?, ?)',
          [
            object.id,
            object.name,
            object.description,
            object.creationDate.toString(),
            object.lastUpdate.toString()
          ]);
      print('inserted: [${object.id}, ${object.name}] -> Favorite Boards');
    });
    localDB.close();
  }

  void insertOnHeadersDB(HeaderStructure object) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    await localDB.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO headers(headerId, headerName, parentBoardID) VALUES(?, ?, ?)',
          [object.id, object.name, object.parentBoardID]);
      print(
          'inserted: ["${object.id}", "${object.name}"] -> [${object.parentBoardID}, ${boards[findIndexByID(boards, object.parentBoardID)].name}]');
    });
    int parentIndex = findIndexByID(boards, object.parentBoardID);
    await insertHeaderListDataOnBoard(
        object.parentBoardID, boards[parentIndex].headerIdList);
    localDB.close();
  }

  void insertOnTasksDB(TaskStructure object) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    await localDB.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO tasks(taskId, headerID, taskName, taskDescription) VALUES(?, ?, ?, ?)',
          [
            object.id,
            object.parentHeaderID,
            object.name,
            object.taskDescription
          ]);
      print(
          'inserted: [${object.id}, ${object.name}] -> [${object.parentHeaderID}, ${headers[findIndexByID(headers, object.parentHeaderID)].name}]');
    });
    localDB.close();
  }

  Future<void> updateBoardsHeaderListData(
      int boardID, List<int> updatedHeaderIdList) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    final updatedListJson = jsonEncode(updatedHeaderIdList);

    await localDB.update(
      'boards',
      {'headerIDs': updatedListJson},
      where: 'id = ?',
      whereArgs: [boardID],
    );
    localDB.close();
  }

  void updateOnBoardsDB(BoardDataStructure object) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    await localDB.rawUpdate(
        'UPDATE boards SET name = ?, description = ?, lastUpdate = ? WHERE id = ?',
        [
          object.name,
          object.description,
          object.lastUpdate.toString(),
          object.id
        ]);
    await updateBoardsHeaderListData(object.id, object.headerIdList);
    print('updated: ${object.name}');
    localDB.close();
  }

  void updateOnFavsDB(BoardDataStructure object) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    await localDB.rawUpdate(
        'UPDATE favoriteBoards SET name = ?, description = ?, lastUpdate = ? WHERE id = ?',
        [
          object.name,
          object.description,
          object.lastUpdate.toString(),
          object.id
        ]);
    print('updated: ${object.name}');
    localDB.close();
  }

  void updateOnHeadersDB(HeaderStructure object) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    await localDB.rawUpdate(
        'UPDATE headers SET headerName = ? WHERE headerId = ?',
        [object.name, object.id]);

    await insertTaskListDataOnHeader(object.id, object.taskIdList);
    print('updated: ${object.name}');
    localDB.close();
  }

  void updateOnTasksDB(TaskStructure object) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    await localDB.rawUpdate(
        'UPDATE tasks SET taskName = ?, taskDescription = ?, headerId = ? WHERE taskId = ?',
        [
          object.name,
          object.taskDescription,
          object.parentHeaderID,
          object.id
        ]);
    print('updated: ${object.name}');
    localDB.close();
  }

  void deleteFromBoardsDB(id) async {
    deleteBoardHeaders(id);
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    await localDB.rawDelete('DELETE FROM boards WHERE id = ?', [id]);
    localDB.close();
  }

  void deleteBoardHeaders(id) async {
    for (var item in boards[findIndexByID(boards, id)].headerIdList) {
      deleteHeaderTasks(item);
    }
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    await localDB
        .rawDelete('DELETE FROM headers WHERE parentBoardId = ?', [id]);
    localDB.close();
  }

  void deleteHeaderTasks(id) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    await localDB.rawDelete('DELETE FROM tasks WHERE headerId = ?', [id]);
    localDB.close();
  }

  void deleteFromFavsDB(id) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    await localDB.rawDelete('DELETE FROM favoriteBoards WHERE id = ?', [id]);
    localDB.close();
  }

  void deleteFromHeadersDB(id) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    await localDB.rawDelete('DELETE FROM headers WHERE headerId = ?', [id]);
    localDB.close();
  }

  void deleteFromTasksDB(id) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    await localDB.rawDelete('DELETE FROM tasks WHERE taskId = ?', [id]);
    localDB.close();
  }

  Future<List<int>> getBoardsHeaderList(int boardId) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    List<int> headerList = [];

    var query = await localDB.rawQuery(
        'SELECT headerId FROM headers WHERE parentBoardId = ?', [boardId]);

    for (var header in query) {
      headerList.add(header.values.elementAt(0) as int);
    }

    localDB.close();
    return headerList;
  }

  Future<List<int>> getHeadersTaskList(int headerId) async {
    final Database localDB = await openDatabase(
        join(await getDatabasesPath(), 'local_boards_db.db'));
    List<int> taskList = [];

    var query = await localDB
        .rawQuery('SELECT taskId FROM tasks WHERE headerId = ?', [headerId]);

    for (var task in query) {
      taskList.add(task.values.elementAt(0) as int);
    }

    localDB.close();
    return taskList;
  }

  int findIndexByElement(List<dynamic> list, String elementToFind) {
    if (list.isEmpty) {
      print("At FindIndexByElement(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].name == elementToFind ||
          list[i].description == elementToFind) {
        return i;
      }
    }
    print("At FindIndexByElement(): Element not found; returning index (-1)");
    return -1;
  }

  int findIndexByID(List<dynamic> list, int id) {
    if (list.isEmpty) {
      print("At FindIndexByID(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].id == id) {
        return i;
      }
    }
    print("At FindIndexByElement(): Element not found; returning index (-1)");
    return -1;
  }

  int findIndexByIDIntList(List<int> list, int id) {
    if (list.isEmpty) {
      print("At FindIndexByID(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i] == id) {
        return i;
      }
    }
    print("At FindIndexByElement(): Element not found; returning index (-1)");
    return -1;
  }

  void printAllElements(List<dynamic> list) {
    for (var board in list) {
      print('All Elements on $list: [${board.id}, ${board.name}]');
    }
  }

  bool containsElement(List<dynamic> list, elementToCheck) {
    for (var board in list) {
      if (board.id == elementToCheck ||
          board.name == elementToCheck ||
          board.description == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool containsHeader(List<dynamic> list, elementToCheck) {
    for (var header in list) {
      if (header.id == elementToCheck || header.name == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool containsTask(List<dynamic> list, elementToCheck) {
    for (var header in list) {
      if (header.id == elementToCheck || header.name == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool isElementUnique(elementToCheck) {
    int count = 0;

    for (var board in boards) {
      if (board.id == elementToCheck) {
        count++;
      }
      if (board.name == elementToCheck) {
        count++;
      }
      if (board.description == elementToCheck) {
        count++;
      }
      if (count > 1) {
        print("At isElementUnique(): Element is not unique.");
        return false;
      }
    }
    print("At isElementUnique(): Element is unique.");
    return count == 1;
  }

  int getSequentialID(List<dynamic> list, int id) {
    if (containsElement(list, id)) {
      id = id + 1;
      return getSequentialID(list, id);
    }

    print('At getSequentialID: New board ID is $id');
    return id;
  }

  int getSequentialHeaderID(List<dynamic> list, int id) {
    if (containsHeader(list, id)) {
      id = id + 1;
      return getSequentialHeaderID(list, id);
    }

    print('At getSequentialHeaderID: New header ID is $id');
    return id;
  }

  int getSequentialTaskID(List<dynamic> list, int id) {
    if (containsTask(list, id)) {
      id = id + 1;
      return getSequentialTaskID(list, id);
    }

    print('At getSequentialTaskID: New task ID is $id');
    return id;
  }

  int getRandomID(List<dynamic> list) {
    var id = Random().nextInt(99999);

    if (containsElement(boards, id)) {
      return getRandomID(list);
    }

    print('At getRandomID: New board ID is $id');
    return id;
  }

  void addBoard(String name, String description) {
    boards.add(BoardDataStructure(
        id: getSequentialID(boards, 1),
        name: name,
        description: description,
        creationDate: DateTime.now(),
        lastUpdate: DateTime.now(),
        headerIdList: []));
    var boardIndex = findIndexByElement(boards, name);
    print('Found new index: $boardIndex');
    insertOnBoardsDB(boards[boardIndex]);
    print('At addBoard(): boards list -> ');
    printAllElements(boards);
    notifyListeners();
  }

  void deleteBoard(int id) {
    var boardIndex = findIndexByID(boards, id);
    var favsIndex = findIndexByID(favoriteBoards, id);
    print('board index is $boardIndex');
    print('favoriteBoard index is $favsIndex');
    printAllElements(boards);
    print(
        'Element to be deleted: [${boards[boardIndex].id}, ${boards[boardIndex].name}]');
    deleteFromBoardsDB(id);
    boards.removeAt(boardIndex);
    if (favsIndex >= 0) {
      deleteFromFavsDB(favoriteBoards[favsIndex].id);
      favoriteBoards.removeAt(favsIndex);
    }
    notifyListeners();
  }

  void updateBoard(boardID, newBoardName, newBoardDescription) {
    var boardIndex = findIndexByID(boards, boardID);
    print("Board index: $boardIndex");
    var favsIndex = findIndexByID(favoriteBoards, boardID);
    print("Favorite index: $boardIndex");
    var lastUpdate = DateTime.now();
    if (boardIndex >= 0 && boardIndex < boards.length) {
      boards[boardIndex] = BoardDataStructure(
          id: boardID,
          name: newBoardName,
          description: newBoardDescription,
          creationDate: boards[boardIndex].creationDate,
          lastUpdate: lastUpdate,
          headerIdList: boards[boardIndex].headerIdList);
      updateOnBoardsDB(boards[boardIndex]);
    }
    if (favsIndex != -1 && containsElement(favoriteBoards, boardID)) {
      favoriteBoards[favsIndex] = boards[boardIndex];
      updateOnFavsDB(boards[boardIndex]);
    }
    notifyListeners();
  }

  void toggleFavBoard(boardID) {
    var boardIndex = findIndexByID(boards, boardID);
    var favIndex = findIndexByID(favoriteBoards, boardID);
    if (!containsElement(favoriteBoards, boardID)) {
      favoriteBoards.add(boards[boardIndex]);
      insertOnFavsDB(boards[boardIndex]);
    } else {
      favoriteBoards.removeAt(favIndex);
      deleteFromFavsDB(boardID);
    }
    notifyListeners();
  }

  void pushHeaderIntoList(String headerName, int parentBoardID) {
    var headerID = getSequentialHeaderID(headers, 0);
    List<int> taskIdList = [];
    var newHeader = (HeaderStructure(
        id: headerID,
        name: headerName,
        parentBoardID: parentBoardID,
        taskIdList: taskIdList));
    headers.add(newHeader);
    int parentIndex = findIndexByID(boards, parentBoardID);
    boards[parentIndex].headerIdList.add(headerID);
    if (findIndexByID(headers, headerID) != -1) {
      insertOnHeadersDB(newHeader);
      print('Inserted new header into headers table');
    }
    for (var i = 0; i < headers.length; i++) {
      print('[${headers[i].id}, ${headers[i].name}]');
    }
  }

  void updateHeaderAt(int headerID, String newName) {
    int index = findIndexByID(headers, headerID);
    var newHeader = HeaderStructure(
        id: headers[index].id,
        name: newName,
        parentBoardID: headers[index].parentBoardID,
        taskIdList: headers[index].taskIdList);
    headers[index] = newHeader;
    updateOnHeadersDB(newHeader);
    print('Updated Header: [${headers[index].id}, ${headers[index].name}]');
    print('Headers list:');
    for (var i = 0; i < headers.length; i++) {
      print("[${headers[i].id}, ${headers[i].name}]");
    }
  }

  void updateTaskAt(int taskID, String newName, String newDescription) {
    int index = findIndexByID(tasks, taskID);
    var newTask = TaskStructure(
        id: tasks[index].id,
        parentHeaderID: headers[index].parentBoardID,
        name: newName,
        taskDescription: newDescription);
    tasks[index] = newTask;
    updateOnTasksDB(newTask);
    print('Updated Task: [${tasks[index].id}, ${tasks[index].name}]');
    print('Tasks list:');
    for (var i = 0; i < tasks.length; i++) {
      print("[${tasks[i].id}, ${tasks[i].name}]");
    }
  }

  void pushItemIntoList(
      int headerIndex, int taskID, String taskName, String taskDescription) {
    var newTask = (TaskStructure(
        id: taskID,
        parentHeaderID: headers[headerIndex].id,
        name: taskName,
        taskDescription: taskDescription));
    tasks.add(newTask);
    headers[headerIndex].taskIdList.add(taskID);
    updateOnHeadersDB(headers[headerIndex]);
    insertOnTasksDB(newTask);
  }

  void reorderHeader(int headerId, int parentId, int newIndex) {
    var parentIndex = findIndexByID(boards, parentId);

    boards[parentIndex].headerIdList.insert(newIndex, headerId);
    boards[parentIndex].headerIdList.removeAt(
        findIndexByIDIntList(headers[parentIndex].taskIdList, headerId));
  }

  void removeHeader(int headerID) {
    int index = findIndexByID(headers, headerID);
    var removedHeader = headers.removeAt(index);
    deleteFromHeadersDB(headerID);
    print('Removed Header: [${removedHeader.id}, ${removedHeader.name}]');
    print('Headers list:');
    for (var i = 0; i < headers.length; i++) {
      print("[${headers[i].id}, ${headers[i].name}]");
    }
  }

  void reorderTask(int taskId, int oldParentId, int newParentId, int oldIndex,
      int newIndex) {
    var newParentIndex = findIndexByID(headers, newParentId);
    var oldParentIndex = findIndexByID(headers, oldParentId);

    headers[newParentIndex].taskIdList.insert(newIndex, taskId);
    headers[oldParentIndex].taskIdList.removeAt(
        findIndexByIDIntList(headers[oldParentIndex].taskIdList, taskId));
    insertTaskListDataOnHeader(oldParentId, headers[oldParentIndex].taskIdList);
    insertTaskListDataOnHeader(newParentId, headers[newParentIndex].taskIdList);
  }

  void removeTask(int taskId) {
    var taskIndex = findIndexByID(tasks, taskId);
    tasks.removeAt(taskIndex);
    deleteFromTasksDB(taskId);
  }
}
