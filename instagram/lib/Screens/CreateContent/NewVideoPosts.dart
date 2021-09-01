import 'package:flutter/material.dart';

class NewVideoPosts extends StatelessWidget {
  const NewVideoPosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text('Create a Video Feed' , style: TextStyle(
          color: Colors.black,
          fontFamily: 'Brand-Bold'
        ),),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
