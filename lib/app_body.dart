import 'package:flutter/material.dart';
import 'package:kanban_flt/boards_page.dart';
import 'package:kanban_flt/settings_page.dart';
import 'package:kanban_flt/home_page.dart';

class AppBody extends StatefulWidget {
  @override
  AppBodyState createState() => AppBodyState();
}

class AppBodyState extends State<AppBody> {
  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = BoardsPage();
        break;
      case 1:
        page = HomePage();
        break;
      case 2:
        page = SettingsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF4FC3F7)),
                accountName: Text(
                  "Admin",
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
              ),
              ListTile(
                leading: Icon(Icons.circle_notifications),
                title: Text('Test'),
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
              icon: Icon(Icons.space_dashboard_sharp),
              label: 'Boards',
            ),
            NavigationDestination(
              icon: Icon(Icons.home_sharp),
              label: 'Home',
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
