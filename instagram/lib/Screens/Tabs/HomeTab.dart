import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/BrandColors.dart';
import 'package:instagram/Providers/PostProvider.dart';
import 'package:instagram/Providers/UserProvider.dart';
import 'package:instagram/Services/CommentService.dart';
import 'package:instagram/Services/DynamicLinksAPi.dart';
import 'package:instagram/widgets/AuthWidgets.dart';

import 'package:line_icons/line_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../ShowNewFeedHomeTab.dart';
import 'NewPostTab.dart';

class HomeTab extends StatelessWidget {
  HomeTab({Key? key}) : super(key: key);

  Widget builAppBar() {
    return AppBar(
      actions: [
        Icon(
          FontAwesomeIcons.plus,
          color: Colors.black,
        ),
        GestureDetector(
          onTap: () async {
            await FirebaseAuth.instance.signOut();
          },
          child: Icon(
            FontAwesomeIcons.facebookMessenger,
            textDirection: TextDirection.rtl,
            color: Colors.black,
          ),
        ),
      ],
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'Instagram',
        style: TextStyle(
          fontFamily: 'Billabong',
          fontSize: 40,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Instagram',
          style: TextStyle(
              fontFamily: 'Billabong', color: Colors.black, fontSize: 38),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.all(8.0),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: NewPostTab(),
                ),
              );
            },
            icon: Icon(
              LineIcons.plus,
              color: Colors.black,
              size: 30,
            ),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: GetBody(
        size: size,
      ),
    );
  }
}

class GetBody extends StatelessWidget {
  const GetBody({Key? key, this.size}) : super(key: key);

  final Size? size;

  Widget spacer() => SizedBox(
        width: 10,
      );

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context).posts;
    return ListView.builder(
      itemCount: postProvider.length,
      itemBuilder: (context, index) {
        if (postProvider[index].type == 'newFeed') {
          return ShowPostWidget(
              ownerPhotoUrl: postProvider[index].ownerPhotoUrl,
              ownerUsername: postProvider[index].ownerusername,
              location: postProvider[index].location,
              message: postProvider[index].message,
              postID: postProvider[index].postID);
        }
        return ShowNewImagePostWidget(
            ownerPhotoUrl: postProvider[index].ownerPhotoUrl,
            ownerUserName: postProvider[index].ownerusername,
            location: postProvider[index].location,
            message: postProvider[index].message,
            photoUrls: postProvider[index].photoUrls,
            postID: postProvider[index].postID);
      },
    );
  }
}

class ShowNewImagePostWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    print(photoUrls);
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
                    ownerPhotoUrl!,
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
                        ownerUserName!,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        location!,
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
            child: CarouselSlider(
              items: photoUrls!
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
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            child: Text(
              '$message!',
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
                  onPressed: () {},
                  icon: Icon(LineIcons.heart),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: BuildCommentContainer(
                          postID: postID!,
                        ),
                      ),
                    );
                  },
                  icon: Icon(LineIcons.comment),
                ),
                IconButton(
                  onPressed: () async {
                    print(postID);
                    final url = await DynamicLinkAPI()
                        .createDynamicLink(true, postID!, photoUrls![0]);
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

class BuildCommentContainer extends StatelessWidget {
  BuildCommentContainer({Key? key, this.postID}) : super(key: key);

  final TextEditingController _comment = TextEditingController();
  final String? postID;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Comments',
            style: TextStyle(
              fontFamily: 'Brand-Bold',
              color: Colors.black,
              fontSize: 24,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('AllPosts')
                        .doc(postID)
                        .get(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.get("comments").length,
                        itemBuilder: (context, index) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 2),
                            height: 60,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      foregroundImage: NetworkImage(
                                          snapshot.data!.get("comments")[index]
                                              ['userPhotoUrl']),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${snapshot.data!.get("comments")[index]['userName']}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(snapshot.data!
                                            .get("comments")[index]['text'])
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: UserIDEditContainer(
                        userId: _comment,
                        inputtext: 'Please post a comment',
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Center(
                          child: Icon(
                            LineIcons.arrowRight,
                            color: Colors.white,
                          ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent,
                        ),
                      ),
                      onPressed: () async {
                        if (_comment.text.isEmpty) return;
                        await CommentService().postComments(
                            postID!,
                            Provider.of<UserProfile>(context, listen: false)
                                .userdata
                                .userName!,
                            Provider.of<UserProfile>(context, listen: false)
                                .userdata
                                .photoUrl!,
                            _comment.text);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
