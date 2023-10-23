import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:kanban_flt/boards_page.dart';
import 'package:kanban_flt/config.dart';
import 'package:kanban_flt/settings_page.dart';
import 'package:kanban_flt/home_page.dart';
import 'package:provider/provider.dart';

class AppBody extends StatefulWidget {
  @override
  AppBodyState createState() => AppBodyState();
}

class AppBodyState extends State<AppBody> {
  var selectedIndex = 0;

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
              UserAccountsDrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.primary),
                accountName: Text(
                  "${FirebaseAuth.instance.currentUser?.displayName}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  "${FirebaseAuth.instance.currentUser?.email}",
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
          indicatorColor: Theme.of(context).primaryColor,
          selectedIndex: selectedIndex,
          destinations: <Widget>[
            if (selectedIndex == 0)
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
            if (selectedIndex != 0)
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
            if (selectedIndex == 1)
              NavigationDestination(
                icon: Icon(Icons.space_dashboard),
                label: 'Boards',
              ),
            if (selectedIndex != 1)
              NavigationDestination(
                icon: Icon(Icons.space_dashboard_outlined),
                label: 'Boards',
              ),
            if (selectedIndex == 2)
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            if (selectedIndex != 2)
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
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
