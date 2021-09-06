import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Providers/AppData.dart';
import 'package:instagram/Providers/PostProvider.dart';
import 'package:provider/provider.dart';

import 'CreateUserProfileScreen.dart';
import 'HomePageScreen.dart';

class SocailAuthCheckerScreen extends StatefulWidget {
  const SocailAuthCheckerScreen({Key? key}) : super(key: key);

  @override
  _SocailAuthCheckerScreenState createState() =>
      _SocailAuthCheckerScreenState();
}

class _SocailAuthCheckerScreenState extends State<SocailAuthCheckerScreen> {
  Future check() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (doc.exists) {
      print("No need to create user Profile");
      Navigator.pushNamedAndRemoveUntil(
          context, HomePageScreen.id, (route) => false);
     // Provider.of<UserProfile>(context, listen: false).changeProfile();
      Provider.of<AppData>(context, listen: false).getDeviceInfo();
      Provider.of<AppData>(context, listen: false).getCurrentLocation();
      Provider.of<PostProvider>(context, listen: false).getPosts();
    } else {
      print("Create user profile");
      //CreateUserProfileScreen
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => CreateUserProfileScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    check();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://images.pexels.com/photos/3559235/pexels-photo-3559235.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940")),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Please wait! While we sign you in..',
                style: TextStyle(
                  fontFamily: 'Brand-Bold',
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
