import 'package:boarder/core/Modules/register_page/register_page_controller.dart';
import 'package:boarder/core/widgets/ui/shared/boarder_text_field.dart';
import 'package:boarder/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RegisterPage> {
  RegisterPageController registerController = RegisterPageController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();

  bool loading = false;
  bool hidePass = true;
  bool hideRepeatPass = true;

  void pushHome() {
    navigatorKey.currentState?.pushNamed('/home');
  }

  Future<void> registerUser() async {
    try {
      await registerController.register(
          _emailController.text, _passwordController.text);
    } catch (e) {
      Exception(e);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          'Create a New Account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Enter your email:'),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: themeController
                              .getCurrentTheme()
                              .colorScheme
                              .surface,
                          border: Border.all(
                            color: themeController
                                .getCurrentTheme()
                                .colorScheme
                                .onBackground,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.person_outline,
                                color: themeController
                                    .getCurrentTheme()
                                    .colorScheme
                                    .onBackground,
                                size: 26,
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: BoarderTextField(
                                  "Email",
                                  color: themeController
                                      .getCurrentTheme()
                                      .colorScheme
                                      .onBackground,
                                  controller: _emailController,
                                  textStyle: TextStyle(
                                    color: themeController
                                        .getCurrentTheme()
                                        .colorScheme
                                        .onBackground,
                                    fontSize: 16,
                                  ),
                                  cursorColor: themeController
                                      .getCurrentTheme()
                                      .colorScheme
                                      .onBackground,
                                  hintText: "email",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Enter your password:'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              color: themeController
                                  .getCurrentTheme()
                                  .colorScheme
                                  .surface,
                              border: Border.all(
                                color: themeController
                                    .getCurrentTheme()
                                    .colorScheme
                                    .onBackground,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    Icons.lock_outline,
                                    color: themeController
                                        .getCurrentTheme()
                                        .colorScheme
                                        .onBackground,
                                    size: 26,
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: BoarderTextField(
                                      "Password",
                                      obscureText: hidePass,
                                      color: themeController
                                          .getCurrentTheme()
                                          .colorScheme
                                          .onBackground,
                                      controller: _passwordController,
                                      textStyle: TextStyle(
                                        color: themeController
                                            .getCurrentTheme()
                                            .colorScheme
                                            .onBackground,
                                        fontSize: 16,
                                      ),
                                      cursorColor: themeController
                                          .getCurrentTheme()
                                          .colorScheme
                                          .onBackground,
                                      hintText: "password",
                                      onEditingComplete: () {
                                        registerUser();
                                      },
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      setState(() => hidePass = !hidePass),
                                  icon: hidePass
                                      ? Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: themeController
                                              .getCurrentTheme()
                                              .colorScheme
                                              .onBackground,
                                        )
                                      : Icon(
                                          Icons.remove_red_eye,
                                          color: themeController
                                              .getCurrentTheme()
                                              .colorScheme
                                              .onBackground,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Repeat password:'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              color: themeController
                                  .getCurrentTheme()
                                  .colorScheme
                                  .surface,
                              border: Border.all(
                                color: themeController
                                    .getCurrentTheme()
                                    .colorScheme
                                    .onBackground,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    Icons.lock_outline,
                                    color: themeController
                                        .getCurrentTheme()
                                        .colorScheme
                                        .onBackground,
                                    size: 26,
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: BoarderTextField(
                                      "Password",
                                      obscureText: hideRepeatPass,
                                      color: themeController
                                          .getCurrentTheme()
                                          .colorScheme
                                          .onBackground,
                                      controller: _repeatPasswordController,
                                      textStyle: TextStyle(
                                        color: themeController
                                            .getCurrentTheme()
                                            .colorScheme
                                            .onBackground,
                                        fontSize: 16,
                                      ),
                                      cursorColor: themeController
                                          .getCurrentTheme()
                                          .colorScheme
                                          .onBackground,
                                      hintText: "repeat password",
                                      onEditingComplete: () {
                                        setState(() {
                                          registerUser();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => setState(
                                      () => hideRepeatPass = !hideRepeatPass),
                                  icon: hideRepeatPass
                                      ? Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: themeController
                                              .getCurrentTheme()
                                              .colorScheme
                                              .onBackground,
                                        )
                                      : Icon(
                                          Icons.remove_red_eye,
                                          color: themeController
                                              .getCurrentTheme()
                                              .colorScheme
                                              .onBackground,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 40,
                        child: loading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: themeController
                                      .getCurrentTheme()
                                      .colorScheme
                                      .onBackground,
                                ),
                              )
                            : Center(
                                child: OutlinedButton.icon(
                                  label: Text(
                                    "Create Account",
                                    style: TextStyle(
                                      color: themeController
                                          .getCurrentTheme()
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      width: 2.0,
                                      color: themeController
                                          .getCurrentTheme()
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    backgroundColor: themeController
                                        .getCurrentTheme()
                                        .colorScheme
                                        .surface,
                                  ),
                                  icon: Icon(
                                    Icons.person_add_alt,
                                    color: themeController
                                        .getCurrentTheme()
                                        .colorScheme
                                        .onBackground,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    await registerUser();

                                    if (registerController.user != null) {
                                      pushHome();
                                    }
                                  },
                                ),
                              ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () => {navigatorKey.currentState!.pop()},
                          child: Text(
                            'Back',
                            style: TextStyle(
                                color: themeController
                                    .getCurrentTheme()
                                    .colorScheme
                                    .onBackground),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
