import 'package:flutter/material.dart';
import 'package:kanban_flt/config.dart';
import 'package:kanban_flt/update_board_form.dart';
import 'package:provider/provider.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen(
      {super.key, required this.boardName, required this.boardDescription});

  final String boardName;
  final String boardDescription;

  @override
  BoardScreenState createState() => BoardScreenState();
}

class BoardScreenState extends State<BoardScreen> {
  var _bookmarkSwitch;

  Icon bookmarkIconSwitch() {
    switch (_bookmarkSwitch) {
      case true:
        return Icon(Icons.bookmark_sharp);
      case false:
        return Icon(Icons.bookmark_border_sharp);
    }
    return Icon(Icons.bookmark_sharp);
  }

  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();

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
                  configState.deleteBoard(widget.boardName);
                  if (!configState.containsElement(widget.boardName)) {
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
      if (configState.favoriteBoardsList.contains(widget.boardName)) {
        _bookmarkSwitch = true;
      } else {
        _bookmarkSwitch = false;
      }
    }

    checkBookmarkState();

    return Scaffold(
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
                      configState.toggleFavBoard(widget.boardName);
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
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('This is a board called:'),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child:
                        Text(widget.boardName, style: TextStyle(fontSize: 30)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(widget.boardDescription),
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
