// ignore_for_file: use_build_context_synchronously
import 'package:boarder/core/modules/user/user_controller.dart';
import 'package:boarder/main.dart';
import 'package:boarder/core/themes/theme_controller.dart';
import 'package:boarder/core/widgets/ui/shared/boarder_text_field.dart';
import 'package:boarder/core/modules/home_page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
  final userController = Modular.get<UserController>();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  LoginPageController loginController = LoginPageController();

  TextEditingController _emailController = TextEditingController();
  UndoHistoryController _emailUndoController = UndoHistoryController();

  TextEditingController _passwordController = TextEditingController();
  UndoHistoryController _passwordUndoController = UndoHistoryController();

  bool loading = false;
  bool loginError = false;
  bool hidePass = true;
  bool hideEmail = false;
  bool emailFieldFocused = false;

  @override
  void initState() {
    super.initState();
    print(themeController.getCurrentTheme().colorScheme.brightness);
    WidgetsBinding.instance.addPostFrameCallback((_) => loadUser());
  }

  loadUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      userController.fetchUser(user);
    } catch (e) {
      print(e);
    }
    if (FirebaseAuth.instance.currentUser != null) {
      navigateHome();
    } else {
      loginController.loading = false;
    }
  }

  navigateHome() {
    Modular.to.navigate('/home');
  }

  callLogin(BuildContext context) async {
    setState(() {
      loading = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(
      const Duration(seconds: 4),
    );
    final user = await loginController.callSignIn(
      _emailController.text,
      _passwordController.text,
    );
    userController.fetchUser(user);
    if (loginController.isUserLoggedIn()) {
      navigateHome();
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
    return loginController.loading
        ? Center(
            child: SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                color: themeController.getCurrentTheme().colorScheme.onBackground,
              ),
            ),
          )
        : GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: themeController.getCurrentTheme().colorScheme.background,
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
                                  colorFilter: ColorFilter.mode(themeController.getCurrentTheme().colorScheme.onBackground, BlendMode.srcATop),
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
                                color: themeController.getCurrentTheme().colorScheme.onBackground,
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
                              color: themeController.getCurrentTheme().colorScheme.surface,
                              border: Border.all(
                                color: loading ? Colors.grey : themeController.getCurrentTheme().colorScheme.onBackground,
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
                                    color: loginError ? themeController.getCurrentTheme().colorScheme.error : themeController.getCurrentTheme().colorScheme.onBackground,
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
                                      color: themeController.getCurrentTheme().colorScheme.onBackground,
                                      focusNode: emailFocusNode,
                                      controller: _emailController,
                                      undoController: _emailUndoController,
                                      enabled: !loading,
                                      textStyle: TextStyle(
                                        color: themeController.getCurrentTheme().colorScheme.onBackground,
                                        fontSize: 16,
                                      ),
                                      cursorColor: themeController.getCurrentTheme().colorScheme.onBackground,
                                      selectionColor: themeController.getCurrentTheme().colorScheme.primary,
                                      selectionHandleColor: themeController.getCurrentTheme().colorScheme.onBackground,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                color: themeController.getCurrentTheme().colorScheme.surface,
                                border: Border.all(
                                  color: loading ? Colors.grey : themeController.getCurrentTheme().colorScheme.onBackground,
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
                                      color: loginError ? themeController.getCurrentTheme().colorScheme.error : themeController.getCurrentTheme().colorScheme.onBackground,
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
                                        enabled: !loading,
                                        color: themeController.getCurrentTheme().colorScheme.onBackground,
                                        focusNode: passwordFocusNode,
                                        controller: _passwordController,
                                        undoController: _passwordUndoController,
                                        textStyle: TextStyle(
                                          color: themeController.getCurrentTheme().colorScheme.onBackground,
                                          fontSize: 16,
                                        ),
                                        cursorColor: themeController.getCurrentTheme().colorScheme.onBackground,
                                        hintText: "password",
                                        onChange: (value) => {
                                          setState(() => loginError = false),
                                        },
                                        onEditingComplete: () async {
                                          setState(() {
                                            callLogin(context);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  loading
                                      ? Padding(
                                          padding: const EdgeInsets.only(right: 12.0),
                                          child: Icon(
                                            hidePass ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                                            color: loading ? Colors.grey : themeController.getCurrentTheme().colorScheme.onBackground,
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () => setState(() => hidePass = !hidePass),
                                          icon: hidePass
                                              ? Icon(
                                                  Icons.remove_red_eye_outlined,
                                                  color: loading ? Colors.grey : themeController.getCurrentTheme().colorScheme.onBackground,
                                                )
                                              : Icon(
                                                  Icons.remove_red_eye,
                                                  color: loading ? Colors.grey : themeController.getCurrentTheme().colorScheme.onBackground,
                                                ),
                                        ),
                                ],
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: MediaQuery.of(context).viewInsets.bottom > 90 ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 100),
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Visibility(
                                  visible: MediaQuery.of(context).viewInsets.bottom != 0,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_circle_right_rounded,
                                      color: themeController.getCurrentTheme().colorScheme.onBackground,
                                    ),
                                    onPressed: () async {
                                      callLogin(context);
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
                                      color: themeController.getCurrentTheme().colorScheme.onBackground,
                                    ),
                                  )
                                : SizedBox(
                                    height: 40,
                                    width: 200,
                                    child: OutlinedButton.icon(
                                      label: Text(
                                        "Sign in with Email",
                                        style: TextStyle(
                                          color: themeController.getCurrentTheme().colorScheme.onBackground,
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.arrow_circle_right_rounded,
                                        color: themeController.getCurrentTheme().colorScheme.onBackground,
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          width: 2.0,
                                          color: themeController.getCurrentTheme().colorScheme.onBackground,
                                        ),
                                        backgroundColor: themeController.getCurrentTheme().colorScheme.surface,
                                      ),
                                      onPressed: () async {
                                        callLogin(context);
                                      },
                                    ),
                                  ),
                          ),
                        ),
                        loading
                            ? SizedBox(
                                height: 40,
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 40,
                                  child: TextButton(
                                    child: Text(
                                      'Or Create a New Account',
                                      style: TextStyle(
                                        color: themeController.getCurrentTheme().colorScheme.onBackground,
                                      ),
                                    ),
                                    onPressed: () {
                                      Modular.to.pushNamed('/register');
                                    },
                                  ),
                                ),
                              ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 60),
                          child: Divider(
                            height: 1,
                            thickness: 2,
                            color: themeController.getCurrentTheme().colorScheme.onBackground,
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
                                          color: themeController.getCurrentTheme().colorScheme.onBackground,
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.g_mobiledata_sharp,
                                        color: themeController.getCurrentTheme().colorScheme.onBackground,
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          width: 2.0,
                                          color: themeController.getCurrentTheme().colorScheme.onBackground,
                                        ),
                                        backgroundColor: themeController.getCurrentTheme().colorScheme.surface,
                                      ),
                                      onPressed: () async {
                                        await loginController.callSignInWithGoogle();
                                        if (await loginController.user?.getIdToken() != null) {
                                          navigatorKey.currentState!.pushReplacementNamed('/home');
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
                                          color: themeController.getCurrentTheme().colorScheme.onBackground,
                                        ),
                                      ),
                                      onPressed: () async {
                                        await loginController.callLoginAnnymous();
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
                  )
                ],
              ),
            ),
          );
  }
}
