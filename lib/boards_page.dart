import 'package:flutter/material.dart';
import 'package:kanban_flt/board_screen.dart';
import 'package:kanban_flt/new_board_form.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
      body: SafeArea(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.space_dashboard_sharp,
                  size: 24,
                ),
                Text(
                  ' Boards',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 40),
                for (var board in configState.databaseHelper.boards)
                  ListTile(
                    tileColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1,
                            color:
                                Theme.of(context).colorScheme.inverseSurface),
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
                    trailing: Icon(Icons.more_vert_sharp),
                    title: Text(board.name),
                    selectedColor: Theme.of(context).colorScheme.surfaceVariant,
                  ),
              ],
            ),
          ),
        ]),
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
