import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/BrandColors.dart';
import 'package:instagram/Screens/HomePageScreen.dart';
import 'package:instagram/Services/HelperMethod.dart';
import 'package:instagram/widgets/AuthWidgets.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class CreateUserProfileScreen extends StatefulWidget {
  const CreateUserProfileScreen({Key? key}) : super(key: key);

  @override
  _CreateUserProfileScreenState createState() =>
      _CreateUserProfileScreenState();
}

class _CreateUserProfileScreenState extends State<CreateUserProfileScreen> {
  TextEditingController _userName = TextEditingController();
  TextEditingController _bio = TextEditingController();
  TextEditingController _website = TextEditingController();
  TextEditingController _name = TextEditingController();

  Future selectImage(imageSource) async {
    try {
      final image = await ImagePicker().pickImage(
        source: imageSource,
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

  String downloadURL = "";

  uploadFileToDatabase() async {
    try {
      if (image != null) {
        print("Started Uploading image to Storage");
        File file = File(image!.path);
        TaskSnapshot task = await FirebaseStorage.instance
            .ref('usersProfile/${FirebaseAuth.instance.currentUser!.uid}')
            .putFile(file);
        String downloadUrl = await task.ref.getDownloadURL();
        this.downloadURL = downloadUrl;
        print(downloadUrl);
        await HelperMethods().updatePhotoUrl(
            downloadURL, FirebaseAuth.instance.currentUser!.uid);
      }
    } catch (e) {
      print(e);
    }
  }

  File? image;

  removeImage() {
    print("Removing Image from the Widget");
    print(image!.path);
  }

  void createProfile(context) async {
    try {
      await selectUsername(_userName.text);
      if (isUsernameValid) {
        uploadFileToDatabase();
        await HelperMethods()
            .createProfile(
          _userName.text,
          _name.text,
          _bio.text,
          _website.text,
          downloadURL,
        )
            .then((value) {
          print("User profile is Succesfully Created");
          Navigator.pushNamedAndRemoveUntil(
              context, HomePageScreen.id, (route) => false);
        }).catchError((e) {
          print(e.toString());
        });
      } else {
        final SnackBar snackBar = SnackBar(
          elevation: 2,
          content: Text(
            'Username is already in use',
            style: TextStyle(fontFamily: 'Brand-Regular'),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black,
          duration: Duration(
            seconds: 3,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {}
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
                    selectImage(ImageSource.camera);
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
                    selectImage(ImageSource.gallery);
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

  bool isUsernameValid = false;

  selectUsername(username) async {
    print("Checking Username validity for $username");

    final result = await HelperMethods().checkUsernameAlreadyExists(username);
    print("Username Validation ${!result}");
    setState(() {
      isUsernameValid = !result;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? name = FirebaseAuth.instance.currentUser!.displayName;

    if (name != null) {
      _name.text = name.toString();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Instagram',
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 40,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  'Welcome to the Network',
                  style: TextStyle(
                    fontFamily: 'Brand-Bold',
                    fontSize: 35,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Create Your Profile',
                style: TextStyle(
                  fontFamily: 'Brand-Bold',
                  fontSize: 20,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 25,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: () {
                              chooseImage(context);
                            },
                            child: Container(
                              child: ClipOval(
                                child: Image.file(
                                  image!,
                                  height: 95,
                                  width: 95,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                print(
                                    "Initiating Process for Selecting Profile Image");
                                chooseImage(context);
                              },
                              child: CircleAvatar(
                                backgroundColor: BrandColors.colorBackground,
                                radius: 40,
                                child: Center(
                                  child: LineIcon(
                                    LineIcons.plus,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _name,
                      decoration: new InputDecoration(
                        hintText: 'Please choose a username',
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                        ),
                        isDense: true,
                      ),
                      // style: _textStyleBlack,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onSubmitted: selectUsername,
                      controller: _userName,
                      decoration: new InputDecoration(
                        hintText: 'Please choose a username',
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                        ),
                        isDense: true,
                      ),
                      // style: _textStyleBlack,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    UserIDEditContainer(
                      userId: _bio,
                      inputtext: 'Please Enter a caption/Bio',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    UserIDEditContainer(
                      userId: _website,
                      inputtext: 'Wesite',
                    ),
                    LoginContainer(
                      onpressed: () {
                        print("Lets go");
                        createProfile(context);
                      },
                      title: 'Continue',
                    ),
                    image == null
                        ? Container()
                        : TextButton(
                            onPressed: removeImage,
                            child: Text('Remove'),
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
