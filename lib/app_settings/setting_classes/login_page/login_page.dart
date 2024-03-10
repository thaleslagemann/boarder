// ignore_for_file: use_build_context_synchronously
import 'package:boarder/main.dart';
import 'package:boarder/core/themes/theme_controller.dart';
import 'package:boarder/core/widgets/ui/shared/boarder_text_field.dart';
import 'package:boarder/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../register_page/register_page.dart';
import 'login_page_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final themeController = ThemeController();
  User? _user;
  bool loading = false;

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  LoginPageController loginController = LoginPageController();

  TextEditingController _emailController = TextEditingController();
  UndoHistoryController _emailUndoController = UndoHistoryController();

  TextEditingController _passwordController = TextEditingController();
  UndoHistoryController _passwordUndoController = UndoHistoryController();

  bool loginError = false;
  bool hidePass = true;
  bool hideEmail = false;
  bool emailFieldFocused = false;

  @override
  void initState() {
    print(themeController.getCurrentTheme().brightness);
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  buttonPress(BuildContext context) async {
    setState(() {
      loading = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(
      const Duration(seconds: 4),
    );
    _user = await loginController.callSignIn(
      _emailController.text,
      _passwordController.text,
    );
    if (loginController.isUserLoggedIn()) {
      navigatorKey.currentState?.pushNamed('/home');
    } else {
      setState(() {
        loading = false;
        loginError = true;
      });
    }
  }

  onSwitchFocus(FocusNode focusNode) {
    if (focusNode.hasPrimaryFocus) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: themeController.getCurrentTheme().background,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        height: 200,
                        width: 240,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/boar.png",
                            ),
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                                themeController.getCurrentTheme().onBackground,
                                BlendMode.srcATop),
                          ),
                        )),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 50,
                      width: 150,
                      child: Text(
                        "BOARDER",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeController.getCurrentTheme().onBackground,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        color: themeController.getCurrentTheme().surface,
                        border: Border.all(
                          color: themeController.getCurrentTheme().onBackground,
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
                              color: loginError
                                  ? themeController.getCurrentTheme().error
                                  : themeController
                                      .getCurrentTheme()
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
                                    .onBackground,
                                focusNode: emailFocusNode,
                                controller: _emailController,
                                undoController: _emailUndoController,
                                textStyle: TextStyle(
                                  color: themeController
                                      .getCurrentTheme()
                                      .onBackground,
                                  fontSize: 16,
                                ),
                                cursorColor: themeController
                                    .getCurrentTheme()
                                    .onBackground,
                                hintText: "email",
                                onChange: (value) => {
                                  setState(() => loginError = false),
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                          color: themeController.getCurrentTheme().surface,
                          border: Border.all(
                            color:
                                themeController.getCurrentTheme().onBackground,
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
                                color: loginError
                                    ? themeController.getCurrentTheme().error
                                    : themeController
                                        .getCurrentTheme()
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
                                      .onBackground,
                                  focusNode: passwordFocusNode,
                                  controller: _passwordController,
                                  undoController: _passwordUndoController,
                                  textStyle: TextStyle(
                                    color: themeController
                                        .getCurrentTheme()
                                        .onBackground,
                                    fontSize: 16,
                                  ),
                                  cursorColor: themeController
                                      .getCurrentTheme()
                                      .onBackground,
                                  hintText: "password",
                                  onChange: (value) => {
                                    setState(() => loginError = false),
                                  },
                                  onEditingComplete: () {
                                    buttonPress(context);
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
                                          .onBackground,
                                    )
                                  : Icon(
                                      Icons.remove_red_eye,
                                      color: themeController
                                          .getCurrentTheme()
                                          .onBackground,
                                    ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: MediaQuery.of(context).viewInsets.bottom > 90
                            ? 1.0
                            : 0.0,
                        duration: const Duration(milliseconds: 100),
                        child: SizedBox(
                          width: 55,
                          height: 45,
                          child: Visibility(
                            visible:
                                MediaQuery.of(context).viewInsets.bottom != 0,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_circle_right_rounded,
                                color: themeController
                                    .getCurrentTheme()
                                    .onBackground,
                              ),
                              onPressed: () async {
                                buttonPress(context);
                                if (loginController.isUserLoggedIn()) {
                                  navigatorKey.currentState?.pushNamed('/home');
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: loading
                          ? SizedBox(
                              height: 40,
                              child: CircularProgressIndicator(
                                color: themeController
                                    .getCurrentTheme()
                                    .onBackground,
                              ),
                            )
                          : SizedBox(
                              height: 40,
                              width: 200,
                              child: OutlinedButton.icon(
                                label: Text(
                                  "Sign in with Email",
                                  style: TextStyle(
                                    color: themeController
                                        .getCurrentTheme()
                                        .onBackground,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.arrow_circle_right_rounded,
                                  color: themeController
                                      .getCurrentTheme()
                                      .onBackground,
                                ),
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
                                onPressed: () async {
                                  buttonPress(context);
                                },
                              ),
                            ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: TextButton(
                        child: Text(
                          'Or Create a New Account',
                          style: TextStyle(
                            color:
                                themeController.getCurrentTheme().onBackground,
                          ),
                        ),
                        onPressed: () {
                          navigatorKey.currentState?.pushNamed('/register');
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    child: Divider(
                      height: 1,
                      thickness: 2,
                      color: themeController.getCurrentTheme().onBackground,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: loading
                          ? SizedBox(
                              height: 40,
                            )
                          : SizedBox(
                              height: 40,
                              width: 200,
                              child: OutlinedButton.icon(
                                label: Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                    color: themeController
                                        .getCurrentTheme()
                                        .onBackground,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.g_mobiledata_sharp,
                                  color: themeController
                                      .getCurrentTheme()
                                      .onBackground,
                                ),
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
                                onPressed: () async {
                                  await loginController.callSignInWithGoogle();
                                  if (await loginController.user
                                          ?.getIdToken() !=
                                      null) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: loading
                          ? SizedBox(
                              height: 35,
                            )
                          : SizedBox(
                              height: 35,
                              width: 200,
                              child: TextButton(
                                child: Text(
                                  "Or enter Anonymously",
                                  style: TextStyle(
                                    color: themeController
                                        .getCurrentTheme()
                                        .onBackground,
                                  ),
                                ),
                                onPressed: () async {
                                  await loginController.callLoginAnnymous();
                                  if (loginController.isUserLoggedIn()) {
                                    navigatorKey.currentState
                                        ?.pushNamed('/home');
                                  }
                                },
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
