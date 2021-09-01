import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      floatingActionButton:
          FloatingActionButton.extended(onPressed: () {}, label: Text('dvdfv')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StoriesWidget(),
            PostWidget(),
            PostWidget(),
          ],
        ),
      ),
    );
  }
}

class StoriesWidget extends StatelessWidget {
  const StoriesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return CircleAvatar(
              radius: 40,
              backgroundColor: Colors.teal,
              child: CircleAvatar(
                backgroundColor: Colors.teal,
                backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80'),
                radius: 38,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 6),
            );
          },
          itemCount: 10),
    );
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            //  fit: BoxFit.fill,
                            image: new NetworkImage(
                                "https://images.pexels.com/photos/3806690/pexels-photo-3806690.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Sarthak Agarwal",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )
                  ],
                ),
                IconButton(
                  icon: LineIcon(LineIcons.medapps),
                  onPressed: () {},
                )
              ]),
        ),
        Container(
          height: 400,
          child: Image.network(
            "https://images.pexels.com/photos/3806690/pexels-photo-3806690.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 7, bottom: 16.0, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: FaIcon(
                      FontAwesomeIcons.heart,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Icon(FontAwesomeIcons.comment),
                  SizedBox(width: 16.0),
                  Icon(FontAwesomeIcons.paperPlane)
                ],
              ),
              Icon(FontAwesomeIcons.bookmark)
            ],
          ),
        ),
      ],
    );
  }
}
