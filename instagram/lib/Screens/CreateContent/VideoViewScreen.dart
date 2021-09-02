import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/BrandColors.dart';
import 'package:instagram/widgets/AuthWidgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:video_player/video_player.dart';

class VideoViewScreen extends StatefulWidget {
  final File? file;

  const VideoViewScreen({Key? key, this.file}) : super(key: key);

  @override
  _VideoViewScreenState createState() => _VideoViewScreenState();
}

class _VideoViewScreenState extends State<VideoViewScreen> {
  TextEditingController _caption = TextEditingController();

  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file!)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.maxFinite,
      // decoration: BoxDecoration(),
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
                onTap: () {
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
            Container(
              height: MediaQuery.of(context).size.height,
              child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!)),
            ),
            GestureDetector(
              onTap: () {
                if (isPlaying == false) {
                  _controller!.play();
                } else {
                  _controller!.pause();
                }
              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(
                    FontAwesomeIcons.play,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
                        userId: _caption,
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
