// ignore_for_file: use_build_context_synchronously

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
    if (_passwordController.text == "p@ssW0Rd#...") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('smartass >:B'),
          duration: Duration(seconds: 1),
        ),
      );
    }
    await Future.delayed(
      const Duration(seconds: 4),
    );
    _user = await loginController.callSignIn(
      _emailController.text,
      _passwordController.text,
    );
    if (await FirebaseAuth.instance.currentUser?.getIdToken() != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
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
        backgroundColor: Colors.white,
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
                    child: SizedBox(
                      height: 200,
                      width: 240,
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: SizedBox(
                  //     height: 50,
                  //     width: 150,
                  //     child: Text(
                  //       "BOARDER",
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontSize: 30,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 55,
                    child: Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: emailFocusNode.requestFocus,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 75),
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(0, 0, 0, 0),
                                blurRadius: 0,
                                spreadRadius: 0,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 100),
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.person_outline,
                                  color: loginError ? Colors.red : Colors.black,
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
                                    focusNode: emailFocusNode,
                                    controller: _emailController,
                                    undoController: _emailUndoController,
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                    hintText: "email",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: passwordFocusNode.requestFocus,
                        child: Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.lock_outline,
                                  color: loginError ? Colors.red : Colors.black,
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                child: BoarderTextField(
                                  "Password",
                                  focusNode: passwordFocusNode,
                                  controller: _passwordController,
                                  obscureText: hidePass,
                                  hintText: "password",
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    setState(() => hidePass = !hidePass),
                                icon: hidePass
                                    ? Icon(Icons.remove_red_eye_outlined)
                                    : Icon(Icons.remove_red_eye),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: MediaQuery.of(context).viewInsets.bottom > 90
                            ? 1.0
                            : 0.0,
                        duration: const Duration(milliseconds: 100),
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: Visibility(
                            visible:
                                MediaQuery.of(context).viewInsets.bottom != 0,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_circle_right_rounded,
                                color: Colors.black,
                              ),
                              onPressed: () async {
                                buttonPress(context);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    loginError
                        ? "Something went wrong, check email/password."
                        : "",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: loading
                          ? SizedBox(
                              height: 35,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : SizedBox(
                              height: 35,
                              width: 200,
                              child: ElevatedButton.icon(
                                label: Text(
                                  "Sign in with Email",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.arrow_circle_right_rounded,
                                  color: Colors.black,
                                ),
                                onPressed: () async {
                                  buttonPress(context);
                                  if (loginController.isUserLoggedIn()) {
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
                    child: Container(
                      child: TextButton(
                        child: Text(
                          'New Account',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    child: Divider(
                      height: 1,
                      thickness: 2,
                      color: Colors.black,
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
                              child: ElevatedButton.icon(
                                label: Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.g_mobiledata_sharp,
                                  color: Colors.black,
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
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () async {
                                  await loginController.callLoginAnnymous();
                                  if (loginController.isUserLoggedIn()) {
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
