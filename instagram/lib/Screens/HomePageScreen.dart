import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/BrandColors.dart';
import 'package:instagram/Providers/AppData.dart';
import 'package:instagram/Providers/UserProvider.dart';
import 'package:instagram/Screens/Tabs/HomeTab.dart';
import 'package:instagram/Screens/Tabs/LikeTab.dart';
import 'package:instagram/Screens/Tabs/NewPostTab.dart';
import 'package:instagram/Screens/Tabs/SearchTab.dart';
import 'package:instagram/Screens/Tabs/UserProfile.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatefulWidget {
  static String id = "HomePageScreen";
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    Provider.of<UserProfile>(context, listen: false).changeProfile();
    Provider.of<AppData>(context , listen: false).getDeviceInfo();
    Provider.of<AppData>(context , listen: false).getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  int _selectedIndex = 0;

  void changeIndex(index) {
    setState(() {
      _selectedIndex = index;
      _tabController!.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        //  physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          HomeTab(),
          SearchTab(),
          NewPostTab(),
          LikeTab(),
          ProfileTab()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme:
            IconThemeData(color: BrandColors.colorTextDark, size: 30),
        unselectedIconTheme:
            IconThemeData(color: BrandColors.colorDimText, size: 30),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: changeIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                LineIcons.home,
                color: Colors.black,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                LineIcons.searchPlus,
                color: Colors.black,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                LineIcons.plus,
                color: Colors.black,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: FaIcon(
                LineIcons.heart,
                color: Colors.black,
              ),
              activeIcon: Icon(LineIcons.heartAlt),
              label: ''),
          BottomNavigationBarItem(
              icon: FaIcon(
                LineIcons.user,
                color: Colors.black,
              ),
              label: ''),
        ],
      ),
    );
  }
}
