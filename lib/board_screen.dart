import 'package:flutter/material.dart';
import 'package:kanban_flt/config.dart';
import 'package:provider/provider.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key, required this.boardName});

  final String boardName;

  @override
  BoardScreenState createState() => BoardScreenState();
}

class BoardScreenState extends State<BoardScreen> {
  var _bookmarkSwitch;
  var boardName;

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
    boardName = widget.boardName;

    showAlert(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete the board?'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.check_circle_sharp),
                onPressed: () {
                  configState.deletedBoard(boardName);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Board deleted')),
                  );
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: Icon(Icons.cancel_rounded),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    checkBookmarkState() {
      if (configState.favoriteBoardsList.contains(boardName)) {
        _bookmarkSwitch = true;
      } else {
        _bookmarkSwitch = false;
      }
    }

    checkBookmarkState();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: Icon(Icons.delete_outline_sharp),
                      onPressed: () {
                        showAlert(context);
                      }),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: bookmarkIconSwitch(),
                    onPressed: () {
                      configState.toggleFavBoard(boardName);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      if (!_bookmarkSwitch) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Board bookmarked')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Board unbookmarked')),
                        );
                      }
                    },
                  ),
                ),
                Align(alignment: Alignment.topRight, child: CloseButton()),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Text('This is a board called [$boardName]'),
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
