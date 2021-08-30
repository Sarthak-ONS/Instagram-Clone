import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/Services/AuthService.dart';
import 'package:instagram/widgets/AuthWidgets.dart';
import 'package:instagram/widgets/LoadingIndiactor.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _useremail = new TextEditingController();
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _confpassword = new TextEditingController();
  bool showLoader = false;

  Future _signup() async {
    setState(() {
      showLoader = true;
    });
    await AuthService.createUserwithemailandPassword(
        _useremail.text, _password.text, context);
    setState(() {
      showLoader = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _useremail.dispose();
    _name.dispose();
    _password.dispose();
    _confpassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25 , vertical: MediaQuery.of(context).size.height *0.1),
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
                        userId: _name,
                        inputtext: 'Name',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      UserIDEditContainer(
                        userId: _useremail,
                        inputtext: 'email',
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
                      PasswordeditContainer(
                        password: _confpassword,
                         title: 'Confirm Password',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      showLoader
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : LoginContainer(
                              title: 'Sign In',
                              onpressed: () {
                                print("Initiating Registration");
                                if (_name.text.isEmpty) {
                                  print("empty");
                                  showDialog(
                                    context: context,
                                    builder: (_) => CustomAlertDialog(
                                      title: 'Please Enter a Name',
                                    ),
                                  );
                                  return;
                                }
                                if (_useremail.text.isEmpty) {
                                  print("empty");
                                  showDialog(
                                    context: context,
                                    builder: (_) => CustomAlertDialog(
                                      title: 'Please Enter a email',
                                    ),
                                  );
                                  return;
                                }
                                if (_useremail.text.length < 4) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => CustomAlertDialog(
                                      title: 'Email is too short',
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
                                if (_password.text.length < 6) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => CustomAlertDialog(
                                      title: 'Password is too short',
                                    ),
                                  );
                                  return;
                                }
                                if (_password.text != _confpassword.text) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => CustomAlertDialog(
                                      title: 'Password do not match',
                                    ),
                                  );
                                  return;
                                }
                                _signup();
                              },
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
      ),
    );
  }
}
