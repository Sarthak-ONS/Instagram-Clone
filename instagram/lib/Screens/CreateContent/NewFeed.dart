import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/BrandColors.dart';
import 'package:instagram/Providers/AppData.dart';
import 'package:instagram/Providers/PostProvider.dart';
import 'package:instagram/Providers/UserProvider.dart';
import 'package:instagram/Screens/CreateContent/SelectLocationScreen.dart';
import 'package:instagram/Screens/HomePageScreen.dart';
import 'package:instagram/Services/HelperMethod.dart';
import 'package:instagram/widgets/AuthWidgets.dart';
import 'package:instagram/widgets/LoadingIndiactor.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CreateNewFeed extends StatelessWidget {
  TextEditingController _controller = TextEditingController();

  CreateNewFeed({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              LineIcons.arrowLeft,
              color: Colors.black,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Create New Feed',
          style: TextStyle(color: Colors.black, fontFamily: 'Brand-Bold'),
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: Icon(
              FontAwesomeIcons.instagram,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: TextFormField(
                controller: _controller,
                maxLines: 10,
                autofillHints: ["Sarthak"],
                decoration: new InputDecoration(
                  hintText: 'Message',
                  border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black),
                  ),
                  isDense: true,
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              'Device Name :  ${Provider.of<AppData>(context, listen: false).deviceModel.toString()}',
              style: TextStyle(
                  color: BrandColors.colorTextLight,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(Provider.of<AppData>(context, listen: false)
                .getCurrentTime
                .toString()),
            SizedBox(
              height: 15.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SearchLocationPage()));
              },
              child: Text(
                Provider.of<AppData>(context).userSelectedCurrentLocation == ""
                    ? 'Select Location'
                    : Provider.of<AppData>(context, listen: true)
                        .userSelectedCurrentLocation
                        .toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: BrandColors.colorBlue,
                ),
              ),
            ),
            LoginContainer(
              onpressed: () async {
                if (_controller.text.length < 10) {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        CustomAlertDialog(title: 'Please enter a feed'),
                  );
                  return;
                }
                print("Starting Creating new Feed");
                createFeed(context);
              },
              title: 'Broadcast',
            ),
            Row(
              children: [
                Icon(
                  LineIcons.exclamationTriangle,
                  color: BrandColors.colorTextSemiLight,
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text(
                  'This is message will be broadcasted to all your Followers',
                  style: TextStyle(
                    fontSize: 11,
                    color: BrandColors.colorTextLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future createFeed(context) async {
    try {
      print("New feed Creation");
      await HelperMethods()
          .uploadnewFeed(
              "newFeed",
              _controller.text,
              '${Provider.of<AppData>(context, listen: false).deviceModel.toString()}',
              "${Provider.of<AppData>(context, listen: false).getCurrentTime.toString()}",
              "${Provider.of<UserProfile>(context, listen: false).userdata.userName}",
              "${Provider.of<UserProfile>(context, listen: false).userdata.photoUrl}",
              "${Provider.of<AppData>(context, listen: false).userSelectedCurrentLocation.toString()}")
          .then((value) {
      Navigator.pushNamedAndRemoveUntil(context, HomePageScreen.id, (route) => false);
      });
      Provider.of<PostProvider>(context ,listen: false).getPosts();
    } catch (e) {
      print(e);
    }
  }
}
