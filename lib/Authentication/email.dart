import 'dart:io';
import '../Store/storehome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/customTextField.dart';
import '../dialogs/errorDialog.dart';
import '../dialogs/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import '../home_screen.dart';
import '../config/config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _fbm = FirebaseMessaging();
  String _message = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  String userPhotoUrl = "";
  File _image;

  Future<void> _pickImage() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> uploadImage() async {
    if (_image == null) {
      showDialog(
          context: context,
          builder: (v) {
            return ErrorAlertDialog(
              message: "Please pick an photo",
            );
          });
    } else {
      _passwordController.text == _passwordConfirmController.text &&
              (_phoneController.text.isNotEmpty &&
                  _phoneController.text.length == 10)
          ? _emailController.text.isNotEmpty &&
                  _passwordConfirmController.text.isNotEmpty &&
                  _nameController.text.isNotEmpty
              ? upload()
              : showMyDialog('Please fill the desired fields')
          : showMyDialog('Password doesn\'t match');
    }
  }

  upload() async {
    showDialog(
        context: context,
        builder: (_) {
          return LoadingAlertDialog();
        });
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(_image);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then((url) {
      userPhotoUrl = url;
      print(userPhotoUrl);
      _register();
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            InkWell(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: _screenWidth * 0.15,
                  backgroundColor: Colors.white,
                  backgroundImage: _image == null ? null : FileImage(_image),
                  child: _image == null
                      ? Icon(
                          Icons.person_add,
                          size: _screenWidth * 0.15,
                          color: Colors.grey,
                        )
                      : null,
//                        backgroundImage: _image == null
//                            ? AssetImage('assets/images/loading.png')
//                            : FileImage(_image)
                )),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    data: Icons.person_outline,
                    controller: _nameController,
                    hintText: 'Name',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data: Icons.person_outline,
                    controller: _emailController,
                    hintText: 'Email',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    maxlength: 10,
                    type1: TextInputType.number,
                    data: Icons.phone,
                    controller: _phoneController,
                    hintText: 'Phone',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock_outline,
                    controller: _passwordController,
                    hintText: 'Password',
                    isObsecure: true,
                  ),
                  CustomTextField(
                    data: Icons.lock_outline,
                    controller: _passwordConfirmController,
                    hintText: 'Confirm passsword',
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                uploadImage();
              },
              color: Colors.redAccent,
              child: Text('Sign up'),
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

  void _register() async {
    FirebaseUser currentUser;
    await _auth
        .createUserWithEmailAndPassword(
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
      writeDataToDataBase(currentUser).then((s) {
        Navigator.pop(context);
        Route newRoute = MaterialPageRoute(
            builder: (_) => StoreHome(
                  currentIndex: 2,
                ));
        Navigator.pushReplacement(context, newRoute);
        // Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
        // Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future writeDataToDataBase(FirebaseUser currentUser) async {
    String reduced_uid = currentUser.uid.substring(0, 4);
    String fcmToken = await _fbm.getToken();
    if (fcmToken != null) {
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
      ////////////////
      CharityApp.firestore.collection('users').document(reduced_uid).setData({
        CharityApp.userUID: reduced_uid,
        CharityApp.userEmail: currentUser.email,
        CharityApp.userName: _nameController.text,
        CharityApp.userAvatarUrl: userPhotoUrl,
        CharityApp.userPhone: _phoneController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });
    } else {
      CharityApp.firestore.collection('users').document(reduced_uid).setData({
        CharityApp.userUID: reduced_uid,
        CharityApp.userEmail: currentUser.email,
        CharityApp.userName: _nameController.text,
        CharityApp.userPhone: _phoneController.text,
        CharityApp.userAvatarUrl: userPhotoUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });
    }

    await CharityApp.sharedPreferences
        .setString(CharityApp.userUID, reduced_uid);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userEmail, currentUser.email);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userName, _nameController.text);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userAvatarUrl, userPhotoUrl);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userPhone, _phoneController.text);
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
}

final FirebaseAuth _auth = FirebaseAuth.instance;
