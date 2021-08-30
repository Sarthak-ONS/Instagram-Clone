import 'package:cloud_firestore/cloud_firestore.dart';

class Userdata {
  String? userName;
  String? fullName;
  String? email;
  String? photoUrl;
  String? bio;
  int? postCount;
  int? followersCount;
  int? followingCount;

  Userdata({
    this.userName,
    this.fullName,
    this.email,
    this.photoUrl,
    this.bio,
    this.followersCount,
    this.followingCount,
    this.postCount,
  });

  Userdata.fromJson(DocumentSnapshot snapshot) {
    //
    print(snapshot);
  }
}
