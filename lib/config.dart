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
  static const String ThirdItem = 'Third Item';

  static const List<String> choices = <String>[
    Delete,
    Rename,
    ThirdItem,
  ];
}

class BoardDataStructure {
  final int id;
  final String name;
  final String description;

  const BoardDataStructure(
      {required this.id, required this.name, required this.description});
}

class HeaderStructure {
  final int id;
  String name;
  List<int> taskIdList;

  HeaderStructure(
      {required this.id, required this.name, required this.taskIdList});
}

class TaskStructure {
  final int id;
  String name;

  TaskStructure({required this.id, required this.name});
}

class ConfigState extends ChangeNotifier {
  List<HeaderStructure> headers = [];
  List<TaskStructure> tasks = [];

  List<BoardDataStructure> boards = [];
  List<BoardDataStructure> favoriteBoards = [];
  late Database localDB;
  bool loadingDB = true;

  loadDB() async {
    if (loadingDB) {
      print('Loading DB: $loadingDB');
      var databasesPath = await getDatabasesPath();
      print('databasesPath: $databasesPath');
      String path = join(databasesPath, 'local_boards_db.db');
      print('LocalDB path: $path');
      localDB = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE [IF NOT EXISTS] boards (id INTEGER PRIMARY KEY, name TEXT, description TEXT)');
        await db.execute(
            'CREATE TABLE [IF NOT EXISTS] favoriteBoards (id INTEGER PRIMARY KEY, name TEXT, description TEXT)');
        await db.execute(
            'CREATE TABLE [IF NOT EXISTS] boardHeader (headerId INTEGER PRIMARY KEY, boardId INTEGER FOREIGN KEY, headerName TEXT)');
        await db.execute(
            'CREATE TABLE [IF NOT EXISTS] headerTask (headerId INTEGER FOREIGN KEY, taskDescription TEXT)');
      });
      List<Map> boards = await localDB.rawQuery('SELECT * FROM boards');
      convertRawQueryToBoard(boards);
      print('Boards $boards');
      //await localDB.execute('DELETE FROM favoriteBoards WHERE id = 1');
      List<Map> favoriteBoards =
          await localDB.rawQuery('SELECT * FROM favoriteBoards');
      convertRawQueryToFavBoard(favoriteBoards);
      print('FavoriteBoards: $favoriteBoards');
      print('DB loaded');
      loadingDB = false;
      print('Loading DB: $loadingDB');
      notifyListeners();
    }
  }

  convertRawQueryToBoard(List<Map> rawQuery) {
    for (var i = 0; i < rawQuery.length; i++) {
      int id = rawQuery[i].values.elementAt(0);
      String name = rawQuery[i].values.elementAt(1).toString();
      String description = rawQuery[i].values.elementAt(2).toString();

      BoardDataStructure board =
          BoardDataStructure(id: id, name: name, description: description);

      if (!containsElement(boards, board)) {
        boards.add(board);
      }
      print(
          'On Convert Statement: [${board.id},${board.name},${board.description}]');
    }
  }

  convertRawQueryToFavBoard(List<Map> rawQuery) {
    for (var i = 0; i < rawQuery.length; i++) {
      int id = rawQuery[i].values.elementAt(0);
      String name = rawQuery[i].values.elementAt(1).toString();
      String description = rawQuery[i].values.elementAt(2).toString();

      BoardDataStructure board =
          BoardDataStructure(id: id, name: name, description: description);

      if (!containsElement(favoriteBoards, board)) {
        favoriteBoards.add(board);
      }
      print(
          'On Convert Statement: [${board.id},${board.name},${board.description}]');
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

  insertOnBoardsDB(BoardDataStructure object) async {
    await localDB.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO boards(name, description) VALUES("${object.name}", "${object.description}")');
      print('inserted: [{${object.id}, ${object.name}, ${object.description}]');
    });
  }

  insertOnFavsDB(BoardDataStructure object) async {
    await localDB.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO favoriteBoards(name, description) VALUES("${object.name}", "${object.description}")');
      print('inserted: [${object.id}, ${object.name}, ${object.description}]');
    });
  }

  updateOnBoardsDB(BoardDataStructure object) async {
    await localDB.rawUpdate(
        'UPDATE boards SET name = ?, description = ? WHERE id = ?',
        [object.name, object.description, object.id]);
    print('updated: ${object.name}');
  }

  updateOnFavsDB(BoardDataStructure object) async {
    await localDB.rawUpdate(
        'UPDATE favoriteBoards SET name = ?, description = ? WHERE id = ?',
        [object.name, object.description, object.id]);
    print('updated: ${object.name}');
  }

  deleteFromBoardsDB(id) async {
    await localDB.rawDelete('DELETE FROM boards WHERE id = ?', [id]);
  }

  deleteFromFavsDB(id) async {
    await localDB.rawDelete('DELETE FROM favoriteBoards WHERE id = ?', [id]);
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

  addBoard(String name, String description) {
    boards.add(BoardDataStructure(
        id: getSequentialID(boards, 1), name: name, description: description));
    var boardIndex = findIndexByElement(boards, name);
    print('Found new index: $boardIndex');
    insertOnBoardsDB(boards[boardIndex]);
    print('At addBoard(): boards list -> ');
    printAllElements(boards);
    notifyListeners();
  }

  deleteBoard(int id) {
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

  updateBoard(boardID, newBoardName, newBoardDescription) {
    var boardIndex = findIndexByID(boards, boardID);
    var favsIndex = findIndexByID(favoriteBoards, boardID);
    if (boardIndex >= 0 && boardIndex < boards.length) {
      boards[boardIndex] = BoardDataStructure(
          id: boardID, name: newBoardName, description: newBoardDescription);
      updateOnBoardsDB(boards[boardIndex]);
    }
    if (containsElement(favoriteBoards, boardID)) {
      favoriteBoards[favsIndex] = boards[boardIndex];
      updateOnFavsDB(boards[boardIndex]);
    }
    notifyListeners();
  }

  toggleFavBoard(boardID) {
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

  pushHeaderIntoList(String headerName) {
    var headerID = getSequentialHeaderID(headers, 0);
    List<int> taskIdList = [];
    headers.add(HeaderStructure(
        id: headerID, name: headerName, taskIdList: taskIdList));
    for (var i = 0; i < headers.length; i++) {
      print('[${headers[i].id}, ${headers[i].name}]');
    }
  }

  void removeHeader(int headerID) {
    int index = findIndexByID(headers, headerID);
    var removedHeader = headers.removeAt(index);
    print('Removed Header: [${removedHeader.id}, ${removedHeader.name}]');
    print('Headers list:');
    for (var i = 0; i < headers.length; i++) {
      print("[${headers[i].id}, ${headers[i].name}]");
    }
  }

  void renameHeaderAt(int headerID, String newName) {
    int index = findIndexByID(headers, headerID);
    headers[index].name = newName;
    print('Updated Header: [${headers[index].id}, ${headers[index].name}]');
    print('Headers list:');
    for (var i = 0; i < headers.length; i++) {
      print("[${headers[i].id}, ${headers[i].name}]");
    }
  }

  pushItemIntoList(int headerIndex, int taskID, String taskName) {
    tasks.add(TaskStructure(id: taskID, name: taskName));
    headers[headerIndex].taskIdList.add(taskID);
  }
}
