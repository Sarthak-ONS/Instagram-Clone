import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram/BrandColors.dart';
import 'package:instagram/Providers/AppData.dart';
import 'package:instagram/Providers/UserProvider.dart';
import 'package:instagram/Services/HelperMethod.dart';
import 'package:instagram/widgets/AuthWidgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'SelectLocationScreen.dart';

class FinalizeNewPostScreen extends StatefulWidget {
  FinalizeNewPostScreen({Key? key, this.file, this.downloadUrls})
      : super(key: key);
  final List<File>? file;

  final List<String>? downloadUrls;

  @override
  _FinalizeNewPostScreenState createState() => _FinalizeNewPostScreenState();
}

class _FinalizeNewPostScreenState extends State<FinalizeNewPostScreen> {
  final TextEditingController _controller = TextEditingController();

  Future uploadImages(context) async {
    if (widget.file!.length < 1) return;
    print("Started uploading images to Database");
    widget.file!.forEach(
      (File? image) async {
        print(image!.path);
        File file = File(image.path);
        TaskSnapshot task = await FirebaseStorage.instance
            .ref('posts/${image.path.split('/')}')
            .putFile(file);
        String downloadUrl = await task.ref.getDownloadURL();
        widget.downloadUrls!.add(downloadUrl);
        print(downloadUrl);
      },
    );
  }

  Future createNewPosts(context) async {
    print("Inside Method Create new Posts");
    await HelperMethods().createNewPost(
      [_controller.text],
      Provider.of<AppData>(context, listen: false).deviceModel.toString(),
      Provider.of<AppData>(context, listen: false).getCurrentTime.toString(),
      Provider.of<UserProfile>(context, listen: false)
          .userdata
          .userName
          .toString(),
      widget.downloadUrls,
      Provider.of<AppData>(context, listen: false).deviceModel.toString(),
    ).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    uploadImages(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                LineIcons.arrowLeft,
                color: Colors.black,
                size: 25,
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Continue Creating Post',
          style: TextStyle(
            color: BrandColors.colorTextDark,
            fontSize: 20,
            fontFamily: 'Brand-Bold',
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.0,
              ),
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormField(
                  controller: _controller,
                  maxLines: 8,
                  autofillHints: ["Sarthak"],
                  decoration: new InputDecoration(
                    hintText: 'Caption Here',
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
                  Provider.of<AppData>(context).userSelectedCurrentLocation ==
                          ""
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
                  print(widget.file![1].path);
                  createNewPosts(context);
                },
                title: 'Create Post',
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'This post will be visible to all your Followers',
                style: TextStyle(
                  fontSize: 14,
                  color: BrandColors.colorTextLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
