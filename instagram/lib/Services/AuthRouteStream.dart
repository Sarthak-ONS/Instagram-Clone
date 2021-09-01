import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Screens/AuthHomeScreen.dart';
import 'package:instagram/Screens/HomePageScreen.dart';

class AuthStateStream extends StatelessWidget {
  static const String id = "AuthStateStream";
  const AuthStateStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          Navigator.pop(context);
          print("Automatic Singing");
          return HomePageScreen();
        }
        if (snapshot.hasError) {
          return LoginScreen();
        }
        if (snapshot.data == null) {
          return LoginScreen();
        }
        return Text('Something went wrong');
      },
    );
  }
}
