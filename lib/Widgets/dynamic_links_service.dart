import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'testScreen.dart';
import '../Config/config.dart';

class DynamicLinkService {
  Future<Uri> createDynamicLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://instantrolley.page.link',
      link: Uri.parse('https://instantrolley.page.link.com/?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.be_project',
        minimumVersion: 1,
      ),
    );
    var dynamicUrl = await parameters.buildUrl();
    print(dynamicUrl);
    return dynamicUrl;
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('id')) {
          String id = deepLink.queryParameters['id'];
          String newString = id.substring(id.length - 28);
          print('String : $newString');

          //////////////////////
          CharityApp.firestore
              .collection('users')
              .document(
                  CharityApp.sharedPreferences.getString(CharityApp.userUID))
              .collection('referral')
              .document(newString)
              .setData({'receipent': newString}, merge: true);
          //////////////////////
          //users->doc->referral->doc->

          //from String newString
          //to List[] empty
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TestScreen(id: newString)));
        }
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => TestScreen()));
      }
      print('I am in else');
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TestScreen()));
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
