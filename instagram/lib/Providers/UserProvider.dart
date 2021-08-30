import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram/Models/Userdata.dart';

class UserProfile extends ChangeNotifier {
  Userdata? userdata;

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  FirebaseFirestore get user => _firebaseFirestore;

  String? _userID;

  String get userID => _userID!;

  changeUserID(userID) {
    _userID = userID;
    notifyListeners();
  }
}
