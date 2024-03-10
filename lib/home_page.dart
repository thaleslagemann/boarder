import 'package:boarder/app_settings/setting_classes/login_page/login_page_controller.dart';
import 'package:boarder/core/themes/theme_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:boarder/app_settings/config.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:boarder/main.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final themeController = ThemeController();

  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();

    return configState.loadingDB
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
                        color: themeController.getCurrentTheme().onBackground,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Loading home',
                        style: TextStyle(
                            color:
                                themeController.getCurrentTheme().onBackground),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 40,
                    child: Column(
                      children: [
                        Text(
                          'Taking too long?',
                          style: TextStyle(
                              color: themeController
                                  .getCurrentTheme()
                                  .onBackground),
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
                                color: themeController
                                    .getCurrentTheme()
                                    .onBackground,
                              ),
                              backgroundColor:
                                  themeController.getCurrentTheme().surface,
                            ),
                            child: Text(
                              'Log out',
                              style: TextStyle(
                                  color: themeController
                                      .getCurrentTheme()
                                      .onBackground),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
                child: Stack(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home_sharp,
                            size: 24,
                          ),
                          Text(
                            ' Home Page',
                            style: TextStyle(fontSize: 24),
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
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
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                text: 'Welcome to Boarder, ',
                                children: [
                                  if (FirebaseAuth
                                          .instance.currentUser?.displayName !=
                                      null)
                                    TextSpan(
                                        text:
                                            '${FirebaseAuth.instance.currentUser?.displayName}',
                                        style: TextStyle(
                                            color: globalAppTheme
                                                .mainColorOption())),
                                  if (FirebaseAuth
                                          .instance.currentUser?.displayName ==
                                      null)
                                    TextSpan(
                                        text: 'Guest',
                                        style: TextStyle(
                                            color: globalAppTheme
                                                .mainColorOption())),
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
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
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
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
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
            ])),
          );
  }
}
