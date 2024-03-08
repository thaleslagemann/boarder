import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPageController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isUserLoggedIn() {
    if (_auth.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<User?> _signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      return user;
    } catch (error) {
      print('Error signing in with email and password: $error');
      return null;
    }
  }

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        return user;
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  Future<User?> _signInAnonymously() async {
    try {
      final UserCredential userCredential = await _auth.signInAnonymously();
      final User? user = userCredential.user;
      return user;
    } catch (error) {
      print('Error signing in anonymously: $error');
      return null;
    }
  }

  Future<User?> callSignIn(String email, String password) async {
    User? user = await _signInWithEmailAndPassword(email, password);
    if (user != null) {
      return user;
    } else {
      // Ocorreu um erro durante o login.
    }
  }

  Future<User?> callSignInWithGoogle() async {
    User? user = await _signInWithGoogle();
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  Future<User?> callLoginAnnymous() async {
    User? user = await _signInAnonymously();
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }
}
