import 'package:flutter/material.dart';

class Loginbutton extends StatelessWidget {
  final String title;
  final Function onpressed;

  const Loginbutton({
    Key? key,
    required this.title,
    required this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 2.5,
            ),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: onpressed(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 60.0,
          vertical: 15,
        ),
        child: Container(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
