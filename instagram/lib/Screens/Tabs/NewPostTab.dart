import 'package:flutter/material.dart';
import 'package:instagram/Screens/CreateContent/GoLive.dart';
import 'package:instagram/Screens/CreateContent/NewFeed.dart';
import 'package:instagram/Screens/CreateContent/NewPosts.dart';
import 'package:instagram/Screens/CreateContent/NewVideoPosts.dart';

class NewPostTab extends StatefulWidget {
  const NewPostTab({Key? key}) : super(key: key);

  @override
  _NewPostTabState createState() => _NewPostTabState();
}

class _NewPostTabState extends State<NewPostTab> {
  handleNavigation(index) {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => CreateNewFeed()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => NewPosts()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => NewVideoPosts()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => GoLive()));
        break;
      default:
    }
  }

  List text = ["New Feed", "New Posts", "New Video Posts", "Live"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Create Content',
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.black,
            fontFamily: 'Brand-Bold',
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              print(index);
              handleNavigation(index);
            },
            title: Text(text[index]),
          );
        },
      ),
    );
  }
}
