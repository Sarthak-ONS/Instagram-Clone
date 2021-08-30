import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/widgets/LoadingIndiactor.dart';

class AuthService {
  static void handleAuthException(dynamic e, context) {
    FirebaseException er = e;
    if (er.code == 'invalid-email') {
      showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
          title: 'Your email is Invalid',
        ),
      );
      print("Invalid email");
      return;
    }
    if (er.code == 'user-not-found') {
      showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
          title: 'No account attached to this mail',
        ),
      );
      print("No account attached to this mail");
      return;
    }
    if (er.code == 'wrong-password') {
      showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
          title: 'Wrong Password',
        ),
      );
      print("wrong password");
      return;
    }
    if (er.code == 'user-disabled') {
      showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
          title: 'your accoubt is disabled',
        ),
      );
      print("Account Disabled");
      return;
    }
    //email-already-in-use
    if (er.code == 'email-already-in-use') {
      showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
          title: 'This email is already in use',
        ),
      );
      print("This email is already in use");
      return;
    }
    //weak-password
    if (er.code == 'weak-password') {
      showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
          title: 'Please enter a strong password',
        ),
      );
      print("Please enter a strong password");
      return;
    }
  }

  static Future signin(String email, String password, context) async {
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
        (UserCredential userCredential) {
          print(userCredential.user!.uid.toString());
        },
      ).then((value) {
        // Navigator.pushNamedAndRemoveUntil(
        //     context, HomePageScreen.id, (route) => false);
      }).catchError((e) {
        handleAuthException(e, context);
      });
    } catch (e) {
      print(e);
    }
  }

  static Future createUserwithemailandPassword(
      String email, String password, context) async {
    try {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        // Navigator.pushNamedAndRemoveUntil(
        //     context, HomePageScreen.id, (route) => false);
      }).catchError((e) {
        print("registration error");
        print(e.toString());
        handleAuthException(e, context);
      });
      FirebaseAuth.instance.currentUser!.sendEmailVerification().then(
            (value) {},
          );

      ///Notify user about the account Verification within 24 hours!
      print("Email is sent to user");
    } catch (e) {}
  }

  static Future signout(context) async {
    await FirebaseAuth.instance.signOut();
    // Navigator.pushNamedAndRemoveUntil(
    //     context, LoginScreen.id, (route) => false);
  }
}
