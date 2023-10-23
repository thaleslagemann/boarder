// ignore_for_file: constant_identifier_names

library config.globals;

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kanban_flt/db_handler.dart';
import 'package:kanban_flt/themes.dart';

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
    Edit,
    Delete,
  ];
  static const List<String> boardListChoices = <String>[
    Bookmark,
    Delete,
  ];
}

class ConfigState extends ChangeNotifier {
  bool loadingDB = true;

  final databaseHelper = DatabaseHelper.instance;

  void loadDB() async {
    if (loadingDB) {
      print('Loading DB: $loadingDB');
      await databaseHelper.initializeDatabase();
      databaseHelper.boards = await databaseHelper.getAllBoards();
      for (var board in databaseHelper.boards) {
        print("Searching headers for board [${board.name}]...");
        databaseHelper
            .boards[findBoardIndexByID(databaseHelper.boards, board.boardId)]
            .headers = await databaseHelper.getHeadersForBoard(board.boardId);
        for (var head in board.headers) {
          print("Header found: [${head.headerId}, ${head.name}]");
          databaseHelper.addHeader(head);
        }
        if (board.headers.isEmpty) {
          print('No headers found!');
        }
        for (var header in board.headers) {
          print("Searching tasks for header [${header.name}]...");
          databaseHelper
              .boards[findBoardIndexByID(databaseHelper.boards, board.boardId)]
              .headers[
                  findHeaderIndexByID(databaseHelper.headers, header.headerId)]
              .tasks = await databaseHelper.getTasksForHeader(header.headerId);
          for (var task in header.tasks) {
            print(
                "Task found: [ID: ${task.taskId}, NAME: ${task.name}, ORDER_ID: ${task.orderIndex}]");
            databaseHelper.addTask(task);
          }
          if (header.tasks.isEmpty) {
            print('No tasks found!');
          }
        }
      }
      databaseHelper.bookmarks = await databaseHelper.getAllBookmarks();
      print("Boards:");
      for (var board in databaseHelper.boards) {
        print("[ID: ${board.boardId}, NAME: ${board.name}]");
      }
      print("Bookmarks:");
      for (var bookmark in databaseHelper.bookmarks) {
        print(
            "[BookmarkID: ${bookmark.bookmarkId}, BoardID: ${bookmark.boardId}]");
      }
      print("Headers:");
      for (var header in databaseHelper.headers) {
        print("[ID: ${header.headerId}, NAME: ${header.name}]");
      }
      print("Tasks:");
      for (var task in databaseHelper.tasks) {
        print(
            "[ID: ${task.taskId}, NAME: ${task.name}, ORDER_ID: ${task.orderIndex}]");
      }
      print('DB loaded');
      loadingDB = false;
      print('Loading DB: $loadingDB');
      notifyListeners();
    }
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

  int findBoardIndexByID(List<dynamic> list, int id) {
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

  int findHeaderIndexByID(List<dynamic> list, int id) {
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

  int findTaskIndexByID(List<dynamic> list, int id) {
    if (list.isEmpty) {
      print("At FindIndexByID(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].taskId == id) {
        return i;
      }
    }
    print("At FindIndexByElement(): Element not found; returning index (-1)");
    return -1;
  }

  void printAllElements(List<dynamic> list) {
    for (var element in list) {
      print('All Elements on $list:');
      print('[${element.id}, ${element.name}]');
    }
  }

  bool containsBoard(List<dynamic> list, elementToCheck) {
    for (var board in list) {
      if (board.boardId == elementToCheck ||
          board.name == elementToCheck ||
          board.description == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool containsBookmark(List<Bookmark> list, elementToCheck) {
    for (var bookmark in list) {
      if (bookmark.boardId == elementToCheck ||
          bookmark.bookmarkId == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool containsHeader(List<dynamic> list, elementToCheck) {
    for (var header in list) {
      if (header.header_id == elementToCheck || header.name == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool containsTask(List<dynamic> list, elementToCheck) {
    for (var element in list) {
      if (element.taskId == elementToCheck || element.name == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool isElementUnique(elementToCheck) {
    int count = 0;

    for (var board in databaseHelper.boards) {
      if (board.boardId == elementToCheck) {
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
    if (containsBoard(list, id)) {
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
}
