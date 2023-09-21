library config.globals;

import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kanban_flt/themes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

MyTheme globalAppTheme = MyTheme();

class BoardDataStructure {
  final int id;
  final String name;
  final String description;

  const BoardDataStructure(
      {required this.id, required this.name, required this.description});
}

class ConfigState extends ChangeNotifier {
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
            'CREATE TABLE boards (id INTEGER PRIMARY KEY, name TEXT, description TEXT)');
        await db.execute(
            'CREATE TABLE favoriteBoards (id INTEGER PRIMARY KEY, name TEXT, description TEXT)');
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

  int findIndexByElement(List<BoardDataStructure> list, String elementToFind) {
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

  int findIndexByID(List<BoardDataStructure> list, int id) {
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

  void printAllElements(List<BoardDataStructure> list) {
    for (var board in list) {
      print(
          'At printAllElements(): [${board.id}, ${board.name}, ${board.description}]');
    }
  }

  bool containsElement(List<BoardDataStructure> list, elementToCheck) {
    for (var board in list) {
      if (board.id == elementToCheck ||
          board.name == elementToCheck ||
          board.description == elementToCheck) {
        return true;
      }
    }
    return false; // Element not found in any pair
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
      // If count is greater than 1, element is not unique
      if (count > 1) {
        print("At isElementUnique(): Element is not unique.");
        return false;
      }
    }
    print("At isElementUnique(): Element is unique.");
    return count == 1; // Element is unique if count is exactly 1
  }

  int getSequentialID(List<BoardDataStructure> list, int id) {
    if (containsElement(boards, id)) {
      id = id + 1;
      return getSequentialID(list, id);
    }

    print('At getSequentialID: New board ID is $id');
    return id;
  }

  int getRandomID(List<BoardDataStructure> list) {
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
    print(boardIndex);
    print(favIndex);
    print(boardID);
    print(containsElement(favoriteBoards, boardID));
    printAllElements(favoriteBoards);
    if (!containsElement(favoriteBoards, boardID)) {
      favoriteBoards.add(boards[boardIndex]);
      insertOnFavsDB(boards[boardIndex]);
      print(favoriteBoards);
    } else {
      favoriteBoards.removeAt(favIndex);
      deleteFromFavsDB(boardID);
      print(favoriteBoards);
    }
    notifyListeners();
  }
}
