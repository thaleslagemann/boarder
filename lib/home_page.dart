import 'package:flutter/material.dart';
import 'package:kanban_flt/boards_page.dart';
import 'package:kanban_flt/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = BoardsPage();
        break;
      case 1:
        page = SettingsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                selectedIconTheme: IconThemeData(
                  color: Colors.white,
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.splitscreen_outlined),
                    label: Text('Boards'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings_outlined),
                    label: Text('Settings'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surface,
                body: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
