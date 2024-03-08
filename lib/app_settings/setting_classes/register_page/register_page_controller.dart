import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPageController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> _registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      return user;
    } catch (error) {
      print('Error registering with email and password: $error');
      return null;
    }
  }

  Future<User?> register(String email, String password) async {
    User? user = await _registerWithEmailAndPassword(email, password);
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }
}
