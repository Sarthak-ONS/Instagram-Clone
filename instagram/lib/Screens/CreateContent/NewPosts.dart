import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/BrandColors.dart';
import 'package:instagram/Screens/CreateContent/FinalizeNewPostScreen.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class NewPosts extends StatefulWidget {
  const NewPosts({Key? key}) : super(key: key);

  @override
  _NewPostsState createState() => _NewPostsState();
}

class _NewPostsState extends State<NewPosts> {
  File? image;

  final CarouselController buttonCarouselController = CarouselController();
  List<File>? images = [];
  pickImages(imageSource) async {
    try {
      final image = await ImagePicker().pickImage(
        source: imageSource,
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: double.maxFinite,
        imageQuality: 50,
      );
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        images!.add(imageTemp);
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  void chooseImage(context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () async {
                    pickImages(ImageSource.camera);
                  },
                  icon: LineIcon(
                    LineIcons.camera,
                    color: BrandColors.colorTextDark,
                    size: 40,
                  ),
                ),
                Text('Camera')
              ],
            ),
            SizedBox(
              width: 50,
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    pickImages(ImageSource.gallery);
                  },
                  icon: LineIcon(
                    LineIcons.image,
                    color: BrandColors.colorTextDark,
                    size: 40,
                  ),
                ),
                Text('Gallery')
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafcfa),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Create Posts',
          style: TextStyle(color: Colors.black, fontFamily: 'Brand-Bold'),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              chooseImage(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Add',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  Icon(
                    LineIcons.plus,
                    color: Colors.black,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
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
      ),
      floatingActionButton: images!.length == 0
          ? Container()
          : FloatingActionButton.extended(
              label: Text('Next'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FinalizeNewPostScreen(
                      file: images,
                      downloadUrls: [],
                    ),
                  ),
                );
              },
            ),
      body: Stack(
        children: [
          Container(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images!.length,
              itemBuilder: (context, index) {
                return Container(
                  //  color: Colors.,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        //  height: MediaQuery.of(context).size.height-100,
                        width: double.maxFinite,
                        child: Image(
                          fit: BoxFit.fill,
                          image: FileImage(
                            images![index],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            index == images!.length - 1
                                ? 'Swipe Right'
                                : 'Swipe left ',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 15,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              images!.removeAt(index);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
