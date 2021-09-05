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

  Future updateCurrentUserProfile(Map<String, Object> map) async {
    try {
      _firebaseFirestore
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(map)
          .then((value) {
        //    updatePhotoUrlinAllPosts(FirebaseAuth.instance.currentUser!.uid, );
      }).catchError(
        (e) {
          print(
            e.toString(),
          );
        },
      );
    } catch (e) {}
  }

  Future updatePhotoUrlinAllPosts(String ownerID, String photoURL) async {
    // print("Updating Image in all the posts of this user");
    // try {
    //   final ref = await _allPostsRef.where("ownerID", isEqualTo: ownerID).get();
    //   ref.docs.forEach(
    //     (QueryDocumentSnapshot snapshot) async {
    //       print(snapshot.get("ownerID"));
    //       // await _firebaseFirestore.doc(snapshot.id).update(
    //       //   {"ownerPhotoUrl": photoURL},
    //       // );
    //     },
    //   );
    // } catch (e) {}
  }

  Future createNewPost(
    String captions,
    String? location,
    String? time,
    String? username,
    List<String>? photoUrls,
    String? deviceName,
    String? ownerPhotoURL,
  ) async {
    Map<String, dynamic> postMap = {
      "type": "newpost",
      "message": captions,
      "location": location,
      "time": time,
      "ownerusername": username,
      "photoUrls": photoUrls,
      "ownerID": FirebaseAuth.instance.currentUser!.uid,
      "deviceName": deviceName,
      "likes": [],
      "ownerPhotoUrl": ownerPhotoURL,
      "comments":[],
    };
    try {
      print("upload new Feed method is called");
      uploadPostToAllPosts(postMap);
      await _firebaseFirestore
          .doc('${FirebaseAuth.instance.currentUser!.uid}')
          .collection('MyPosts')
          .add(postMap)
          .then(
        (DocumentReference ref) {
          print("A newffed has been Successfully Created");
          print("//////////////");
          updateDocID(ref);
          print("//////////////");
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

  Future updateDocID(DocumentReference ref) async {
    try {
      print(ref.id);
      await _allPostsRef
          .doc(ref.id)
          .update({"postID": ref.id}).then((value) => print("Updated Post ID"));
    } catch (e) {}
  }

  Future addToLike(String id) async {
    try {
      _allPostsRef.doc(id).update(
        {
          "likes": FieldValue.arrayUnion(
            [FirebaseAuth.instance.currentUser!.uid],
          )
        },
      ).then((value) => print("Liked"));
    } catch (e) {}
  }

  Future removeFromLikes(String id) async {
    try {
      _allPostsRef.doc(id).update(
        {
          "likes": FieldValue.arrayRemove(
            [FirebaseAuth.instance.currentUser!.uid],
          )
        },
      ).then((value) => print("Liked"));
    } catch (e) {}
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
        "location": location,
        "likes": [],
        "comments": [],
        "postID": ""
      };
      uploadPostToAllPosts(postMap);
      _firebaseFirestore
          .doc('${FirebaseAuth.instance.currentUser!.uid}')
          .collection('MyPosts')
          .add(postMap)
          .then(
        (DocumentReference ref) {
          print("A newffed has been Successfully Created");
          updateDocID(ref);
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
      updateDocID(e);
    }).catchError(
      (e) {
        print("Something went wrong");
      },
    );
  }

  Future uploadNewVideoPost(
      String type,
      String message,
      String deviceName,
      String time,
      String username,
      String videoUrl,
      String location,
      String ownerPhotoUrl) async {
    print("Making map");
    Map<String, dynamic> postMap = {
      "type": type,
      "message": message,
      "deviceName": deviceName,
      "time": time,
      "ownerID": FirebaseAuth.instance.currentUser!.uid,
      "ownerPhotoUrl": ownerPhotoUrl,
      "ownerusername": username,
      "videoUrl": videoUrl,
      "location": location,
      "comments": [],
      "likes": []
    };
    try {
      print("upload new Video Posts");

      uploadPostToAllPosts(postMap);
      _firebaseFirestore
          .doc('${FirebaseAuth.instance.currentUser!.uid}')
          .collection('MyPosts')
          .add(postMap)
          .then(
        (DocumentReference ref) {
          print("A newffed has been Successfully Created");
          updateDocID(ref);
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

  Future follow(String followUserID) async {
    try {
      _firebaseFirestore.doc(followUserID).update(
        {
          "followers":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        },
      ).then((value) {
        print("Followed the user Tappped");
      }).catchError((e) {
        print(e.toString());
        print("Error following user");
      });
      _firebaseFirestore.doc(FirebaseAuth.instance.currentUser!.uid).update(
        {
          "following": FieldValue.arrayUnion([followUserID])
        },
      ).then((value) {
        print("Followed the user Tappped");
      }).catchError((e) {
        print(e.toString());
        print("Error following user");
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future unfollow(String followUserID) async {
    try {
      _firebaseFirestore.doc(followUserID).update(
        {
          "followers":
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        },
      ).then((value) {
        print("Followed the user Tappped");
      }).catchError(
        (e) {
          print(e.toString());
          print("Error following user");
        },
      );
      _firebaseFirestore.doc(FirebaseAuth.instance.currentUser!.uid).update(
        {
          "following": FieldValue.arrayRemove([followUserID])
        },
      ).then((value) {
        print("Followed the user Tappped");
      }).catchError(
        (e) {
          print(e.toString());
          print("Error following user");
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
