import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Screens/ShowSinglePostScreen.dart';

class DynamicLinkAPI {
  void initDynamicLinks(context) async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        print(deepLink.queryParameters.toString());
        print(deepLink.queryParameters['postID']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SinglePostScreen(
              postID: deepLink.queryParameters['postID']!,
            ),
          ),
        );
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      print(deepLink.queryParameters.toString());
    }
  }

  Future createDynamicLink(bool short, String postID , String imageURL) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://cloneins.page.link',
        link: Uri.parse('https://dynamic.link.example?postID=$postID'),
        androidParameters: AndroidParameters(
          packageName: 'com.sarthak.instagram',
          minimumVersion: 0,
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          description: "Hey! Please checkout my new Post",
          title: "New Post",
          imageUrl: Uri.parse("$imageURL")
        ));

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
      print(url);
    } else {
      url = await parameters.buildUrl();
    }
    return url;
  }
}
