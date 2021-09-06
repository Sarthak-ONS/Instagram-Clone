import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram/Models/Userdata.dart';

class UserProfile extends ChangeNotifier {
  late Userdata userdata = Userdata();
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  FirebaseFirestore get user => _firebaseFirestore;

  String? _userID;

  String get userID => _userID!;

  changeUserID(userID) {
    _userID = userID;
    notifyListeners();
  }

  Future changeProfile() async {
    print("Changing Profile");
    print(FirebaseAuth.instance.currentUser!.uid);
    DocumentSnapshot? snapshot = await _firebaseFirestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    userdata.fullName = snapshot.get("Name");
    userdata.email = snapshot.get("email");
    userdata.bio = snapshot.get("bio");
    userdata.followersCount = snapshot.get("followersCount");
    userdata.followingCount = snapshot.get("followingCount");
    userdata.photoUrl = snapshot.get("photoUrl");
    print(userdata.photoUrl);
    userdata.userName = snapshot.get("username");
    userdata.website = snapshot.get("website");
    userdata.postCount = snapshot.get('postCount');
    userdata.followers = snapshot.get('followers');
    userdata.folowings = snapshot.get('following');
    notifyListeners();
  }
}
