import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram/Providers/UserProvider.dart';
import 'package:instagram/Screens/SocialAuthCredentialCheckerScreen.dart';
import 'package:instagram/widgets/LoadingIndiactor.dart';
import 'package:provider/provider.dart';

class SocialAuthProviders extends ChangeNotifier {
  final googleSignin = GoogleSignIn();
  final facebookauthInstance = FacebookAuth.instance;

  GoogleSignInAccount? _user;

  GoogleSignIn? googleSignIn;

  GoogleSignInAccount get user => _user!;

  Future signInWithFacebook(context) async {
    try {
      showDialog(context: context, builder: (context) => CircularIndicator());
      final LoginResult loginResult = await FacebookAuth.instance.login();
      print(loginResult.message);
      if (loginResult.status == LoginStatus.failed) {
        print("Problem Signing with Facebook");
        Navigator.pop(context);
        return;
      }
      if (loginResult.status == LoginStatus.cancelled) {
        print("Cancelled Signing with Facebook");
        Navigator.pop(context);
        return;
      }

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      print(facebookAuthCredential);

      await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential)
          .then(
        (value) {
          print("Logged in with Facebook");
          Provider.of<UserProfile>(context, listen: false).changeProfile();
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SocailAuthCheckerScreen(),
              ));
        },
      );

      return;
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future googleLogin(context) async {
    try {
      showDialog(context: context, builder: (context) => CircularIndicator());
      final googleUser = await googleSignin.signIn();
      if (googleUser == null) {
        print("No users in Google Sign in");
        Navigator.pop(context);
        return;
      }
      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential).then(
        (value) async {
          print("Logged in with Google");
          Navigator.pop(context);
          Provider.of<UserProfile>(context, listen: false).changeProfile();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SocailAuthCheckerScreen(),
            ),
          );
          return;
        },
      ).catchError((e) {
        print("////////////////////");
        print(e.toString());
      });

      notifyListeners();
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future signout() async {
    await googleSignin.disconnect();
    await FirebaseAuth.instance.signOut();
    await facebookauthInstance.logOut();
  }
}
