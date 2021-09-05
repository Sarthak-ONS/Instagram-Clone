import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Providers/AppData.dart';
import 'package:instagram/Providers/PostProvider.dart';
import 'package:instagram/Providers/UserProvider.dart';
import 'package:instagram/Screens/HomePageScreen.dart';
import 'package:instagram/Services/HelperMethod.dart';
import 'package:instagram/widgets/AuthWidgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_compress/video_compress.dart';

import '../../BrandColors.dart';
import 'SelectLocationScreen.dart';

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
    getCompressVideo(widget.file!);
    _controller = VideoPlayerController.file(widget.file!)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  bool isPlaying = false;
  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  File? videoFile;

  void pickIamge() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final file = File(pickedFile.path);
    setState(() {
      videoFile = file;
    });
  }

  MediaInfo? compressVideoFile;

  Future getCompressVideo(File file) async {
    try {
      final mediaInfoFile = await VideoCompress.compressVideo(file.path,
          quality: VideoQuality.MediumQuality,
          includeAudio: true,
          deleteOrigin: true);
      this.compressVideoFile = mediaInfoFile;
      print(mediaInfoFile!.filesize);
      print(mediaInfoFile.path);
      uploadToDatabase();
    } catch (e) {
      VideoCompress.cancelCompression();
    }
  }

  String? downloadurl;

  Future uploadToDatabase() async {
    try {
      if (compressVideoFile == null) return;
      File mediaInfo = File(compressVideoFile!.path.toString());
      TaskSnapshot task = await FirebaseStorage.instance
          .ref(
              'usersProfile/${FirebaseAuth.instance.currentUser!.uid}/posts/${mediaInfo.path.split("/").last}')
          .putFile(mediaInfo);
      String downloadURL = await task.ref.getDownloadURL();
      this.downloadurl = downloadURL;
      print(downloadURL);
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
        ),
        Scaffold(
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
              GestureDetector(
                onTap: () {
                  if (isPlaying == false) {
                    _controller!.play();
                  }
                  if (isPlaying) {
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
                    child: _controller!.value.isPlaying
                        ? Icon(
                            FontAwesomeIcons.pause,
                            color: Colors.white,
                          )
                        : Icon(
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
                      GestureDetector(
                        onTap: () {
                          print(compressVideoFile!.path!.split("/").last);
                          print(downloadurl);
                          createPost();
                        },
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          child: CircleAvatar(
                            child: Icon(LineIcons.check),
                          ),
                        ),
                      )
                    ],
                  ),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                left: 15,
                bottom: 75,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchLocationPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0)),
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      Provider.of<AppData>(context)
                                  .userSelectedCurrentLocation ==
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future createPost() async {
    try {
      print("Inside Create Post Method");
      HelperMethods()
          .uploadNewVideoPost(
              "video",
              _caption.text,
              Provider.of<AppData>(context, listen: false)
                  .deviceModel
                  .toString(),
              Provider.of<AppData>(context, listen: false).getCurrentTime,
              Provider.of<UserProfile>(context, listen: false)
                  .userdata
                  .userName
                  .toString(),
              downloadurl.toString(),
              Provider.of<AppData>(context, listen: false)
                  .userSelectedCurrentLocation
                  .toString(),
              Provider.of<UserProfile>(context, listen: false)
                  .userdata
                  .photoUrl
                  .toString())
          .then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomePageScreen.id, (route) => false);
        Provider.of<PostProvider>(context, listen: false).getPosts();
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
