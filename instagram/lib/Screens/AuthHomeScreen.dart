import 'package:flutter/material.dart';
import 'package:instagram/Providers/SocialAuthProviders.dart';
import 'package:instagram/Screens/LoginScreen.dart';
import 'package:instagram/Screens/RegistrationScree.dart';
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
            top: MediaQuery.of(context).padding.top,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Brand-Regular',
                  ),
                ),
              ),
            ),
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
                  SocialWidget(color:Colors.white),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
          ),
          Center(
            child: Text(
              'Instagram',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Billabong', fontSize: 55),
            ),
          )
        ],
      ),
    );
  }
}

class SocialWidget extends StatelessWidget {
  final Color color;
  const SocialWidget({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            //Login user with Google
            Provider.of<SocialAuthProviders>(context, listen: false)
                .googleLogin(context);
          },
          child: Row(
            children: [
              LoginIconButtonWidget(
                path: 'Images/Google.png',
                h: 35,
                w: 35,
              ),
              Text(
                'Google',
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontFamily: 'Brand-Bold',
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: 15,
        ),
        GestureDetector(
          onTap: () {
            //login user with facebook
            print("Logging user with facebook");
            Provider.of<SocialAuthProviders>(context, listen: false)
                .signInWithFacebook(context);
          },
          child: Row(
            children: [
              LoginIconButtonWidget(
                path: 'Images/Facebook.png',
                h: 40,
                w: 40,
              ),
              Text(
                'Facebook',
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontFamily: 'Brand-Bold',
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
