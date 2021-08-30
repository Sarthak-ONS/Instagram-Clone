import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/Screens/RegistrationScree.dart';
import 'package:instagram/Services/AuthService.dart';
import 'package:instagram/widgets/AuthWidgets.dart';
import 'package:instagram/widgets/LoadingIndiactor.dart';

class EmailLoginScreen extends StatefulWidget {
  static const String id = "EmailLoginScreen";
  EmailLoginScreen({Key? key}) : super(key: key);

  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _userId = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  Future _login() async {
    AuthService.signin(_userId.text, _password.text, context);
  }

  final key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _userId.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: FaIcon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: key,
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
                          title: 'Password',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        LoginContainer(
                          title: 'Log In',
                          onpressed: () {
                            print("Loggin Proccess Initiated");
                            if (_userId.text.isEmpty) {
                              print("empty");
                              showDialog(
                                context: context,
                                builder: (_) => CustomAlertDialog(
                                  title: 'Please Enter a Username or email',
                                ),
                              );
                              return;
                            }
                            if (_userId.text.length < 4) {
                              showDialog(
                                context: context,
                                builder: (_) => CustomAlertDialog(
                                  title: 'Username is too short',
                                ),
                              );
                              return;
                            }
                            if (_password.text.isEmpty) {
                              print("empty");
                              showDialog(
                                context: context,
                                builder: (_) => CustomAlertDialog(
                                  title: 'Please Enter a Password',
                                ),
                              );
                              return;
                            }
                            if (_password.text.length < 4) {
                              showDialog(
                                context: context,
                                builder: (_) => CustomAlertDialog(
                                  title: 'Password is too short',
                                ),
                              );
                              return;
                            }
                            _login();
                          },
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
        ],
      ),
    );
  }
}
