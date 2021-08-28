import 'package:flutter/material.dart';
class BackgroundImage extends StatelessWidget {
  final Widget child;
  BackgroundImage({Key? key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('Images/Loginimage.png'),
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.2),
            BlendMode.darken,
          ),
        ),
      ),
    );
  }
}
