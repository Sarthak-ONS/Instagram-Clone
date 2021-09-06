import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Providers/UserProvider.dart';
import 'package:instagram/Services/DynamicLinksAPi.dart';
import 'package:just_audio/just_audio.dart';
import 'package:line_icons/line_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'CommentsPage.dart';

class ShowPostWidget extends StatefulWidget {
  ShowPostWidget(
      {Key? key,
      this.ownerPhotoUrl,
      this.ownerUsername,
      this.location,
      this.message,
      this.postID,
      this.ownerPostID,
      this.likes})
      : super(key: key);

  final String? ownerPhotoUrl;
  final String? ownerUsername;
  final String? location;
  final String? message;
  final String? postID;
  final String? ownerPostID;
  final List<String>? likes;

  @override
  _ShowPostWidgetState createState() => _ShowPostWidgetState();
}

class _ShowPostWidgetState extends State<ShowPostWidget> {
  @override
  void initState() {
    super.initState();
    print("Initialized");
    player = AudioPlayer();
    checkisLiked();
  }

  AudioPlayer? player;
  playAudio() async {
    player = AudioPlayer();
    await player!.setAsset('Sounds/Like.mp3');
    player!.play();
  }

  CollectionReference doc = FirebaseFirestore.instance.collection('AllPosts');
  Future checkisLiked() async {
    try {
      print("////////////");
      print(widget.postID);
      final snap = await doc.doc(widget.postID).get();
      List likes = snap.get("likes");
      if (likes.contains(FirebaseAuth.instance.currentUser!.uid)) {
        print("Liked :  ${widget.postID}");
        setState(() {
          isLiked = true;
        });
      } else {
        setState(() {
          isLiked = false;
        });
        print("Notliked");
      }
    } catch (e) {}
  }

  Future removefromLike() async {
    try {
      doc.doc(widget.postID).update({
        "likes":
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
      }).then((value) {
        checkisLiked();
        print("Remove from Likes");
      });
    } catch (e) {}
  }

  Future addToLike() async {
    try {
      doc.doc(widget.postID).update({
        "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      }).then((value) {
        print("Liked this posts");
        checkisLiked();
      });
    } catch (e) {}
  }

  bool? isLiked = false;

  @override
  void dispose() {
    super.dispose();
    print("Disposed");
    player!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      padding: EdgeInsets.all(2),
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  foregroundImage: NetworkImage(
                    widget.ownerPhotoUrl!,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.ownerUsername!,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.location!,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.message!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {
                      if (isLiked!) {
                        removefromLike();
                      } else {
                        await addToLike();
                        await playAudio();
                      }
                    },
                    icon: Icon(
                      LineIcons.thumbsUp,
                      color: isLiked == true ? Colors.blue : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      //BuildCommentContainer
                      print(widget.postID);
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: BuildCommentContainer(
                            postID: widget.postID,
                          ),
                        ),
                      );
                    },
                    icon: Icon(LineIcons.comment),
                  ),
                  IconButton(
                    onPressed: () async {
                      final url = await DynamicLinkAPI().createDynamicLink(
                          true,
                          widget.postID!,
                          Provider.of<UserProfile>(context, listen: false)
                              .userdata
                              .photoUrl!);
                      Share.share("$url");
                    },
                    icon: Icon(LineIcons.share),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
