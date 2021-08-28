import 'package:flutter/material.dart';
import 'package:instagram/widgets/AuthWidgets.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _userId = new TextEditingController();

  final TextEditingController _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Instagram',
                      style: new TextStyle(
                          fontFamily: 'Billabong', fontSize: 60.0),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    UserIDEditContainer(
                      userId: _userId,
                      inputtext: 'Name',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    UserIDEditContainer(
                      userId: _userId,
                      inputtext: 'email',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PasswordeditContainer(
                      password: _password,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    UserIDEditContainer(
                      userId: _userId,
                      inputtext: 'Confirm  Password',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LoginContainer(
                      title: 'Sign In',
                      onpressed: () {},
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          'Unable to Sign in',
                          // style: _textStyleGrey,
                        ),
                        new TextButton(
                          onPressed: () {},
                          child: new Text(
                            'Get help signing in.',
                            // style: _textStyleBlueGrey,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
