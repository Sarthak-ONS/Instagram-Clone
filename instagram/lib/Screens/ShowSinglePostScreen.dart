import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Providers/PostProvider.dart';
import 'package:instagram/Screens/ShowNewFeedHomeTab.dart';
import 'package:instagram/widgets/ImagePostWidget.dart';
import 'package:line_icons/line_icons.dart';

class SinglePostScreen extends StatefulWidget {
  final String postID;

  const SinglePostScreen({Key? key, required this.postID}) : super(key: key);

  @override
  _SinglePostScreenState createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  AllPosts? allPosts;

  Future getPosts() async {
    try {
      print("Getting the data for this post ID: ${widget.postID}");
      final snap = await FirebaseFirestore.instance
          .collection('AllPosts')
          .doc(widget.postID)
          .get().catchError((e){
            print("/////////");
            print(e.toString());
          });
          print(snap.data().toString());
      setState(() {
        allPosts!.location = snap.get("location");
        allPosts!.message = snap.get("message");
        allPosts!.deviceName = snap.get("deviceName");
        allPosts!.ownerID = snap.get("ownerID");
        allPosts!.ownerPhotoUrl = snap.get("ownerPhotoUrl");
        allPosts!.type = snap.get("type");
        allPosts!.photoUrls = snap.get("photoUrls");
        allPosts!.postID = snap.get("postID");
        allPosts!.ownerusername = snap.get("ownerusername");
        allPosts!.time = snap.get('time');
      });
    } catch (e) {
      print("/////");
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getPosts();
        },
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              LineIcons.arrowLeft,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        elevation: 0,
        title: Text(
          'Instagram',
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontFamily: 'Brand-Bold'),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('AllPosts')
            .doc(widget.postID)
            .get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            print("Please Try again ALter");
            return Center(
              child: Text('Please Try again later'),
            );
          }
          if (snapshot.data!.get("type") == 'newFeed') {
            return ShowPostWidget(
              ownerPhotoUrl: snapshot.data!.get("ownerPhotoUrl"),
              ownerUsername: snapshot.data!.get("ownerusername"),
              location: snapshot.data!.get("location"),
              message: snapshot.data!.get("message"),
              postID: widget.postID,
            );
          }//snapshot.data!.get("photoUrls")
          return ShowNewImagePostWidget(
              ownerPhotoUrl: snapshot.data!.get("ownerPhotoUrl"),
              ownerUserName: snapshot.data!.get("ownerusername"),
              location: snapshot.data!.get("location"),
              message: snapshot.data!.get("message"),
              postID: widget.postID,
              photoUrls:snapshot.data!.get("photoUrls") ,
          );
        },
      ),
    );
  }
}
// ShowNewImagePostWidget(
//             ownerUserName: allPosts!.ownerusername,
//             ownerPhotoUrl: allPosts!.ownerPhotoUrl,
//             postID: widget.postID,
//             location: allPosts!.location,
//             message: allPosts!.message,
//             photoUrls: allPosts!.photoUrls,
//           )