import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../main.dart';
import '../../../modules/user/user_controller.dart';
import '../../../themes/theme_controller.dart';

class BoarderDrawer extends StatefulWidget {
  const BoarderDrawer({super.key});

  @override
  State<BoarderDrawer> createState() => BoarderDrawerState();
}

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

class BoarderDrawerState extends State<BoarderDrawer> {
  final themeController = ThemeController();
  final userController = Modular.get<UserController>();

  void callLogout() async {
    await userController.logout();
    Modular.to.navigate('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              DrawerHeader(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(color: themeController.getCurrentTheme().colorScheme.primary),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: userController.getCurrentUserPicture(),
                        ),
                        SizedBox(width: 10),
                        Observer(
                          builder: (_) => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              userController.user?.name != null && userController.user?.name != ''
                                  ? AutoSizeText(
                                      "${userController.user?.name}",
                                      maxLines: 1,
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                                    )
                                  : Text(
                                      "Guest",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                                    ),
                              userController.team?.displayName != null && userController.team?.displayName != ''
                                  ? AutoSizeText(
                                      "${userController.team?.displayName}",
                                      maxLines: 1,
                                      style: TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSurface),
                                    )
                                  : Text(
                                      "Teamless",
                                      style: TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSurface),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                top: 60,
                child: IconButton(
                  onPressed: () => setState(() {
                    showAboutDialog(context: context);
                  }),
                  icon: Icon(
                    Icons.notifications_outlined,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text('Home'),
            onTap: () => {Modular.to.navigate('/home')},
          ),
          ListTile(
            leading: Icon(Icons.space_dashboard_outlined),
            title: Text('Boards'),
            onTap: () => {Modular.to.navigate('/boards')},
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Profile'),
            onTap: () => {Modular.to.navigate('/profile')},
          ),
          ListTile(
            leading: Icon(Icons.people_outline),
            title: Text('Teams'),
            onTap: () => {Modular.to.navigate('/teams')},
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Settings'),
            onTap: () => {Modular.to.navigate('/settings')},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => callLogout(),
          )
        ],
      ),
    );
  }
}
