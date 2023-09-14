import 'package:flutter/material.dart';
import 'package:kanban_flt/board_screen.dart';
import 'package:kanban_flt/new_board_form.dart';
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

    if (configState.boards.isEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.space_dashboard_sharp),
                    Text(
                      'Boards',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
          backgroundColor: Color(0xFF4FC3F7),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewBoardForm()),
            );
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
          for (var board in configState.boards)
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BoardScreen(
                            boardName: board.name,
                            boardDescription: board.description,
                          )),
                );
              },
              trailing: Icon(Icons.keyboard_arrow_right_sharp),
              title: Text(board.name),
              selectedColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Color(0xFF4FC3F7),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewBoardForm()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
