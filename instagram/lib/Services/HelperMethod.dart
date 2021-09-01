import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HelperMethods {
  CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection('users');

  CollectionReference _allPostsRef =
      FirebaseFirestore.instance.collection('AllPosts');

  Future<bool> checkUsernameAlreadyExists(String username) async {
    bool alreadyExists = false;
    final snapshot =
        await _firebaseFirestore.where("username", isEqualTo: username).get();
    snapshot.docs.forEach(
      (QueryDocumentSnapshot queryDocumentSnapshot) {
        final temp = queryDocumentSnapshot.get("username");
        if (temp == username) {
          alreadyExists = true;
        }
      },
    );
    return alreadyExists;
  }

  Future createProfile(String username, String name, String bio, String wensite,
      String photoUrl) async {
    try {
      print("Started Creating Profile");
      _firebaseFirestore.doc(FirebaseAuth.instance.currentUser!.uid).set({
        "email": FirebaseAuth.instance.currentUser!.email,
        "username": username,
        "bio": "$bio",
        "userID": FirebaseAuth.instance.currentUser!.uid,
        "followersCount": 0,
        "followingCount": 0,
        "followers": [],
        "following": [],
        "postCount": 0,
        "Name": name,
        "website": wensite,
        "photoUrl": photoUrl
      }).then((value) => print("Created Profile"));
    } catch (e) {}
  }

  Future updatePhotoUrl(String url, String uid) async {
    try {
      await _firebaseFirestore.doc(uid).update({"photoUrl": url});
    } catch (e) {}
  }

  Future createNewPost(
    List<String>? captions,
    String? location,
    String? time,
    String? username,
    List<String>? photoUrls,
    String? deviceName,
  ) async {
    Map<String, dynamic> postMap = {
      "type": "newpost",
      "captions": captions,
      "location": location,
      "time": time,
      "username": username,
      "photoUrls": photoUrls,
      "ownerID": FirebaseAuth.instance.currentUser!.uid,
      "deviceName": deviceName,
    };
    try {
      print("upload new Feed method is called");
      uploadPostToAllPosts(postMap);
      _firebaseFirestore
          .doc('${FirebaseAuth.instance.currentUser!.uid}')
          .collection('MyPosts')
          .add(postMap)
          .then(
        (DocumentReference ref) {
          print("A newffed has been Successfully Created");
          String id = ref.id;
          try {
            _firebaseFirestore
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('MyPosts')
                .doc(id)
                .update(
              {'postID': id},
            ).catchError((e) {
              print("Error in Updating post Id");
              print(e.toString());
            });
          } catch (e) {
            print(e);
            print("Error uploading post id");
          }
        },
      ).catchError(
        (e) {
          print("Something went wrong");
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future uploadnewFeed(
    String type,
    String message,
    String deviceName,
    String time,
    String username,
    String photoUrl,
    String location,
  ) async {
    try {
      print("upload new Feed method is called");

      Map<String, dynamic> postMap = {
        "type": type,
        "message": message,
        "deviceName": deviceName,
        "time": time,
        "ownerID": FirebaseAuth.instance.currentUser!.uid,
        "ownerusername": username,
        "ownerPhotoUrl": photoUrl,
        "location": location
      };
      uploadPostToAllPosts(postMap);
      _firebaseFirestore
          .doc('${FirebaseAuth.instance.currentUser!.uid}')
          .collection('MyPosts')
          .add(postMap)
          .then(
        (DocumentReference ref) {
          print("A newffed has been Successfully Created");
          String id = ref.id;
          try {
            _firebaseFirestore
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('MyPosts')
                .doc(id)
                .update(
              {'postID': id},
            ).catchError((e) {
              print("Error in Updating post Id");
              print(e.toString());
            });
          } catch (e) {
            print(e);
            print("Error uploading post id");
          }
        },
      ).catchError(
        (e) {
          print("Something went wrong");
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future uploadPostToAllPosts(Map<String, dynamic> postMap) async {
    _allPostsRef.add(postMap).then((e) {
      print("Post added to all Posts");
    }).catchError(
      (e) {
        print("Something went wrong");
      },
    );
  }
}
