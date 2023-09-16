import 'package:flutter/material.dart';
import 'package:kanban_flt/board_screen.dart';
import 'package:kanban_flt/config.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();

    if (configState.loadingDB) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: LoadingAnimationWidget.threeArchedCircle(
        color: Theme.of(context).colorScheme.inverseSurface,
        size: 50,
      ),
        ),
      );
    }
    
    if (configState.favoriteBoards.isEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.bookmark_sharp),
                    Text(
                      'Bookmarked Boards',
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
                  Text('You have no bookmarks yet.'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Try adding a bookmark by pressing ['),
                      Icon(Icons.bookmark_outline_sharp, size: 14),
                      Text(' bookmark button ]'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('on a board\'s screen.')],
                  )
                ],
              ),
            ),
          ],
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
              children: [
                Icon(Icons.bookmark_sharp),
                Text(
                  'Bookmarked Boards',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                for (var board in configState.favoriteBoards)
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BoardScreen(
                                  boardID: board.id,
                                  boardName: board.name,
                                  boardDescription: board.description,
                                )),
                      );
                    },
                    trailing: Icon(Icons.keyboard_arrow_right_sharp),
                    title: Text(board.name.toString()),
                    selectedColor: Theme.of(context).colorScheme.surfaceVariant,
                  ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
