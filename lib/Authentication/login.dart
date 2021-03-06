import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../Widgets/customTextField.dart';
import '../dialogs/errorDialog.dart';
import '../dialogs/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import '../Config/config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Config/config2.dart' as c;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _fbm = FirebaseMessaging();
  String _message = '';
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        // ignore: unused_local_variable
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Login to your account',
                style: TextStyle(color: Colors.red),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    maxlength: 10,
                    type1: TextInputType.number,
                    data: Icons.phone,
                    controller: _phoneController,
                    hintText: 'Phone',
                    isObsecure: false,
                  ),
                  // CustomTextField(
                  //   data: Icons.lock_outline,
                  //   controller: _passwordController,
                  //   hintText: 'Password',
                  //   isObsecure: true,
                  // ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                uploadImage();
              },
              color: c.primaryColor,
              //Colors.redAccent,
              child: Text('Log in', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 3,
              width: _screenWidth * 0.8,
              color: Colors.red,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  writeDataToDataBase(FirebaseUser currentUser) async {
    String reduced_uid = currentUser.uid.substring(0, 4);
    String fcmToken = await _fbm.getToken();
    if (fcmToken != null) {
      CharityApp.firestore
          .collection(CharityApp.collectionUser)
          .document(reduced_uid)
          .setData({
        CharityApp.userUID: reduced_uid,
        CharityApp.userEmail: currentUser.email,
        CharityApp.userPhone: _phoneController.text,
        CharityApp.userName: currentUser.displayName,
        CharityApp.userAvatarUrl: currentUser.photoUrl,
        // 'token': fcmToken,
        'profilecreatedAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
        //CharityApp.isSubscribe: false,
      }, merge: true);
      CharityApp.firestore
          .collection(CharityApp.collectionUser)
          .document(reduced_uid)
          .collection('tokens')
          .document(fcmToken)
          .setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
        //CharityApp.isSubscribe: false,
      }, merge: true);
    } else {
      CharityApp.firestore
          .collection(CharityApp.collectionUser)
          .document(reduced_uid)
          .setData({
        CharityApp.userUID: reduced_uid,
        CharityApp.userEmail: currentUser.email,
        CharityApp.userPhone: _phoneController.text,
        CharityApp.userName: currentUser.displayName,
        CharityApp.userAvatarUrl: currentUser.photoUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
        //CharityApp.isSubscribe: false,
      }, merge: true);
    }

    await CharityApp.sharedPreferences
        .setString(CharityApp.userUID, reduced_uid);
    await CharityApp.sharedPreferences
        .setStringList(CharityApp.userCartList, ['garbageValue']);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userEmail, currentUser.email);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userPhone, _phoneController.text);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userName, currentUser.displayName);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userAvatarUrl, currentUser.photoUrl);
    //Check
    DocumentReference _db2 = CharityApp.firestore
        .collection(CharityApp.collectionUser)
        .document(
            CharityApp.sharedPreferences.getString(CharityApp.userUID));

    _db2.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data}');
        print('Subscribe:  ');
        print(documentSnapshot.data['is_subscribe']);
        if (documentSnapshot.data['wallet_amount'] == null) {
          CharityApp.firestore
              .collection(CharityApp.collectionUser)
              .document(reduced_uid)
              .setData({
            'wallet_amount': '0',
          }, merge: true);
        }
        if (documentSnapshot.data['is_subscribe'] == true) {
          CharityApp.sharedPreferences
              .setString(CharityApp.isSubscribe, 'true');
        } else {
          CharityApp.sharedPreferences
              .setString(CharityApp.isSubscribe, 'false');
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  showMyDialog(String message) {
    showDialog(
        context: context,
        builder: (con) {
          return ErrorAlertDialog(
            message: message,
          );
        });
  }

  Future<void> uploadImage() async {
    _phoneController.text.isNotEmpty && _phoneController.text.length == 10
        // &&
        //         _passwordController.text.isNotEmpty
        ? _signInUsingGoogle()
        //_login()
        : showDialog(
            context: context,
            builder: (con) {
              return ErrorAlertDialog(
                message: 'Please fill the correct number',
              );
            });
  }

  void _signInUsingGoogle() async {
    // try {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    print("Current User " + currentUser.uid);
    if (currentUser != null) {
      CharityApp.sharedPreferences.setString(CharityApp.authtype, 'gauth');
      writeDataToDataBase(currentUser);
      // .then((s) {
      //Navigator.pop(context);

      Route newRoute = MaterialPageRoute(
          builder: (_) => StoreHome(
                currentIndex: 2,
              ));
      Navigator.pushReplacement(context, newRoute);
      // });

      _message = 'Successfully signed in, uid: ' + currentUser.uid;

      print(_message);
    } else {
      _message = 'Sign in failed';
    }
    // }
    //  catch (e) {

    // }
  }

  void _login() async {
    showDialog(
        context: context,
        builder: (con) {
          return LoadingAlertDialog(
            message: 'Please wait',
          );
        });
    FirebaseUser currentUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (con) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      readDataToDataBase(currentUser).then((s) {
        Navigator.pop(context);
        // ignore: todo
        // TODO navigate to homescreen

        Route newRoute = MaterialPageRoute(
            builder: (_) => StoreHome(
                  currentIndex: 2,
                ));
        Navigator.pushReplacement(context, newRoute);
      });
    } else {
      //   _success = false;
    }
  }
}

Future readDataToDataBase(FirebaseUser currentUser) async {
  String reduced_uid = currentUser.uid.substring(0, 4);
  await CharityApp.firestore
      .collection(CharityApp.collectionUser)
      .document(reduced_uid)
      .get()
      .then((snapshot) async {
    print(snapshot.data);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userUID, snapshot.data[CharityApp.userUID]);
    await CharityApp.sharedPreferences.setString(
        CharityApp.userEmail, snapshot.data[CharityApp.userEmail]);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userName, snapshot.data[CharityApp.userName]);
    await CharityApp.sharedPreferences.setString(
        CharityApp.userAvatarUrl, snapshot.data[CharityApp.userAvatarUrl]);
    print(snapshot.data[CharityApp.userCartList]);
    List<String> cart = snapshot.data[CharityApp.userCartList].cast<String>();
    await CharityApp.sharedPreferences
        .setStringList(CharityApp.userCartList, cart);
  });
//      .setData({
//    DeliveryApp.userUID: reduced_uid,
//    DeliveryApp.userEmail: currentUser.email,
//  });
}

final FirebaseAuth _auth = FirebaseAuth.instance;
