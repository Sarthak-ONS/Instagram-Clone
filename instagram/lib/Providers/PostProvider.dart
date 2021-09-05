import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PostProvider extends ChangeNotifier {
  CollectionReference _postReference =
      FirebaseFirestore.instance.collection('AllPosts');

  List<AllPosts> _posts = [];

  List<AllPosts> get posts => _posts;

  Future getPosts() async {
    final snapshot =
        await _postReference.where("type", isNotEqualTo: "video").get();
    snapshot.docs.forEach((QueryDocumentSnapshot snap) {
      AllPosts allPosts = AllPosts();
      allPosts.location = snap.get("location");
      allPosts.message = snap.get("message");
      allPosts.deviceName = snap.get("deviceName");
      allPosts.ownerID = snap.get("ownerID");
      allPosts.ownerPhotoUrl = snap.get("ownerPhotoUrl");
      allPosts.type = snap.get("type");
      if (allPosts.type != 'newFeed') {
        allPosts.photoUrls = snap.get("photoUrls");

        print(true);
      }
      allPosts.postID = snap.get("postID");
      allPosts.ownerusername = snap.get("ownerusername");
      allPosts.time = snap.get('time');
      print("Everything is fine");
      final contain =
          _posts.where((element) => element.postID == allPosts.postID);
      if (contain.length == 0) {
        print("Addiding to Post Lists");
        this._posts.add(allPosts);
      }
      _posts.shuffle();
      notifyListeners();
    });
  }
}

class AllPosts {
  String? location;
  String? message;
  String? deviceName;
  String? ownerID;
  String? ownerPhotoUrl;
  String? ownerusername;
  String? time;
  String? type;
  String? postID;
  String? videoUrl;
  List<dynamic>? photoUrls;


  AllPosts(
      {this.location,
      this.message,
      this.deviceName,
      this.ownerID,
      this.ownerPhotoUrl,
      this.ownerusername,
      this.time,
      this.type,
      this.videoUrl,
      this.photoUrls,
      this.postID,
      });
}
