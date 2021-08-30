import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/Screens/Tabs/HomeTab.dart';
import 'package:instagram/Screens/Tabs/LikeTab.dart';
import 'package:instagram/Screens/Tabs/NewPostTab.dart';
import 'package:instagram/Screens/Tabs/SearchTab.dart';
import 'package:instagram/Screens/Tabs/UserProfile.dart';

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
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
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
        items: [
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.home,
                color: Colors.black,
                size: 30,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.search,
                color: Colors.black,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.plus,
                color: Colors.black,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.heart,
                color: Colors.black,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.black,
              ),
              label: ''),
        ],
      ),
    );
  }
}
