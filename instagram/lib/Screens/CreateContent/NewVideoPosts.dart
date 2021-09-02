import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/BrandColors.dart';
import 'package:instagram/Screens/CreateContent/VideoViewScreen.dart';
import 'package:line_icons/line_icons.dart';

import 'NewVideoPostFinalizeScreen.dart';

List<CameraDescription>? cameras;

class NewVideoPosts extends StatefulWidget {
  const NewVideoPosts({Key? key}) : super(key: key);

  @override
  _NewVideoPostsState createState() => _NewVideoPostsState();
}

class _NewVideoPostsState extends State<NewVideoPosts> {
  CameraController? controller;

  Future<void>? cameraValue;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      cameras![0],
      ResolutionPreset.max,
    );
    cameraValue = controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  XFile? file;

  void takePhoto() async {
    final file = await controller!.takePicture();
    final tempFile = File(file.path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPostFinalizeScreen(
          file: tempFile,
        ),
      ),
    );
    print(file.path);
  }

  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          Container(
            color: Colors.white,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                LineIcons.arrowLeft,
                color: Colors.black,
              ),
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Create a Video Feed',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Brand-Bold',
          ),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    child: CameraPreview(
                      controller!,
                    ),
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            },
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: Container(
              height: 100,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.solidLightbulb,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isRecording) {
                            return;
                          }
                          takePhoto();
                        },
                        onLongPress: () async {
                          print("Long press");
                          try {
                            if (isRecording) return;
                            await controller!.startVideoRecording();
                            setState(() {
                              isRecording = true;
                            });
                          } on CameraException catch (e) {
                            print(e.code);
                          }
                        },
                        onLongPressEnd: (e) async {
                          print("Long press end");
                          try {
                            final temp = await controller!.stopVideoRecording();
                            setState(() {
                              isRecording = false;
                            });
                            File tempu = File(temp.path);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoViewScreen(
                                  file: tempu,
                                ),
                              ),
                            );
                          } on CameraException catch (e) {
                            print(e.code);
                          }
                        },
                        child: IconButton(
                          onPressed: () {},
                          icon: isRecording
                              ? Icon(
                                  FontAwesomeIcons.video,
                                  color: Colors.white,
                                  size: 40,
                                )
                              : Icon(
                                  FontAwesomeIcons.circle,
                                  color: Colors.white,
                                  size: 40,
                                ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.cameraRetro,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Hold to record a Video',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
