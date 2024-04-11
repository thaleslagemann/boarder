import 'package:boarder/core/themes/theme_controller.dart';
import 'package:boarder/core/widgets/ui/shared/boarder_appbar.dart';
import 'package:boarder/core/widgets/ui/shared/boarder_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:boarder/app_settings/config.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:boarder/main.dart';

import '../user/user_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final themeController = ThemeController();
  final userController = Modular.get<UserController>();

  bool loading = false;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        navigatorKey.currentState?.pushNamed('/');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: Center(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: themeController.getCurrentTheme().colorScheme.onBackground,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Loading home',
                        style: TextStyle(color: themeController.getCurrentTheme().colorScheme.onBackground),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 40,
                    child: Column(
                      children: [
                        Text(
                          'Taking too long?',
                          style: TextStyle(color: themeController.getCurrentTheme().colorScheme.onBackground),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        OutlinedButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              navigatorKey.currentState?.pushNamed('/login');
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                width: 2.0,
                                color: themeController.getCurrentTheme().colorScheme.onBackground,
                              ),
                              backgroundColor: themeController.getCurrentTheme().colorScheme.surface,
                            ),
                            child: Text(
                              'Log out',
                              style: TextStyle(color: themeController.getCurrentTheme().colorScheme.onBackground),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            drawer: BoarderDrawer(),
            appBar: BoarderAppbar(
              'Home',
              titleColor: themeController.getCurrentTheme().colorScheme.onSurface,
              backgroundColor: themeController.getCurrentTheme().colorScheme.primary,
            ),
            backgroundColor: themeController.getCurrentTheme().colorScheme.background,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.ramen_dining),
                      SizedBox(height: 15),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                text: 'Welcome to Boarder, ',
                                children: [
                                  if (FirebaseAuth.instance.currentUser?.displayName != null)
                                    TextSpan(
                                        text: '${FirebaseAuth.instance.currentUser?.displayName}',
                                        style: TextStyle(color: themeController.getCurrentTheme().colorScheme.primary)),
                                  if (FirebaseAuth.instance.currentUser?.displayName == null)
                                    TextSpan(text: 'Guest', style: TextStyle(color: globalAppTheme.mainColorOption())),
                                  TextSpan(text: '!'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            'We are very happy to have you here!',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            'The app is currently under development, so we appreciate the patience.',
                            maxLines: 8,
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
