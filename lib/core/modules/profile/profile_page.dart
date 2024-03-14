import 'package:auto_size_text/auto_size_text.dart';
import 'package:boarder/core/modules/user/user_controller.dart';
import 'package:boarder/core/themes/theme_controller.dart';
import 'package:boarder/core/widgets/ui/shared/boarder_drawer.dart';
import 'package:boarder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final themeController = ThemeController();
  final userController = UserController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BoarderDrawer(),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    color: themeController.theme.colorScheme.primary,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 75,
                            backgroundColor: Colors.white,
                            child: userController.getCurrentUserPicture(),
                          ),
                          Observer(
                            builder: (_) =>
                                userController.user?.displayName != null && userController.user?.displayName != ''
                                    ? AutoSizeText(
                                        "${userController.user?.displayName}",
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.onSurface),
                                      )
                                    : Text(
                                        "Guest",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontSize: 40,
                                        ),
                                      ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width,
                    color: themeController.theme.colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                'Guest',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                'Guest@test.com',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phone',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                '51 912345678',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
