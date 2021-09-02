import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Providers/AppData.dart';
import 'package:instagram/Providers/SocialAuthProviders.dart';
import 'package:instagram/Screens/AuthHomeScreen.dart';
import 'package:instagram/Screens/HomePageScreen.dart';
import 'package:instagram/Screens/LoginScreen.dart';
import 'package:instagram/Screens/RegistrationScree.dart';
import 'package:provider/provider.dart';

import 'Providers/UserProvider.dart';
import 'Screens/CreateContent/NewVideoPosts.dart';
import 'Services/AuthRouteStream.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  Stream? user = FirebaseAuth.instance.authStateChanges();
  user.listen((event) {
    print(event.toString());
    if (event == null) {
      print("Logout");
      runApp(MyApp(
        isLoggedin: false,
      ));
    } else {
      print("Logged in ");
      runApp(MyApp(
        isLoggedin: true,
      ));
    }
  });
}

class MyApp extends StatelessWidget {
  final bool isLoggedin;

  const MyApp({Key? key, required this.isLoggedin}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppData()),
        ChangeNotifierProvider(create: (context) => SocialAuthProviders()),
        ChangeNotifierProvider(create: (context) => UserProfile()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
        ),
        initialRoute: isLoggedin ? HomePageScreen.id : LoginScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          EmailLoginScreen.id: (context) => EmailLoginScreen(),
          HomePageScreen.id: (context) => HomePageScreen(),
          AuthStateStream.id: (context) => AuthStateStream(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
        },
      ),
    );
  }
}
