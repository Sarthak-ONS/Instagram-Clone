import 'package:cloud_firestore/cloud_firestore.dart';

class CommentService {
  CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection('AllPosts');

  Future getComments(String postID) async {
    try {
      final ref = await _firebaseFirestore.doc(postID).get();
      if (ref.exists) {
        return ref.get("comments");
      }
    } catch (e) {}
  }

  Future postComments(
      String postID, String username, String photoUrl, String comment) async {
    try {
      Map commentMap = {
        'userName': username,
        'userPhotoUrl': photoUrl,
        'text': comment
      };
      await _firebaseFirestore.doc(postID).update(
        {
          "comments": FieldValue.arrayUnion([commentMap])
        },
      ).then((value) {
        print("Successfully Addded Comment to the posts");
      }).catchError(
        (e) {
          print(e.toString());
        },
      );
    } catch (e) {}
  }
}
