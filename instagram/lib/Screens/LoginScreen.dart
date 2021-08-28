import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram/Screens/RegistrationScree.dart';
import 'package:instagram/widgets/AuthWidgets.dart';

class EmailLoginScreen extends StatefulWidget {
  static const String id = "EmailLoginScreen";
  EmailLoginScreen({Key? key}) : super(key: key);

  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
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
                      inputtext: 'Phone number,email or username',
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
                    LoginContainer(
                      title: 'Log In',
                      onpressed: () {},
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          'Forgot your login details?',
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
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          height: 1.0,
                          width: MediaQuery.of(context).size.width / 2.7,
                          color: Colors.grey,
                          child: new ListTile(),
                        ),
                        new Text(
                          ' OR ',
                          style: new TextStyle(color: Colors.blueGrey),
                        ),
                        new Container(
                          height: 1.0,
                          width: MediaQuery.of(context).size.width / 2.7,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          'Create a new account?',
                          // style: _textStyleGrey,
                        ),
                        new TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => RegistrationScreen()));
                          },
                          child: new Text(
                            'Sign Up!',
                            // style: _textStyleBlueGrey,
                          ),
                        )
                      ],
                    )
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
