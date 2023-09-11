import 'package:flutter/material.dart';
import 'package:kanban_flt/board_screen.dart';
import 'package:provider/provider.dart';
import 'package:kanban_flt/config.dart';

class BoardsPage extends StatefulWidget {
  BoardsPage({super.key});

  @override
  BoardsPageState createState() => BoardsPageState();
}

class BoardsPageState extends State<BoardsPage> {
  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();

    if (configState.boardsList.isEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Text('No boards yet.'),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          foregroundColor: Colors.lightBlue[300],
          backgroundColor: Theme.of(context).colorScheme.surface,
          onPressed: () {
            configState.addBoard();
          },
          child: Icon(Icons.add),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.space_dashboard_sharp),
                Text(
                  'Boards',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          for (var board in configState.boardsList)
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BoardScreen(boardName: board)),
                );
              },
              trailing: Icon(Icons.keyboard_arrow_right_sharp),
              title: Text(board.toString()),
              selectedColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        foregroundColor: Colors.lightBlue[300],
        backgroundColor: Theme.of(context).colorScheme.surface,
        onPressed: () {
          // configState.addBoard();
          // Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => NewBoardForm()),
          //       );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
