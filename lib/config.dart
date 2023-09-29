library config.globals;

import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kanban_flt/themes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

MyTheme globalAppTheme = MyTheme();

class Constants {
  static const String Delete = 'Delete';
  static const String Rename = 'Rename';
  static const String Edit = 'Edit';
  static const String Bookmark = 'Bookmark';
  static const String Details = 'Details';

  static const List<String> headerChoices = <String>[
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

  const BoardDataStructure(
      {required this.id,
      required this.name,
      required this.description,
      required this.creationDate,
      required this.lastUpdate});
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
      localDB = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // await db.execute('DROP TABLE boards');
        // await db.execute('DROP TABLE favoriteBoards');
        // await db.execute('DROP TABLE headers');
        // await db.execute('DROP TABLE tasks');
        await db.execute(
            'CREATE TABLE IF NOT EXISTS boards(id INTEGER PRIMARY KEY, name TEXT, description TEXT, creationDate TEXT, lastUpdate TEXT)');
        await db.execute(
            'CREATE TABLE IF NOT EXISTS favoriteBoards(id INTEGER PRIMARY KEY, name TEXT, description TEXT, creationDate TEXT, lastUpdate TEXT)');
        await db.execute(
            'CREATE TABLE IF NOT EXISTS headers(headerId INTEGER PRIMARY KEY, headerName TEXT, parentBoardId INTEGER)');
        await db.execute(
            'CREATE TABLE IF NOT EXISTS tasks(taskId INTEGER PRIMARY KEY, taskName TEXT, taskDescription TEXT, headerId INTEGER)');
      });
      // await localDB.execute('DELETE FROM favoriteBoards');
      // await localDB.execute('DELETE FROM boards');
      // await localDB.execute('DELETE FROM headers');
      // await localDB.execute('DELETE FROM tasks');
      List<Map> boards = await localDB.rawQuery('SELECT * FROM boards');
      convertRawQueryToBoard(boards);
      List<Map> favoriteBoards =
          await localDB.rawQuery('SELECT * FROM favoriteBoards');
      convertRawQueryToFavBoard(favoriteBoards);
      List<Map> headers = await localDB.rawQuery('SELECT * FROM headers');
      convertRawQueryToHeader(headers);
      List<Map> tasks = await localDB.rawQuery('SELECT * FROM tasks');
      convertRawQueryToTask(tasks);
      print('Boards $boards');
      print('FavoriteBoards: $favoriteBoards');
      print('Headers: $headers');
      print('Tasks: $tasks');
      print('DB loaded');
      loadingDB = false;
      print('Loading DB: $loadingDB');
      notifyListeners();
    }
  }

  void convertRawQueryToBoard(List<Map> rawQuery) {
    for (var i = 0; i < rawQuery.length; i++) {
      print(rawQuery[i].values);
      int id = rawQuery[i].values.elementAt(0);
      String name = rawQuery[i].values.elementAt(1).toString();
      String description = rawQuery[i].values.elementAt(2).toString();
      DateTime creationDate = rawQuery[i].values.elementAt(3).cast<DateTime>();
      DateTime lastUpdate = rawQuery[i].values.elementAt(4).cast<DateTime>();

      BoardDataStructure board = BoardDataStructure(
          id: id,
          name: name,
          description: description,
          creationDate: creationDate,
          lastUpdate: lastUpdate);

      if (!containsElement(boards, board)) {
        boards.add(board);
      }
      print('On Convert Board Statement: [${board.id},${board.name}]');
    }
  }

  void convertRawQueryToFavBoard(List<Map> rawQuery) {
    for (var i = 0; i < rawQuery.length; i++) {
      int id = rawQuery[i].values.elementAt(0);
      String name = rawQuery[i].values.elementAt(1).toString();
      String description = rawQuery[i].values.elementAt(2).toString();
      DateTime creationDate = rawQuery[i].values.elementAt(3).cast<DateTime>();
      DateTime lastUpdate = rawQuery[i].values.elementAt(4).cast<DateTime>();

      BoardDataStructure board = BoardDataStructure(
          id: id,
          name: name,
          description: description,
          creationDate: creationDate,
          lastUpdate: lastUpdate);

      if (!containsElement(favoriteBoards, board)) {
        favoriteBoards.add(board);
      }
      print(
          'On Convert Fav Statement: [${board.id},${board.name},${board.description}]');
    }
  }

  void convertRawQueryToHeader(List<Map> rawQuery) {
    for (var i = 0; i < rawQuery.length; i++) {
      print(rawQuery[i].values);
      int id = rawQuery[i].values.elementAt(0);
      String name = rawQuery[i].values.elementAt(1).toString();
      int parentBoardID = rawQuery[i].values.elementAt(2);

      HeaderStructure header = HeaderStructure(
        id: id,
        name: name,
        parentBoardID: parentBoardID,
        taskIdList: [],
      );

      if (!containsElement(headers, header)) {
        headers.add(header);
      }
      print('On Convert Header Statement: [${header.id},${header.name}]');
    }
  }

  void convertRawQueryToTask(List<Map> rawQuery) {
    for (var i = 0; i < rawQuery.length; i++) {
      print(rawQuery[i].values);
      int id = rawQuery[i].values.elementAt(0);
      int parentHeaderID = rawQuery[i].values.elementAt(1);
      String name = rawQuery[i].values.elementAt(2).toString();
      String taskDescription = rawQuery[i].values.elementAt(3).toString();

      TaskStructure task = TaskStructure(
        id: id,
        parentHeaderID: parentHeaderID,
        name: name,
        taskDescription: taskDescription,
      );

      if (!containsElement(tasks, task)) {
        tasks.add(task);
      }
      print('On Convert Header Statement: [${task.id},${task.name}]');
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

  void insertOnBoardsDB(BoardDataStructure object) async {
    await localDB.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO boards(name, description, creationDate, lastUpdate) VALUES("${object.name}", "${object.description}", "${object.creationDate}", "${object.lastUpdate}")');
      print(
          'inserted: [{${object.id}, ${object.name}, ${object.description}, ${object.creationDate}, ${object.lastUpdate}]');
    });
  }

  void insertOnFavsDB(BoardDataStructure object) async {
    await localDB.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO favoriteBoards(name, description, creationDate, lastUpdate) VALUES("${object.name}", "${object.description}", "${object.creationDate}", "${object.lastUpdate}")');
      print(
          'inserted: [${object.id}, ${object.name}, ${object.description}, ${object.creationDate}, ${object.lastUpdate}]');
    });
  }

  void insertOnHeadersDB(HeaderStructure object) async {
    await localDB.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO headers(id, name, parentBoardID, taskIdList) VALUES("${object.id}", "${object.name}", "${object.parentBoardID}", "${object.taskIdList}")');
      print(
          'inserted: [{"${object.id}", "${object.name}", "${object.parentBoardID}", "${object.taskIdList}"]');
    });
  }

  void insertOnTasksDB(TaskStructure object) async {
    await localDB.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO tasks(id, parentHeaderID, name, description) VALUES("${object.id}", "${object.parentHeaderID}", "${object.name}", "${object.taskDescription}")');
      print(
          'inserted: [{"${object.id}", "${object.parentHeaderID}", "${object.name}", "${object.taskDescription}"]');
    });
  }

  void updateOnBoardsDB(BoardDataStructure object) async {
    await localDB.rawUpdate(
        'UPDATE boards SET name = ?, description = ?, lastUpdate = ? WHERE id = ?',
        [object.name, object.description, object.lastUpdate, object.id]);
    print('updated: ${object.name}');
  }

  void updateOnFavsDB(BoardDataStructure object) async {
    await localDB.rawUpdate(
        'UPDATE favoriteBoards SET name = ?, description = ?, lastUpdate = ? WHERE id = ?',
        [object.name, object.description, object.lastUpdate, object.id]);
    print('updated: ${object.name}');
  }

  void updateOnHeadersDB(HeaderStructure object) async {
    await localDB.rawUpdate(
        'UPDATE headers SET name = ?, taskIdList = ? WHERE id = ?',
        [object.name, object.taskIdList, object.id]);
    print('updated: ${object.name}');
  }

  void updateOnTasksDB(TaskStructure object) async {
    await localDB.rawUpdate(
        'UPDATE tasks SET name = ?, taskDescription = ? WHERE id = ?',
        [object.name, object.taskDescription, object.id]);
    print('updated: ${object.name}');
  }

  void deleteFromBoardsDB(id) async {
    await localDB.rawDelete('DELETE FROM boards WHERE id = ?', [id]);
  }

  void deleteFromFavsDB(id) async {
    await localDB.rawDelete('DELETE FROM favoriteBoards WHERE id = ?', [id]);
  }

  void deleteFromHeadersDB(id) async {
    await localDB.rawDelete('DELETE FROM headers WHERE id = ?', [id]);
  }

  void deleteFromTasksDB(id) async {
    await localDB.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
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

  void printAllElements(List<dynamic> list) {
    for (var board in list) {
      print(
          'All Elements on $list: [${board.id}, ${board.name}, ${board.description}]');
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
        lastUpdate: DateTime.now()));
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
        'Element to be deleted: [${boards[boardIndex].id}, ${boards[boardIndex].name}, ${boards[boardIndex].description}]');
    deleteFromBoardsDB(boards[boardIndex].id);
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
          lastUpdate: lastUpdate);
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
    if (findIndexByID(headers, headerID) != -1) {
      insertOnHeadersDB(newHeader);
      print('Inserted new header into headers table');
    }
    for (var i = 0; i < headers.length; i++) {
      print('[${headers[i].id}, ${headers[i].name}]');
    }
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

  void renameHeaderAt(int headerID, String newName) {
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

  void removeTask(int taskId) {
    var taskIndex = findIndexByID(tasks, taskId);
    tasks.removeAt(taskIndex);
    deleteFromTasksDB(taskId);
  }
}
