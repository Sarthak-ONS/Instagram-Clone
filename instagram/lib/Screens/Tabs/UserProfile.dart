import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram/BrandColors.dart';
import 'package:instagram/Providers/UserProvider.dart';
import 'package:instagram/widgets/AuthWidgets.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
              Provider.of<UserProfile>(context).userdata.userName.toString(),
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          LineIcon(
            LineIcons.plusSquare,
            color: Colors.black,
            size: 30,
          ),
          SizedBox(
            width: 15,
          ),
          LineIcon(
            LineIcons.hamburger,
            color: Colors.black,
            size: 30,
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
                    padding:
                        EdgeInsets.only(left: 25.0, bottom: 15.0, right: 15.0),
                    child: ClipOval(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 45,
                        child: CachedNetworkImage(
                          imageUrl: d.userdata.photoUrl.toString(),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Container(),
                          errorWidget: (context, url, error) => Container(),
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
                        count: d.userdata.followersCount.toString(),
                        title: 'Followers',
                      ),
                      buildStats(
                        count: d.userdata.followingCount.toString(),
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
                      d.userdata.fullName.toString(),
                      style: TextStyle(
                        color: BrandColors.colorTextDark,
                        fontSize: 16,
                        //  fontFamily: 'Brand-Bold',
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      d.userdata.bio.toString(),
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
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: LoginContainer(
                  onpressed: () {
                    print("Editing profiel");
                    print(d.userdata.photoUrl.toString());
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
                        print(index+1);
                      },
                      child: Container(
                        child: Image.network(
                          "https://images.pexels.com/photos/775358/pexels-photo-775358.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
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

class TaggedPhotoWidget extends StatelessWidget {
  const TaggedPhotoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          'Tagged',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// class YourPosts extends StatelessWidget {
//   const YourPosts({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child:,
//     );
//   }
// }
