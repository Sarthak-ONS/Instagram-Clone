import 'package:flutter/material.dart';
import 'package:instagram/Providers/SocialAuthProviders.dart';
import 'package:instagram/Screens/LoginScreen.dart';
import 'package:instagram/widgets/BackgroundImageidget.dart';
import 'package:instagram/widgets/LoginButton.dart';
import 'package:instagram/widgets/LoginIconButtonWidget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static final String id = "Login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(
            child: Container(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      //Login user with eamil and password
                      print("Logging user with Email and password");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmailLoginScreen(),
                        ),
                      );
                    },
                    child: Loginbutton(
                      title: 'Login with Email',
                      onpressed: () {
                        //   print("Login with Email");
                        // Navigator.pushNamed(context, EmailLoginScreen.id);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          //Login user with Google
                          Provider.of<SocialAuthProviders>(context,
                                  listen: false)
                              .googleLogin(context);
                        },
                        child: LoginIconButtonWidget(
                          path: 'Images/Google.png',
                          h: 35,
                          w: 35,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          //login user with facebook
                          print("Logging user with facebook");
                          Provider.of<SocialAuthProviders>(context,
                                  listen: false)
                              .signInWithFacebook(context);
                        },
                        child: LoginIconButtonWidget(
                          path: 'Images/Facebook.png',
                          h: 40,
                          w: 40,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
