import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:page_transition/page_transition.dart';

import 'Tabs/HomeTab.dart';

class ShowPostWidget extends StatelessWidget {
  const ShowPostWidget(
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
                        ownerUsername!,
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
            SizedBox(
              height: 10,
            ),
            Text(
              message!,
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
                    onPressed: () {},
                    icon: Icon(LineIcons.heart),
                  ),
                  IconButton(
                    onPressed: () {
                      //BuildCommentContainer
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: BuildCommentContainer(),
                        ),
                      );
                    },
                    icon: Icon(LineIcons.comment),
                  ),
                  IconButton(
                    onPressed: () {},
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
