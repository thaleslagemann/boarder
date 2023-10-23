import 'package:flutter/material.dart';
import 'package:kanban_flt/board_screen.dart';
import 'package:kanban_flt/db_handler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:kanban_flt/config.dart';

class BoardsPage extends StatefulWidget {
  BoardsPage({super.key});

  @override
  BoardsPageState createState() => BoardsPageState();
}

class BoardsPageState extends State<BoardsPage> {
  final TextEditingController _boardNameInputController =
      TextEditingController();
  final TextEditingController _boardDescInputController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();

    Future<void> _displayBoardDeletionConfirmationDialog(
        BuildContext context, int boardID) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete board?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('delete'),
                  onPressed: () {
                    setState(() {
                      configState.databaseHelper.deleteBoard(boardID);
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
    }

    Future<void> _displayBoardInputDialog(BuildContext context) async {
      String newBoardName;
      String newBoardDesc;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Create a new board'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      newBoardName = value;
                    });
                  },
                  autofocus: true,
                  controller: _boardNameInputController,
                  decoration: const InputDecoration(hintText: "Name"),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      newBoardName = value;
                    });
                  },
                  autofocus: true,
                  controller: _boardDescInputController,
                  decoration: const InputDecoration(hintText: "Description"),
                ),
              ]),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                TextButton(
                  child: const Text('ok'),
                  onPressed: () {
                    setState(() {
                      newBoardName = _boardNameInputController.text;
                      newBoardDesc = _boardDescInputController.text;
                      print(newBoardName);
                      var newBoard = Board(
                          boardId: configState.databaseHelper.boards.length,
                          name: newBoardName,
                          description: newBoardDesc,
                          creationDate: DateTime.now(),
                          lastUpdate: DateTime.now());
                      configState.databaseHelper.insertBoard(newBoard);
                      newBoardName = '';
                      newBoardDesc = '';
                      _boardNameInputController.clear();
                      _boardDescInputController.clear();
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
    }

    int findBookmarkIndex(int boardID) {
      int index = -1;
      for (var i = 0; i < configState.databaseHelper.bookmarks.length; i++) {
        if (configState.databaseHelper.bookmarks[i].boardId == boardID) {
          index = i;
        }
      }
      return index;
    }

    toggleBookmark(int boardID) {
      if (configState.containsBookmark(
          configState.databaseHelper.bookmarks, boardID)) {
        print('Removing bookmark $boardID');
        configState.databaseHelper.deleteBookmark(boardID);
      } else {
        print('Adding bookmark $boardID');
        configState.databaseHelper
            .createBookmark(Bookmark(bookmarkId: boardID, boardId: boardID));
      }
    }

    IconData bookmarkIconSwitch(bookmarkId) {
      switch (configState.containsBookmark(
          configState.databaseHelper.bookmarks, bookmarkId)) {
        case true:
          return Icons.bookmark_remove_rounded;
        case false:
          return Icons.bookmark_add_outlined;
        default:
          return Icons.bookmark_sharp;
      }
    }

    IconData choiceIcon(String choice, int boardID) {
      if (choice == 'Delete') {
        return Icons.delete_outline_sharp;
      } else if (choice == 'Edit') {
        return Icons.edit_outlined;
      } else if (choice == 'Bookmark') {
        return bookmarkIconSwitch(boardID);
      } else if (choice == 'Details') {
        return Icons.info_sharp;
      }
      return Icons.not_interested_outlined;
    }

    boardChoiceAction(String choice, int boardID) {
      if (choice == Constants.Delete) {
        print('Removing board');
        _displayBoardDeletionConfirmationDialog(context, boardID);
      } else if (choice == Constants.Bookmark) {
        print('Toggle bookmark was activated');
        toggleBookmark(boardID);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (!configState.containsBookmark(
            configState.databaseHelper.bookmarks, boardID)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added bookmark')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Removed bookmark')),
          );
        }
      }
    }

    if (configState.loadingDB) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            children: [
              LoadingAnimationWidget.threeArchedCircle(
                color: Theme.of(context).colorScheme.onInverseSurface,
                size: 50,
              ),
              Text('Loading...')
            ],
          ),
        ),
      );
    } else if (configState.databaseHelper.boards.isEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.space_dashboard_sharp,
                      size: 24,
                    ),
                    Text(
                      'Boards',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You have no boards yet.'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Try adding a new board by pressing the ['),
                      Icon(Icons.add_circle_outline_sharp, size: 14),
                      Text(' add button ].'),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          foregroundColor: Theme.of(context).colorScheme.surface,
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            _displayBoardInputDialog(context);
          },
          child: Icon(Icons.add),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Stack(children: [
          ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: 20),
              if (configState.databaseHelper.bookmarks.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.bookmarks,
                        size: 15.0,
                      ),
                      Text(' Bookmarks'),
                    ],
                  ),
                ),
              for (var board in configState.databaseHelper.boards)
                if (configState.containsBookmark(
                    configState.databaseHelper.bookmarks, board.boardId))
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      tileColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(10)),
                      onTap: () => setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BoardScreen(
                                    board: board,
                                  )),
                        );
                      }),
                      trailing: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert_sharp),
                        itemBuilder: (BuildContext context) {
                          return Constants.boardListChoices
                              .map((String choice) {
                            return PopupMenuItem<String>(
                                value: choice,
                                child: Row(
                                  children: [
                                    Icon(choiceIcon(choice, board.boardId)),
                                    Text(' $choice'),
                                  ],
                                ),
                                onTap: () => setState(() {
                                      boardChoiceAction(choice, board.boardId);
                                    }));
                          }).toList();
                        },
                      ),
                      title: Text(board.name),
                      selectedColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                    ),
                  ),
              if (configState.databaseHelper.bookmarks.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.space_dashboard,
                      size: 15.0,
                    ),
                    Text(' Boards'),
                  ],
                ),
              ),
              for (var board in configState.databaseHelper.boards)
                if (!configState.containsBookmark(
                    configState.databaseHelper.bookmarks, board.boardId))
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      tileColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(10)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BoardScreen(
                                    board: board,
                                  )),
                        );
                      },
                      trailing: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert_sharp),
                        itemBuilder: (BuildContext context) {
                          return Constants.boardListChoices
                              .map((String choice) {
                            return PopupMenuItem<String>(
                                value: choice,
                                child: Row(
                                  children: [
                                    Icon(choiceIcon(choice, board.boardId)),
                                    Text(' $choice'),
                                  ],
                                ),
                                onTap: () => setState(() {
                                      boardChoiceAction(choice, board.boardId);
                                    }));
                          }).toList();
                        },
                      ),
                      title: Text(board.name),
                      selectedColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                    ),
                  ),
            ],
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          _displayBoardInputDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
