import 'package:flutter/material.dart';

class LoginIconButtonWidget extends StatelessWidget {
  final String path;
  final double h;
  final double w;

  const LoginIconButtonWidget({
    Key? key,
    required this.path,
    required this.h,
    required this.w,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.transparent,
      child: ClipOval(
        child: Image.asset(
          path,
          height: h,
          width: w,
        ),
      ),
    );
  }
}
