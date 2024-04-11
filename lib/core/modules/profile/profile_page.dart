import 'package:boarder/core/modules/user/user_controller.dart';
import 'package:boarder/core/themes/theme_controller.dart';
import 'package:boarder/core/widgets/ui/shared/boarder_drawer.dart';
import 'package:boarder/core/widgets/ui/shared/boarder_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../widgets/ui/shared/boarder_appbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final themeController = ThemeController();
  final userController = Modular.get<UserController>();

  TextEditingController _nameController = TextEditingController();

  Map<String, dynamic> infoMap = {};

  bool _edit = false;

  void callLogout() async {
    await userController.logout();
    Modular.to.navigate('/login');
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userController.fetchUser(user);
    _nameController.text = userController.user!.name!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: BoarderDrawer(),
      appBar: BoarderAppbar(
        'Profile',
        titleColor: themeController.getCurrentTheme().colorScheme.onSurface,
        backgroundColor: themeController.getCurrentTheme().colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () => setState(() {
              if (_edit == true && _nameController.text.isNotEmpty) {
                userController.user?.name = _nameController.text;
                userController.updateUser(_nameController.text, null, null);
              }
              _edit = !_edit;
            }),
            icon: _edit ? Icon(Icons.save_as_outlined) : Icon(Icons.mode_edit_outlined),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: (MediaQuery.of(context).size.height * 0.35) - kToolbarHeight - MediaQuery.of(context).padding.top,
                width: MediaQuery.of(context).size.width,
                color: themeController.theme.colorScheme.background,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        height: 150,
                        child: userController.getCurrentUserPicture(),
                      ),
                      Positioned(
                        bottom: -3,
                        right: -3,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: themeController.getCurrentTheme().colorScheme.primary,
                          ),
                          color: Colors.white,
                          onPressed: () => {},
                          icon: Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: MediaQuery.of(context).size.width,
                    color: themeController.theme.colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      child: Observer(
                        builder: (_) => ListView(
                          shrinkWrap: true,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Name'),
                                _edit
                                    ? Container(
                                        width: 150,
                                        height: 25,
                                        child: BoarderTextField('',
                                            textAlign: TextAlign.end,
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                            ),
                                            controller: _nameController))
                                    : Container(
                                        width: 150,
                                        height: 25,
                                        child: Text(
                                          userController.user?.name ?? 'undefined',
                                          textAlign: TextAlign.end,
                                        )),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Email'),
                                Text(userController.user?.email ?? 'undefined'),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Team'),
                                Text(userController.team?.displayName ?? 'undefined'),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Phone'),
                                Text(
                                  userController.user?.phone ?? 'undefined',
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            child: OutlinedButton.icon(
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              onPressed: () => callLogout(),
            ),
          )
        ],
      ),
    );
  }
}
