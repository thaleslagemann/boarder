// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:boarder/board_screen.dart';
import 'package:boarder/app_settings/db_handler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:boarder/app_settings/config.dart';

class BoardsPage extends StatefulWidget {
  BoardsPage({super.key});

  @override
  BoardsPageState createState() => BoardsPageState();
}

class BoardsPageState extends State<BoardsPage> {
  final TextEditingController _boardNameInputController = TextEditingController();
  final TextEditingController _boardDescInputController = TextEditingController();
  final TextEditingController _boardNameEditFieldController = TextEditingController();
  final TextEditingController _boardDescEditFieldController = TextEditingController();
  final List<String> _boardPresets = [
    'No preset',
    'Kanban',
  ];

  String? selectedPreset = 'No preset';

  String boardNewName = '';
  String boardNewDesc = '';

  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();
    List<Board> boards = configState.databaseHelper.boards;

    Future<void> _displayBoardDeletionConfirmationDialog(BuildContext context, Board board) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              title: const Text('Delete board?'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
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
                      configState.databaseHelper.deleteBoard(board);
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
    }

    Future<void> _displayBoardInputDialog(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                title: const Text('Create a new board'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                    autofocus: true,
                    controller: _boardNameInputController,
                    decoration: const InputDecoration(hintText: "Name"),
                  ),
                  TextField(
                    autofocus: true,
                    controller: _boardDescInputController,
                    decoration: const InputDecoration(hintText: "Description"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Preset", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            selectedPreset!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          items: _boardPresets
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedPreset,
                          onChanged: (String? value) {
                            setState(() => selectedPreset = value);
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            height: 40,
                            width: 100,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
                    child: const Text('cancel'),
                    onPressed: () {
                      setState(() => Navigator.pop(context));
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
                    child: const Text('ok'),
                    onPressed: () {
                      if (_boardNameInputController.text.isNotEmpty) {
                        var newBoard = Board(
                            boardId: configState.databaseHelper.boards.length,
                            name: _boardNameInputController.text,
                            description: _boardDescInputController.text,
                            creationDate: DateTime.now(),
                            lastUpdate: DateTime.now(),
                            headers: []);
                        _boardNameInputController.clear();
                        _boardDescInputController.clear();
                        setState(() {
                          configState.addBoard(newBoard);
                          configState.databaseHelper.insertBoard(newBoard);
                          if (selectedPreset == 'Kanban') {
                            configState.addKanbanPresetHeadersToBoard(configState.databaseHelper.boards[configState.findBoardIndexByID(newBoard.boardId)]);
                          }
                          boards = configState.databaseHelper.boards;
                          Navigator.pop(context);
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              );
            });
          });
    }

    Future<void> _displayBoardEditDialog(BuildContext context, Board board) async {
      _boardNameEditFieldController.text = board.name;
      _boardDescEditFieldController.text = board.description;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              title: const Text('Edit board'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        boardNewName = value;
                      });
                    },
                    autofocus: true,
                    controller: _boardNameEditFieldController,
                    decoration: const InputDecoration(hintText: "Board name"),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        boardNewDesc = value;
                      });
                    },
                    autofocus: true,
                    controller: _boardDescEditFieldController,
                    decoration: const InputDecoration(hintText: "Board description"),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
                  child: const Text('cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
                  child: const Text('ok'),
                  onPressed: () {
                    setState(() {
                      boardNewName = _boardNameEditFieldController.text;
                      boardNewDesc = _boardDescEditFieldController.text;
                      print(boardNewName);
                      print(boardNewDesc);
                      configState.databaseHelper.updateBoard(Board(
                          boardId: board.boardId, name: boardNewName, description: boardNewDesc, creationDate: board.creationDate, lastUpdate: DateTime.now()));
                      Navigator.pop(context);
                      boardNewName = '';
                      boardNewDesc = '';
                      _boardNameEditFieldController.clear();
                      _boardDescEditFieldController.clear();
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
      if (configState.containsBookmark(configState.databaseHelper.bookmarks, boardID)) {
        print('Removing bookmark $boardID');
        configState.databaseHelper.deleteBookmark(boardID);
      } else {
        print('Adding bookmark $boardID');
        configState.databaseHelper.createBookmark(Bookmark(bookmarkId: boardID, boardId: boardID));
      }
    }

    IconData bookmarkIconSwitch(bookmarkId) {
      switch (configState.containsBookmark(configState.databaseHelper.bookmarks, bookmarkId)) {
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

    boardChoiceAction(String choice, Board board) {
      if (choice == Constants.delete) {
        print('Removing board');
        _displayBoardDeletionConfirmationDialog(context, board);
      } else if (choice == Constants.edit) {
        _displayBoardEditDialog(context, board);
      } else if (choice == Constants.bookmark) {
        print('Toggle bookmark was activated');
        toggleBookmark(board.boardId);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (!configState.containsBookmark(configState.databaseHelper.bookmarks, board.boardId)) {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.threeArchedCircle(
                color: Theme.of(context).colorScheme.primary,
                size: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Loading',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              )
            ],
          ),
        ),
      );
    } else if (configState.databaseHelper.boards.isEmpty) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('You have no boards yet.'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Try adding a new board by pressing the ['),
                        Icon(Icons.add_circle_outline_sharp, size: 14, color: Theme.of(context).colorScheme.primary),
                        Text.rich(TextSpan(text: ' add button', style: TextStyle(color: Theme.of(context).colorScheme.primary), children: [
                          TextSpan(
                            text: '].',
                            style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                          )
                        ])),
                      ],
                    )
                  ],
                ),
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Stack(children: [
          ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: 20),
              if (configState.databaseHelper.bookmarks.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
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
                if (configState.containsBookmark(configState.databaseHelper.bookmarks, board.boardId))
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      tileColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.primary), borderRadius: BorderRadius.circular(10)),
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
                          return Constants.boardListChoices.map((String choice) {
                            return PopupMenuItem<String>(
                                value: choice,
                                child: Row(
                                  children: [
                                    Icon(choiceIcon(choice, board.boardId)),
                                    Text(' $choice'),
                                  ],
                                ),
                                onTap: () => setState(() {
                                      boardChoiceAction(choice, board);
                                    }));
                          }).toList();
                        },
                      ),
                      title: Text(board.name),
                      selectedColor: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                  ),
              if (configState.databaseHelper.bookmarks.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
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
              for (var board in boards)
                if (!configState.containsBookmark(configState.databaseHelper.bookmarks, board.boardId))
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      tileColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.primary), borderRadius: BorderRadius.circular(10)),
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
                          return Constants.boardListChoices.map((String choice) {
                            return PopupMenuItem<String>(
                                value: choice,
                                child: Row(
                                  children: [
                                    Icon(choiceIcon(choice, board.boardId)),
                                    Text(' $choice'),
                                  ],
                                ),
                                onTap: () => setState(() {
                                      boardChoiceAction(choice, board);
                                    }));
                          }).toList();
                        },
                      ),
                      title: Text(board.name),
                      selectedColor: Theme.of(context).colorScheme.surfaceVariant,
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
