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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: bookmarkIconSwitch(),
                    onPressed: () {
                      configState.toggleFavBoard(widget.boardName);
                    },
                  ),
                ),
                Align(alignment: Alignment.topRight, child: CloseButton()),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Text('This is a board called [${widget.boardName}]'),
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
