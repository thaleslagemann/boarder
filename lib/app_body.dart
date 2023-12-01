import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:boarder/board/boards_page.dart';
import 'package:boarder/app_settings/config.dart';
import 'package:boarder/app_settings/settings_page.dart';
import 'package:boarder/home_page.dart';
import 'package:provider/provider.dart';

class AppBody extends StatefulWidget {
  @override
  AppBodyState createState() => AppBodyState();
}

class AppBodyState extends State<AppBody> {
  var selectedIndex = 0;

  Color _randomColorPicker() {
    int randomNumber = Random().nextInt(7);

    switch (randomNumber) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.cyan;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      case 4:
        return Colors.purple[300]!;
      case 5:
        return Colors.indigo[300]!;
      case 6:
        return Colors.brown;
    }
    return Colors.white;
  }

  _currentUserPicture() {
    if (FirebaseAuth.instance.currentUser?.photoURL != null) {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
            ),
          ),
        ],
      );
    } else {
      return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.black, width: 2),
            color: _randomColorPicker(),
          ),
          child: Image(image: AssetImage('lib/assets/boar.png')));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _loading = false;
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
        throw UnimplementedError('No widget for index $selectedIndex');
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
                decoration: BoxDecoration(color: globalAppTheme.mainColorOption()),
                accountName: FirebaseAuth.instance.currentUser?.displayName != null
                    ? Text(
                        "${FirebaseAuth.instance.currentUser?.displayName}",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                      )
                    : Text(
                        "Guest",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                      ),
                accountEmail: Text(
                  "${FirebaseAuth.instance.currentUser?.email?.replaceRange(2, (FirebaseAuth.instance.currentUser?.email?.length)! - 4, '*****@*****')}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                currentAccountPicture: _currentUserPicture(),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute<ProfileScreen>(
                      builder: (context) => ProfileScreen(
                        avatarPlaceholderColor: _randomColorPicker(),
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
          indicatorColor: globalAppTheme.mainColorOption(),
          selectedIndex: selectedIndex,
          destinations: <Widget>[
            if (selectedIndex == 0)
              NavigationDestination(
                icon: Icon(
                  Icons.home,
                  color: Theme.of(context).colorScheme.surface,
                ),
                label: 'Home',
              ),
            if (selectedIndex != 0)
              NavigationDestination(
                icon: Icon(
                  Icons.home_outlined,
                  color: globalAppTheme.mainColorOption(),
                ),
                label: 'Home',
              ),
            if (selectedIndex == 1)
              NavigationDestination(
                icon: Icon(
                  Icons.space_dashboard,
                  color: Theme.of(context).colorScheme.surface,
                ),
                label: 'Boards',
              ),
            if (selectedIndex != 1)
              NavigationDestination(
                icon: Icon(
                  Icons.space_dashboard_outlined,
                  color: globalAppTheme.mainColorOption(),
                ),
                label: 'Boards',
              ),
            if (selectedIndex == 2)
              NavigationDestination(
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.surface,
                ),
                label: 'Settings',
              ),
            if (selectedIndex != 2)
              NavigationDestination(
                icon: Icon(
                  Icons.settings_outlined,
                  color: globalAppTheme.mainColorOption(),
                ),
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
