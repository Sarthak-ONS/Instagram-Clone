import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/BrandColors.dart';
import 'package:instagram/Providers/UserProvider.dart';
import 'package:instagram/Screens/AuthHomeScreen.dart';
import 'package:instagram/widgets/AuthWidgets.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'NewPostTab.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            LineIcon(
              LineIcons.lock,
              color: Colors.black,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              Provider.of<UserProfile>(context).userdata.userName!,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: NewPostTab(),
                ),
              );
            },
            icon: LineIcon(
              LineIcons.plusSquare,
              color: Colors.black,
              size: 30,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AlertDialog(
                  content: Text('Are you sure you want to logout? '),
                  title: Text('Alert'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent[350],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoginScreen.id, (route) => false);
                          await FirebaseAuth.instance.signOut();
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(color: BrandColors.colorPrimary),
                        ),
                      ),
                    )
                  ],
                ),
                useSafeArea: true,
              );
            },
            icon: LineIcon(
              FontAwesomeIcons.signOutAlt,
              color: Colors.black,
              size: 25,
            ),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Consumer<UserProfile>(
        builder: (context, d, widget) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 25.0, bottom: 15.0, right: 15.0, top: 15.0),
                    child: ClipOval(
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 45,
                        child: Image(
                          image: NetworkImage(d.userdata.photoUrl!),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildStats(
                        count: d.userdata.postCount.toString(),
                        title: 'Posts',
                      ),
                      buildStats(
                        count: d.userdata.followers!.length.toString(),
                        title: 'Followers',
                      ),
                      buildStats(
                        count: d.userdata.folowings!.length.toString(),
                        title: 'Following',
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.userdata.fullName!,
                      style: TextStyle(
                        color: BrandColors.colorTextDark,
                        fontSize: 18,
                        //  fontFamily: 'Brand-Bold',
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      d.userdata.bio!,
                      style: TextStyle(
                        color: BrandColors.colorTextDark,
                        fontSize: 14,
                        fontFamily: 'Brand-Regular',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                height: 45,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(40.0)),
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: LoginContainer(
                  onpressed: () {
                    print(d.userdata.photoUrl!);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => EditProfileScreen(),
                    //   ),
                    // );
                  },
                  title: 'Edit Profile',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: Expanded(
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    mainAxisSpacing: 1,
                    itemCount: 10,
                    crossAxisSpacing: 1,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        print(index + 1);
                      },
                      child: Container(
                        child: Image.network(
                          "https://images.pexels.com/photos/590029/pexels-photo-590029.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    staggeredTileBuilder: (index) =>
                        StaggeredTile.count(2, index.isEven ? 2 : 4),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

Widget buildStats({String? count, String? title}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        Text(
          title.toString(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ],
    ),
  );
}
