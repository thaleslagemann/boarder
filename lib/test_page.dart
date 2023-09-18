// ignore_for_file: unused_field
import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/custom/board.dart';
import 'package:kanban_board/models/inputs.dart';
import 'package:kanban_flt/config.dart';
import 'package:kanban_flt/update_board_form.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatefulWidget {
  const TestScreen(
      {super.key,
      required this.boardID,
      required this.boardName,
      required this.boardDescription});

  final int boardID;
  final String boardName;
  final String boardDescription;

  @override
  TestScreenState createState() => TestScreenState();
}

class TestScreenState extends State<TestScreen> {
  late bool _bookmarkSwitch;

  Icon bookmarkIconSwitch() {
    switch (_bookmarkSwitch) {
      case true:
        return Icon(Icons.bookmark_sharp);
      case false:
        return Icon(Icons.bookmark_border_sharp);
    }
    return Icon(Icons.bookmark_sharp);
  }

  List<BoardListsData> _lists = <BoardListsData>[];
  List<Widget> items = <Widget>[];

  addNewItem() {
    //items.add(Text('Test Widget'));
  }

  @override
  void initState() {
    final group1 = AppFlowyGroupData(id: "To Do", name: "a", items: [
      TextItem("Card 1"),
      TextItem("Card 2"),
    ]);
    final group2 = AppFlowyGroupData(id: "To Do", name: "b", items: [
      TextItem("Card 1"),
      TextItem("Card 2"),
    ]);
    final group3 = AppFlowyGroupData(id: "To Do", name: "c", items: [
      TextItem("Card 1"),
      TextItem("Card 2"),
    ]);

    controller.addGroup(group1);
    controller.addGroup(group2);
    controller.addGroup(group3);

    super.initState();
  }

  final AppFlowyBoardController controller = AppFlowyBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move item from $fromIndex to $toIndex');
    },
    onMoveGroupItem: (groupId, fromIndex, toIndex) {
      debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
    },
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
    },
  );

  addNewList(String _newListTitle) {
    _lists.add(BoardListsData(
      title: _newListTitle,
      width: 300,
      headerBackgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      footerBackgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      items: items,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();
    addNewList('To do');
    addNewList('In progress');
    addNewList('Done');
    addNewList('Testing');

    showAlert(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete the board?'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  configState.deleteBoard(widget.boardID);
                  if (!configState.containsElement(
                      configState.boards, widget.boardID)) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Board deleted')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('An error occured on board deletion')),
                    );
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('delete'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('cancel'),
              ),
            ],
          );
        },
      );
    }

    checkBookmarkState() {
      if (configState.containsElement(
          configState.favoriteBoards, widget.boardName)) {
        _bookmarkSwitch = true;
      } else {
        _bookmarkSwitch = false;
      }
    }

    checkBookmarkState();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(alignment: Alignment.topRight, child: CloseButton()),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: bookmarkIconSwitch(),
                    onPressed: () {
                      print('Toggle bookmark was activated');
                      configState.toggleFavBoard(widget.boardID);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      if (!_bookmarkSwitch) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added bookmark')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Removed bookmark')),
                        );
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateBoardForm(
                                    boardID: widget.boardID,
                                    boardName: widget.boardName,
                                    boardDescription: widget.boardDescription,
                                  )),
                        );
                      }),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: Icon(Icons.delete_outline_sharp),
                      onPressed: () {
                        showAlert(context);
                      }),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top,
                        width: MediaQuery.of(context).size.width,
                        child: AppFlowyBoard(
                          controller: controller,
                          cardBuilder: (context, group, groupItem) {
                            final textItem = groupItem as TextItem;
                            return AppFlowyGroupCard(
                              key: ObjectKey(textItem),
                              child: Text(textItem.s),
                            );
                          },
                          groupConstraints:
                              const BoxConstraints.tightFor(width: 240),
                        )
                        // child: KanbanBoard(
                        //   _lists,
                        //   backgroundColor: Theme.of(context).colorScheme.surface,
                        //   textStyle: const TextStyle(
                        //       fontSize: 18, fontWeight: FontWeight.w500),
                        // ),
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextItem extends AppFlowyGroupItem {
  final String s;
  TextItem(this.s);

  @override
  String get id => s;
}
