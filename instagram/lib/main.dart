import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Providers/AppData.dart';
import 'package:instagram/Providers/SocialAuthProviders.dart';
import 'package:instagram/Screens/AuthHomeScreen.dart';
import 'package:instagram/Screens/HomePageScreen.dart';
import 'package:instagram/Screens/LoginScreen.dart';
import 'package:provider/provider.dart';

import 'Providers/UserProvider.dart';
import 'Services/AuthRouteStream.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        initialRoute:  AuthStateStream.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          EmailLoginScreen.id: (context) => EmailLoginScreen(),
          HomePageScreen.id: (context) => HomePageScreen(),
          AuthStateStream.id: (context) => AuthStateStream()
        },
      ),
    );
  }
}
