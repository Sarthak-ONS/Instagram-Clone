import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/Services/HelperMethod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:video_player/video_player.dart';

class VideoTab extends StatelessWidget {
  const VideoTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('AllPosts')
            .where("type", isEqualTo: "video")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Please Try Again Later'),
            );
          } else if (snapshot.data!.docs.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Reels Found',
                    style: TextStyle(fontSize: 20, fontFamily: 'Brand-Bold'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Create A new Reel!',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            );
          }
          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return ShowVideo(
                videoUrl: snapshot.data!.docs[index]['videoUrl'],
                ownerPhotoUrl: snapshot.data!.docs[index]['ownerPhotoUrl'],
                ownerUserName: snapshot.data!.docs[index]['ownerusername'],
                time: snapshot.data!.docs[index]['time'],
                message: snapshot.data!.docs[index]['message'],
                location: snapshot.data!.docs[index]['location'],
                postID: snapshot.data!.docs[index]['postID'],
              );
            },
          );
        },
      ),
    );
  }
}

class ShowVideo extends StatefulWidget {
  const ShowVideo(
      {Key? key,
      this.videoUrl,
      this.ownerPhotoUrl,
      this.message,
      this.location,
      this.ownerID,
      this.ownerUserName,
      this.time,
      this.postID})
      : super(key: key);
  final String? videoUrl;
  final String? ownerPhotoUrl;
  final String? message;
  final String? location;
  final String? ownerID;
  final String? ownerUserName;
  final String? time;
  final String? postID;

  @override
  _ShowVideoState createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    isCurrentVideoLiked();
    // _controller = VideoPlayerController.network(widget.videoUrl!)
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
  }

  @override
  void dispose() {
    _iconcontroller.dispose();
    super.dispose();

    //_controller!.dispose();
  }

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  int? noOfLikes;

  Future isCurrentVideoLiked() async {
    try {
      final snap = await _firebaseFirestore
          .collection('AllPosts')
          .doc(widget.postID)
          .get().catchError((e){print("Errir in is videoLiked Methid");});
      List temp = snap.get("likes");
      this.noOfLikes = temp.length;
      if (temp.contains(FirebaseAuth.instance.currentUser!.uid)) {
        setState(() {
          isLiked = true;
        });
      } else {
        setState(() {
          isLiked = false;
        });
      }
    } catch (e) {}
  }

  bool isLiked = false;

  _like() async {
    print("Liked");
    if (isLiked) {
      setState(() {
        isLiked = false;
      });
      HelperMethods().removeFromLikes(widget.postID!);
      isCurrentVideoLiked();
    } else {
      {
        setState(() {
          isLiked = true;
        });
        isCurrentVideoLiked();
        HelperMethods().addToLike(widget.postID!);
      }
    }
  }

  bool showLike = false;

  late final AnimationController _iconcontroller = AnimationController(
      duration: const Duration(milliseconds: 500), vsync: this, value: 0);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _iconcontroller,
    curve: Curves.fastOutSlowIn,
  );

  Widget buildLikeAnimation() {
    return ScaleTransition(
      scale: _animation,
      child: Icon(
        LineIcons.heartAlt,
        color: Colors.red,
        size: 45,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onDoubleTap: () {
          _like();
          _iconcontroller.forward().then((value) => _iconcontroller.reverse());
        },
        child: Container(
          color: Colors.black38,
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Stack(
            children: [
              Center(
                child: buildLikeAnimation(),
              ),
              // AspectRatio(
              //   aspectRatio: _controller!.value.aspectRatio,
              //   child: VideoPlayer(_controller!),
              // ),
              Positioned(
                bottom: 130,
                left: 5,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0)),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    widget.location!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              showLike ? Center(child: buildLikeAnimation()) : Container(),
              Positioned(
                bottom: 120,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        noOfLikes == null ? '..' : noOfLikes.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        icon: isLiked
                            ? Icon(
                                LineIcons.heartAlt,
                                color: Colors.red,
                              )
                            : Icon(FontAwesomeIcons.heart),
                        onPressed: _like,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 00,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  height: 130,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                foregroundImage:
                                    NetworkImage(widget.ownerPhotoUrl!),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                widget.ownerUserName!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Brand-Bold',
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(LineIcons.share),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.message!,
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.time!,
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
