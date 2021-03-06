import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/config.dart';

class Database {
  retrieveUserInfo() async {
    DocumentSnapshot userInfo = await CharityApp.firestore
        .collection(CharityApp.collectionUser)
        .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
        .get();

    return userInfo;
  }
}
