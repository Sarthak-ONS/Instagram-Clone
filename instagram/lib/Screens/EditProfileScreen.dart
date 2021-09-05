import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Providers/PostProvider.dart';
import 'package:instagram/Providers/UserProvider.dart';
import 'package:instagram/Services/HelperMethod.dart';
import 'package:instagram/widgets/AuthWidgets.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../BrandColors.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _username = TextEditingController();

  final TextEditingController _name = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _webiste = TextEditingController();

  Widget space() {
    return SizedBox(
      height: 15.0,
    );
  }

  Future updateProfile(context) async {
    bool validForUpdate = _username.text ==
            Provider.of<UserProfile>(context, listen: false)
                .userdata
                .userName! &&
        _name.text ==
            Provider.of<UserProfile>(context, listen: false)
                .userdata
                .fullName! &&
        _email.text ==
            Provider.of<UserProfile>(context, listen: false).userdata.email! &&
        _webiste.text ==
            Provider.of<UserProfile>(context, listen: false)
                .userdata
                .website! &&
        image == null;

    if (validForUpdate) return;
    Map<String, Object> mapForUpdation = {};
    if (_username.text !=
        Provider.of<UserProfile>(context, listen: false).userdata.userName!) {
      bool userNameAlreadyExists =
          await HelperMethods().checkUsernameAlreadyExists(_username.text);
      if (userNameAlreadyExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
            content: Text('Username Already Exists'),
          ),
        );
        return;
      }

      mapForUpdation['username'] = _username.text;
    }
    if (_name.text !=
        Provider.of<UserProfile>(context, listen: false).userdata.fullName!) {
      mapForUpdation['Name'] = _name.text;
    }
    if (_webiste.text !=
        Provider.of<UserProfile>(context, listen: false).userdata.website!) {
      mapForUpdation['website'] = _webiste.text;
    }
    if (image != null) {
      updateImage();
    }

    print("Valid For Updation");
    print(mapForUpdation);
    try {
      await HelperMethods().updateCurrentUserProfile(mapForUpdation);
      HelperMethods().updatePhotoUrlinAllPosts(
        FirebaseAuth.instance.currentUser!.uid,downloadUrl!
      );

      Provider.of<UserProfile>(context, listen: false).changeProfile();
      Provider.of<PostProvider>(context, listen: false).getPosts();

      Navigator.pop(context);
    } catch (e) {}
  }

  pickImages(imageSource, context) async {
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
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  File? image;

  String? downloadUrl;

  updateImage() async {
    String url = await FirebaseStorageAPI().getDownloadUrl(image!);
    this.downloadUrl = url;
    HelperMethods().updatePhotoUrl(url, FirebaseAuth.instance.currentUser!.uid);
    Provider.of<UserProfile>(context, listen: false).changeProfile();
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
                    pickImages(ImageSource.camera, context);
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
                    pickImages(ImageSource.gallery, context);
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
    _username.text = Provider.of<UserProfile>(context).userdata.userName!;
    _name.text = Provider.of<UserProfile>(context).userdata.fullName!;
    _email.text = Provider.of<UserProfile>(context).userdata.email!;
    _webiste.text = Provider.of<UserProfile>(context).userdata.website!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          SizedBox(
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                LineIcons.arrowLeft,
                color: Colors.black,
              ),
            ),
          ),
        ],
        title: Row(
          children: [
            Icon(
              LineIcons.user,
              color: Colors.black,
              size: 35,
            ),
            space(),
            Text(
              Provider.of<UserProfile>(context).userdata.userName!,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Brand-Bold',
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  chooseImage(context);
                },
                child: Container(
                  child: Stack(
                    children: [
                      ClipOval(
                        child: image != null
                            ? Image.file(
                                image!,
                                height: 95,
                                width: 95,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                Provider.of<UserProfile>(context)
                                    .userdata
                                    .photoUrl!,
                                height: 95,
                                width: 95,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: ClipOval(
                          child: Container(
                            color: Colors.blueAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                FontAwesomeIcons.pen,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              space(),
              UserIDEditContainer(
                userId: _username,
                inputtext: "Change your username",
              ),
              space(),
              UserIDEditContainer(userId: _name, inputtext: "Change Your Name"),
              space(),
              TextField(
                enabled: !FirebaseAuth.instance.currentUser!.emailVerified,
                controller: _email,
                decoration: new InputDecoration(
                  hintText: "Update Your Email",
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: FirebaseAuth.instance.currentUser!.emailVerified
                        ? Icon(
                            LineIcons.check,
                            color: Colors.blueAccent,
                          )
                        : IconButton(
                            onPressed: () {},
                            icon: Icon(LineIcons.exclamation)),
                  ),
                  border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black),
                  ),
                  isDense: true,
                ),
              ),
              space(),
              UserIDEditContainer(
                  userId: _webiste, inputtext: "Change Your website"),
              space(),
              TextField(
                obscureText: true,
                decoration: new InputDecoration(
                  hintText: "Update Your Password",
                  border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.black),
                  ),
                  isDense: true,
                ),
              ),
              LoginContainer(
                  onpressed: () {
                    // FirebaseAuth.instance.currentUser!.updateEmail();
                    updateProfile(context);
                  },
                  title: "Update Profile")
            ],
          ),
        ),
      ),
    );
  }
}

class FirebaseStorageAPI {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future getDownloadUrl(File file) async {
    TaskSnapshot task = await _firebaseStorage
        .ref(
            '${FirebaseAuth.instance.currentUser!.uid}/Profile/${file.path.split("/").last}')
        .putFile(file);
    print(task.ref.getDownloadURL());
    return await task.ref.getDownloadURL();
  }
}
