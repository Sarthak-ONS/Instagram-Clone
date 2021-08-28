import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {
              FirebaseAuth.instance.createUserWithEmailAndPassword(email: 'agarwalsarthak456@gmaail.com', password: 'Sarthak@1233');
            },
            child: Text('Test'),
          ),
        ),
      ),
    );
  }
}
