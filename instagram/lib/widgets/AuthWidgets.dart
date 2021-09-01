import 'package:flutter/material.dart';

class UserIDEditContainer extends StatelessWidget {
  final TextEditingController userId;
  final String inputtext;
  const UserIDEditContainer(
      {Key? key, required this.userId, required this.inputtext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new TextField(
        controller: userId,
        decoration: new InputDecoration(
          hintText: inputtext,
          border: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.black),
          ),
          isDense: true,
        ),
        // style: _textStyleBlack,
      ),
    );
  }
}

class PasswordeditContainer extends StatelessWidget {
  final TextEditingController password;
  final String title;

  const PasswordeditContainer(
      {Key? key, required this.password, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: new TextField(
        controller: password,
        obscureText: true,
        decoration: new InputDecoration(
            hintText: title,
            border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.black),
            ),
            isDense: true),
        //  style: _textStyleBlack,
      ),
    );
  }
}

class LoginContainer extends StatelessWidget {
  const LoginContainer({Key? key, required this.onpressed, required this.title})
      : super(key: key);

  final Function onpressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onpressed();
      },
      child: InkWell(
        splashColor: Colors.white,
        child: new Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 10.0),
          width: 500.0,
          height: 40.0,
          child: new Text(
            title,
            style: new TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
        ),
      ),
    );
  }
}
