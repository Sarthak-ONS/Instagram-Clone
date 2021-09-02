import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram/widgets/AuthWidgets.dart';
import 'package:line_icons/line_icons.dart';

class VideoPostFinalizeScreen extends StatelessWidget {
  final File? file;

  final TextEditingController userId = TextEditingController();

  VideoPostFinalizeScreen({Key? key, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.maxFinite,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: FileImage(file!),
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                LineIcons.crop,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                LineIcons.smilingFace,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                LineIcons.edit,
                color: Colors.black,
              ),
            )
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(
                  LineIcons.arrowLeft,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Finalize Your Post',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            // Container(
            //   height: MediaQuery.of(context).size.height - 70,
            //   child: Image.file(
            //     file!,
            //     fit: BoxFit.cover,
            //     frameBuilder: (BuildContext context, Widget child, int? frame,
            //         bool wasSynchronouslyLoaded) {
            //       return Padding(
            //         padding: EdgeInsets.all(8.0),
            //         child: child,
            //       );
            //     },
            //   ),
            // // ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: UserIDEditContainer(
                        userId: userId,
                        inputtext: 'Add Caption...',
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        child: Icon(LineIcons.check),
                      ),
                    )
                  ],
                ),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
