import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:kanban_flt/boards_page.dart';
import 'package:kanban_flt/config.dart';
import 'package:kanban_flt/favorites_page.dart';
import 'package:kanban_flt/settings_page.dart';
import 'package:kanban_flt/home_page.dart';
import 'package:provider/provider.dart';

class AppBody extends StatefulWidget {
  @override
  AppBodyState createState() => AppBodyState();
}

class AppBodyState extends State<AppBody> {
  var selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomePage(); //TestScreen();
        break;
      case 1:
        page = BoardsPage();
        break;
      case 2:
        page = HomePage();
        break;
      case 3:
        page = FavoritesPage();
        break;
      case 4:
        page = SettingsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      var configState = context.watch<ConfigState>();
      configState.loadDB();
      return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF4FC3F7)),
                accountName: Text(
                  "name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  "admin@email.com",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentAccountPicture: FlutterLogo(),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute<ProfileScreen>(
                      builder: (context) => ProfileScreen(
                        appBar: AppBar(
                          title: const Text('User Profile'),
                        ),
                        actions: [
                          SignedOutAction((context) {
                            Navigator.of(context).pop();
                          })
                        ],
                        children: [
                          const Divider(),
                        ],
                      ),
                    ),
                  )
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          indicatorColor: Color(0xFF4FC3F7),
          selectedIndex: selectedIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.terminal_sharp),
              label: 'Test',
            ),
            NavigationDestination(
              icon: Icon(Icons.space_dashboard_sharp),
              label: 'Boards',
            ),
            NavigationDestination(
              icon: Icon(Icons.home_sharp),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmarks_sharp),
              label: 'Bookmarks',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_sharp),
              label: 'Settings',
            ),
          ],
        ),
        body: Container(
          child: page,
        ),
      );
    });
  }
}
