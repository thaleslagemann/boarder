import 'package:flutter/material.dart';
import 'package:kanban_flt/config.dart';
import 'package:kanban_flt/test_page.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage({super.key});

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
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
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_sharp,
                      size: 24,
                    ),
                    Text(
                      ' Bookmarks',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
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
                  Icons.bookmark_sharp,
                  size: 24,
                ),
                Text(
                  ' Bookmarks',
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
                for (var board in configState.favoriteBoards)
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TestScreen()),
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
