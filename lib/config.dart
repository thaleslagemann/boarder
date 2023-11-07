library config.globals;

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:boarder/db_handler.dart';
import 'package:boarder/reorder_settings.dart';
import 'package:boarder/themes.dart';

MyTheme globalAppTheme = MyTheme();
ReorderSettings reorderType = ReorderSettings();

class Constants {
  static const String addTask = 'Add Task';
  static const String delete = 'Delete';
  static const String rename = 'Rename';
  static const String edit = 'Edit';
  static const String bookmark = 'Bookmark';
  static const String details = 'Details';

  static const List<String> headerChoices = <String>[
    addTask,
    rename,
    delete,
  ];
  static const List<String> taskChoices = <String>[
    rename,
    delete,
  ];
  static const List<String> boardChoices = <String>[
    details,
    edit,
    delete,
  ];
  static const List<String> boardListChoices = <String>[
    bookmark,
    edit,
    delete,
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
        databaseHelper.boards[findBoardIndexByID(board.boardId)].headers = await databaseHelper.getHeadersForBoard(board.boardId);
        for (var header in board.headers) {
          print("Header found: [${header.headerId}, ${header.name}]");
          databaseHelper.addHeader(header);
        }
        if (board.headers.isEmpty) {
          print('No headers found!');
        } else {
          for (var header in board.headers) {
            print("Searching tasks for header [${header.name}]...");
            header.tasks = await databaseHelper.getTasksForHeader(header.headerId);
            int orderIndex = 0;
            for (var task in header.tasks) {
              task.orderIndex = orderIndex;
              orderIndex++;
            }
            for (var task in header.tasks) {
              print("Task found: [TASK_ID: ${task.taskId}, NAME: ${task.name}, ORDER_ID: ${task.orderIndex}]");
              databaseHelper.addTask(task);
            }
            if (header.tasks.isEmpty) {
              print('No tasks found!');
            }
          }
        }
      }
      databaseHelper.sortHeadersAndTasks();
      databaseHelper.bookmarks = await databaseHelper.getAllBookmarks();
      List<Bookmark> badBookmarks = [];
      for (var bookmark in databaseHelper.bookmarks) {
        if (!containsBoardId(bookmark.boardId)) {
          badBookmarks.add(bookmark);
        }
      }
      for (var b in badBookmarks) {
        databaseHelper.bookmarks.remove(b);
      }
      print("Boards:");
      if (databaseHelper.boards.isEmpty) {
        print("No boards found!");
      } else {
        for (var board in databaseHelper.boards) {
          print("[ID: ${board.boardId}, NAME: ${board.name}]");
        }
      }
      print("Bookmarks:");
      if (databaseHelper.bookmarks.isEmpty) {
        print("No bookmarks found!");
      } else {
        for (var bookmark in databaseHelper.bookmarks) {
          print("[BookmarkID: ${bookmark.bookmarkId}, BoardID: ${bookmark.boardId}]");
        }
      }
      printHeaders();
      printTasks();
      print('DB loaded');
      loadingDB = false;
      print('Loading DB: $loadingDB');
      notifyListeners();
    }
  }

  void printHeaders() {
    if (databaseHelper.headers.isEmpty) {
      print("No headers found!");
    } else {
      print('|======================================================|');
      print('| HEADERS:\t\t\t\t\t\t  |');
      print('|======================================================|');
      print('| HEADER_ID \tNAME    \tBOARD_ID\t ORDER_ID |');
      for (var board in databaseHelper.boards) {
        for (var header in board.headers) {
          if (header.name.length > 15) {
            print(
                "| ${header.headerId.toString().padRight(8)} \t${header.name.substring(0, 12)}...\t${header.boardId.toString().padRight(12)}\t ${header.orderIndex.toString().padRight(8)} |");
          } else {
            print(
                "| ${header.headerId.toString().padRight(8)} \t${header.name.padRight(15)}\t${header.boardId.toString().padRight(12)}\t ${header.orderIndex.toString().padRight(8)} |");
          }
        }
      }
      print('|======================================================|');
    }
  }

  void printTasks() {
    if (databaseHelper.tasks.isEmpty) {
      print("No tasks found!");
    } else {
      print('|======================================================|');
      print('| TASKS:\t\t\t\t\t\t  |');
      print('|======================================================|');
      print('| TASK_ID  \tTASK_NAME    \tHEADER_ID\t ORDER_ID |');
      for (var board in databaseHelper.boards) {
        for (var header in board.headers) {
          for (var task in header.tasks) {
            if (task.name.length > 15) {
              print(
                  "| ${task.taskId.toString().padRight(8)} \t${task.name.substring(0, 12)}...\t${task.headerId.toString().padRight(10)} \t ${task.orderIndex.toString().padRight(8)} |");
            } else {
              print(
                  "| ${task.taskId.toString().padRight(8)} \t${task.name.padRight(15)}\t${task.headerId.toString().padRight(10)} \t ${task.orderIndex.toString().padRight(8)} |");
            }
          }
        }
      }
      print('|======================================================|');
    }
  }

  int findIndexByElement(List<dynamic> list, String elementToFind) {
    if (list.isEmpty) {
      print("At FindIndexByElement(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].name == elementToFind || list[i].description == elementToFind) {
        return i;
      }
    }
    print("At FindIndexByElement(): Element not found; returning index (-1)");
    return -1;
  }

  int findBoardIndexByID(int id) {
    List<dynamic> list = databaseHelper.boards;
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
    List<dynamic> list = databaseHelper.headers;
    if (list.isEmpty) {
      print("At FindHeaderIndexByID(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].headerId == id) {
        return i;
      }
    }
    print("At FindHeaderIndexByID(): Element not found; returning index (-1)");
    return -1;
  }

  int findHeaderIndexByOrderId(int id, Board board) {
    List<dynamic> list = board.headers;
    print("Searching header [$id] on board [${board.name}]");
    if (list.isEmpty) {
      print("At FindHeaderIndexByOrderId(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].orderIndex == id) {
        return i;
      }
    }
    print("At FindHeaderIndexByOrderId(): Element not found; returning index (-1)");
    return -1;
  }

  int findTaskIndexByID(int id) {
    List<dynamic> list = databaseHelper.tasks;
    if (list.isEmpty) {
      print("At FindIndexByID(): List is empty; returning index (-1)");
      return -1;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].taskId == id) {
        return i;
      }
    }
    print("At FindIndexByID(): Element not found; returning index (-1)");
    return -1;
  }

  int findTaskIndexByOrderId(int id, int listId, Board board) {
    int headerIndex = findHeaderIndexByOrderId(listId, board);
    List<dynamic> list = board.headers[headerIndex].tasks;
    print("Searching order_id [$id] on board [${board.name}] on header [${board.headers[headerIndex].name}]");

    for (var task in list) {
      print('[OrderIndex: ${task.orderIndex}, NAME: ${task.name}]');
    }
    if (list.isEmpty) {
      print("At FindTaskIndexByOrderId(): List is empty; returning index (0)");
      return 0;
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].orderIndex == id) {
        return i;
      }
    }
    print("At FindTaskIndexByOrderId(): Element not found; returning same order_id");
    return id;
  }

  void printAllElements(List<dynamic> list) {
    for (var element in list) {
      print('All Elements on $list:');
      print('[${element.id}, ${element.name}]');
    }
  }

  bool containsBoard(List<dynamic> list, elementToCheck) {
    for (var board in list) {
      if (board.boardId == elementToCheck || board.name == elementToCheck || board.description == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool containsBoardId(int elementToCheck) {
    List<Board> list = databaseHelper.boards;
    for (var board in list) {
      if (board.boardId == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool containsBookmark(List<Bookmark> list, elementToCheck) {
    for (var bookmark in list) {
      if (bookmark.boardId == elementToCheck || bookmark.bookmarkId == elementToCheck) {
        return true;
      }
    }
    return false;
  }

  bool containsHeader(List<dynamic> list, elementToCheck) {
    for (var header in list) {
      if (header.headerId == elementToCheck || header.name == elementToCheck) {
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

  int getSequentialHeaderID(int id) {
    List<dynamic> list = databaseHelper.headers;
    if (containsHeader(list, id)) {
      id = id + 1;
      return getSequentialHeaderID(id);
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
