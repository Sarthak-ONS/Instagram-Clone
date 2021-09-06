import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Screens/CommentsPage.dart';
import 'package:instagram/Services/DynamicLinksAPi.dart';
import 'package:just_audio/just_audio.dart';
import 'package:line_icons/line_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';

import '../BrandColors.dart';

class ShowNewImagePostWidget extends StatefulWidget {
  ShowNewImagePostWidget(
      {Key? key,
      this.ownerPhotoUrl,
      this.ownerUserName,
      this.location,
      this.message,
      this.photoUrls,
      this.postID})
      : super(key: key);

  final String? ownerPhotoUrl;
  final String? ownerUserName;
  final String? location;
  final String? message;
  final List? photoUrls;
  final String? postID;

  @override
  _ShowNewImagePostWidgetState createState() => _ShowNewImagePostWidgetState();
}

class _ShowNewImagePostWidgetState extends State<ShowNewImagePostWidget> {
  final CarouselController _carouselController = CarouselController();
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
  Widget build(BuildContext context) {
    print(widget.photoUrls);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
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
                        widget.ownerUserName!,
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
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
            height: 500,
            child: Stack(
              children: [
                CarouselSlider(
                  carouselController: _carouselController,
                  items: widget.photoUrls!
                      .map((e) => Image(
                            image: NetworkImage(e!),
                            fit: BoxFit.cover,
                          ))
                      .toList(),
                  options: CarouselOptions(
                    height: 500,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        _carouselController.nextPage();
                      },
                      icon: Icon(
                        LineIcons.arrowRight,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            child: Text(
              '${widget.message}!',
              textAlign: TextAlign.left,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: 18,
                color: BrandColors.colorTextDark,
                fontWeight: FontWeight.w500,
              ),
            ),
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
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: BuildCommentContainer(
                          postID: widget.postID!,
                        ),
                      ),
                    );
                  },
                  icon: Icon(LineIcons.comment),
                ),
                IconButton(
                  onPressed: () async {
                    print(widget.postID);
                    final url = await DynamicLinkAPI().createDynamicLink(
                        true, widget.postID!, widget.photoUrls![0]);
                    Share.share("$url");
                  },
                  icon: Icon(LineIcons.share),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
