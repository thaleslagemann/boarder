import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'register_page_controller.g.dart';

class RegisterPageController = RegisterPageControllerBase
    with _$RegisterPageController;

abstract class RegisterPageControllerBase with Store {
  RegisterPageControllerBase({
    this.user,
  });

  @observable
  User? user;

  Future<User?> _registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
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

  Future<void> register(String email, String password) async {
    try {
      user = await _registerWithEmailAndPassword(email, password);
    } catch (error) {
      print(error);
    }
  }
}
