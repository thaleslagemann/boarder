import 'package:boarder/app_settings/setting_classes/register_page/register_page_controller.dart';
import 'package:boarder/core/widgets/ui/shared/boarder_text_field.dart';
import 'package:boarder/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login_page/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RegisterPage> {
  User? _user;
  bool loading = false;

  RegisterPageController registerController = RegisterPageController();
  TextEditingController _usernameTextFieldController = TextEditingController();
  TextEditingController _emailTextFieldController = TextEditingController();
  TextEditingController _passwordTextFieldController = TextEditingController();
  TextEditingController _repeatPasswordTextFieldController =
      TextEditingController();

  void pushHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  Future<User?> registerUser() async {
    User? user;
    try {
      user = await registerController.register(
          _emailTextFieldController.text, _passwordTextFieldController.text);
    } catch (e) {
      Exception(e);
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: const Color.fromARGB(108, 0, 0, 0),
                            blurRadius: 1,
                            spreadRadius: 1,
                            offset: Offset(0, 2)),
                      ]),
                  padding: EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          'Registration',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Enter your username:'),
                      Container(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: BoarderTextField('Username',
                              controller: _usernameTextFieldController)),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Enter your email:'),
                      Container(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: BoarderTextField('Email',
                              controller: _emailTextFieldController)),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Enter your password:'),
                      Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        child: BoarderTextField(
                          'Password',
                          controller: _passwordTextFieldController,
                          obscureText: true,
                          obscuringCharacter: '•',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Repeat password:'),
                      Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        child: BoarderTextField(
                          'Password',
                          controller: _repeatPasswordTextFieldController,
                          obscureText: true,
                          obscuringCharacter: '•',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        child: loading
                            ? CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : Center(
                                child: ElevatedButton.icon(
                                  label: Text(
                                    "Register",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.mode_edit,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    _user = await registerUser();

                                    if (_user != null) {
                                      pushHome();
                                    }
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
