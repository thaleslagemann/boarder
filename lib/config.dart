library config.globals;
import 'package:flutter/material.dart';
import 'package:kanban_flt/themes.dart';

MyTheme globalAppTheme = MyTheme();

class BoardDataStructure {
  String name;
  String description;

  BoardDataStructure(this.name, this.description);
}

class ConfigState extends ChangeNotifier {
  List<BoardDataStructure> boards = [];
  List<BoardDataStructure> favoriteBoards = [];

  int findIndexByElement(List<BoardDataStructure> list, String elementToFind) {
    if (list.isEmpty) {
      print("Line 20@lib/config.dart: on FindIndexByElement(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].name == elementToFind ||
          list[i].description == elementToFind) {
        return i;
      }
    }
    print("Line 29@lib/config.dart: on FindIndexByElement(): Element not found; returning index (-1)");
    return -1;
  }

  void printAllElements(List<BoardDataStructure> list) {
    for (var pair in list) {
      print([pair.name, pair.description]);
    }
  }

  bool containsElement(List<BoardDataStructure> list, String elementToCheck) {
    for (var board in list) {
      if (board.name == elementToCheck || board.description == elementToCheck) {
        return true;
      }
    }
    return false; // Element not found in any pair
  }

  bool isElementUnique(String elementToCheck) {
    int count = 0;

    for (var board in boards) {
      if (board.name == elementToCheck) {
        count++;
      }
      if (board.description == elementToCheck) {
        count++;
      }
      // If count is greater than 1, element is not unique
      if (count > 1) {
        print("Line 60@lib/config.dart: At isElementUnique(): Element is not unique.");
        return false;
      }
    }
    print("Line 64@lib/config.dart: At isElementUnique(): Element is unique.");
    return count == 1; // Element is unique if count is exactly 1
  }

  addBoard(value1, value2) {
    boards.add(BoardDataStructure(value1, value2));
    print('Line 70@lib/config.dart: At addBoard(): boards list -> $boards');
    notifyListeners();
  }

  deleteBoard(value) {
    var boardIndex = findIndexByElement(boards, value);
    var favsIndex = findIndexByElement(favoriteBoards, value);
    boards.removeAt(boardIndex);
    if (favoriteBoards.contains(value)) favoriteBoards.removeAt(favsIndex);
    notifyListeners();
  }

  updateBoard(boardName, newBoardName, newBoardDescription) {
    var boardsIndex = findIndexByElement(boards, boardName);
    var favsIndex = findIndexByElement(favoriteBoards, boardName);
    if (boardsIndex >= 0 && boardsIndex < boards.length) {
      boards[boardsIndex].name = newBoardName;
      boards[boardsIndex].description = newBoardDescription;
    }
    if (containsElement(favoriteBoards, boardName)) {
      favoriteBoards[favsIndex] = boards[boardsIndex];
    }
    notifyListeners();
  }

  toggleFavBoard(boardName) {
    var boardIndex = findIndexByElement(boards, boardName);
    var favIndex = findIndexByElement(favoriteBoards, boardName);
    print(boardIndex);
    print(favIndex);
    print(boardName);
    print(containsElement(favoriteBoards, boardName));
    printAllElements(favoriteBoards);
    if (!containsElement(favoriteBoards, boardName)) {
      favoriteBoards.add(boards[boardIndex]);
      print(favoriteBoards);
    } else {
      favoriteBoards.removeAt(favIndex);
      print(favoriteBoards);
    }
    notifyListeners();
  }

  doSomething() {
    print('Line 114@lib/config.dart: Doing something.');
  }

  // Widget build(BuildContext context) {
  //   var themeState = context.watch<AppState>();

  // }
}
