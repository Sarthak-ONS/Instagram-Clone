import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static void handleAuthException(dynamic e) {
    FirebaseException er = e;
    if (er.code == 'invalid-email') {
      print("Invalid email");
    }
    if (er.code == 'user-not-found') {
      print("This account doesn not exists");
    }
    if (er.code == 'wrong-password') {
      print("wrong password");
    }
    if (er.code == 'user-disabled') {
      print("User account is disabled");
    }
  }

  static Future signin(String email, String password) async {
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
        (UserCredential userCredential) {
          print(userCredential.user!.uid.toString());
        },
      ).catchError((e) {
        handleAuthException(e);
      });
    } catch (e) {
      print(e);
    }
  }
}
