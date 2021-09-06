import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Providers/UserProvider.dart';
import 'package:instagram/Services/CommentService.dart';
import 'package:instagram/widgets/AuthWidgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

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
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('AllPosts')
                        .doc(postID)
                        .get()
                        .catchError((e) {
                      print(e);
                    }),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.get("comments").length == null
                            ? ''
                            : snapshot.data!.get("comments").length!,
                        itemBuilder: (context, index) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            print("waiting");
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
                        print(postID!);
                        if (_comment.text.isEmpty) return;
                        await CommentService().postComments(
                            postID!,
                            Provider.of<UserProfile>(context, listen: false)
                                        .userdata
                                        .userName ==
                                    null
                                ? ''
                                : Provider.of<UserProfile>(context,
                                        listen: false)
                                    .userdata
                                    .userName!,
                            Provider.of<UserProfile>(context, listen: false)
                                        .userdata
                                        .photoUrl ==
                                    null
                                ? ''
                                : Provider.of<UserProfile>(context,
                                        listen: false)
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
