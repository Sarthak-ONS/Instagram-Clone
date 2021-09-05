import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Providers/UserProvider.dart';
import 'package:instagram/Services/HelperMethod.dart';
import 'package:provider/provider.dart';

import '../BrandColors.dart';

class SearchListTile extends StatefulWidget {
  final String? username;
  final String? name;
  final String? photoUrl;

  final String? userID;
  const SearchListTile({
    Key? key,
    this.userID,
    this.username,
    this.photoUrl,
    this.name,
  }) : super(key: key);

  @override
  _SearchListTileState createState() => _SearchListTileState();
}

class _SearchListTileState extends State<SearchListTile> {
  bool? isCurrentUserFollowing = false;

  Future getFollowersList(id) async {
    final x =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    List followerList = x.data()!['followers'];
    if (followerList.contains(FirebaseAuth.instance.currentUser!.uid)) {
      setState(() {
        isCurrentUserFollowing = true;
      });
    } else {
      setState(() {
        isCurrentUserFollowing = false;
      });
    }
  }

  @override
  void initState() {
    getFollowersList(widget.userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: () async {},
        title: Text(widget.username!),
        subtitle: Text(widget.name!),
        leading: CircleAvatar(
          foregroundImage: NetworkImage(widget.photoUrl!),
        ),
        trailing: Container(
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: BrandColors.colorBlue),
          ),
          child: TextButton(
            onPressed: isCurrentUserFollowing!
                ? () async {
                    try {
                      await HelperMethods().unfollow(widget.userID!);
                      Provider.of<UserProfile>(context ,listen: false).changeProfile();
                      setState(() => getFollowersList(widget.userID));
                    } catch (e) {}
                  }
                : () async {
                    try {
                      await HelperMethods().follow(widget.userID!);
                           Provider.of<UserProfile>(context ,listen: false).changeProfile();
                      setState(() => getFollowersList(widget.userID));
                    } catch (e) {}
                  },
            child: isCurrentUserFollowing! ? Text('Following') : Text('Follow'),
          ),
        ),
      ),
    );
  }
}
