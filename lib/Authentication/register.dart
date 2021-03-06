import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../Widgets/customTextField.dart';
import '../dialogs/errorDialog.dart';
import '../dialogs/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import '../Config/config.dart';
import '../Config/config2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

final TextEditingController _nameController = TextEditingController();

class _RegisterState extends State<Register> {
  String numb;
  bool _isSMSsent = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  // ignore: unused_field
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  // ignore: unused_field
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  String userPhotoUrl = "";
  File _image;

  Future<void> _pickImage() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  final _fbm = FirebaseMessaging();
  Future<void> uploadImage() async {
    // if (_image == null) {
    //   showDialog(
    //       context: context,
    //       builder: (v) {
    //         return ErrorAlertDialog(
    //           message: "Please pick an photo",
    //         );
    //       });
    // }
    // else {
    //_phoneNumber.phoneNumber.length == 10
    // == _passwordConfirmController.text
    // ?
    _emailController.text.isNotEmpty &&
            //_passwordConfirmController.text.isNotEmpty &&
            _nameController.text.isNotEmpty &&
            check(_emailController.text)
        ? _signInWithPhoneNumber()
        //upload()
        : showMyDialog('Please fill the desired fields');
    //: showMyDialog('Please enter correct phone number');
    // }
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
      _signInWithPhoneNumber();
      //_register();
    });
  }

  PhoneNumber _phoneNumber;

  String _message;
  String _verificationId;

  //bool _isSMSsent = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  final TextEditingController _smsController = TextEditingController();

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
            // InkWell(
            //     onTap: _pickImage,
            //     child: CircleAvatar(
            //       radius: _screenWidth * 0.15,
            //       backgroundColor: Colors.white,
            //       backgroundImage: _image == null ? null : FileImage(_image),
            //       child: _image == null
            //           ? Icon(
            //               Icons.person_add,
            //               size: _screenWidth * 0.15,
            //               color: Colors.grey,
            //             )
            //           : null,
            //       //                        backgroundImage: _image == null
            //       //                            ? AssetImage('assets/images/loading.png')
            //       //                            : FileImage(_image)
            //     )),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    type1: TextInputType.text,
                    data: Icons.person_outline,
                    controller: _nameController,
                    hintText: 'Name',
                    isObsecure: false,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      // validator: (input) =>
                      //     check(input) ? null : "Check your email",
                      keyboardType: TextInputType.text,
                      //maxLength: maxlength,
                      controller: _emailController,
                      obscureText: false,
                      cursorColor: Color(0xFFDA281C),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Color(0xFFDA281C),
                          ),
                          focusColor: Color(0xFFDA281C),
                          hintText: 'Email'),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                // SizedBox(
                //   height: 120,
                // ),
                Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: InternationalPhoneNumberInput(
                      autoValidate: true,
                      formatInput: false,
                      //selectorConfig:SelectorConfig(),
                      //initialValue: PhoneNumber(isoCode: 'IN'),
                      onInputChanged: (phoneNumberTxt) {
                        _phoneNumber = phoneNumberTxt;
                        numb = _phoneNumber.parseNumber();
                      },
                      inputBorder: OutlineInputBorder(gapPadding: 0),
                      initialCountry2LetterCode: 'IN',
                    )),
                _isSMSsent == true
                    ? Container(
                        margin: EdgeInsets.all(10),
                        child: TextField(
                          controller: _smsController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "OTP here",
                            labelText: "OTP",
                          ),
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                        ),
                      )
                    : Container(),
                _isSMSsent == false
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            _isSMSsent = true;
                            _verifyPhoneNumber();
                            // if (numb.length == 10) {
                            //   _isSMSsent = true;
                            // } else {
                            //   showMyDialog('Please fill valid number');
                            // }
                          });
                          // if (numb.length == 10) {
                          //   //_isSMSsent = true;
                          //   _verifyPhoneNumber();
                          // }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              // gradient: LinearGradient(
                              //   colors: [primaryColor, secondaryColor],
                              // ),
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8)),
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 20,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 20,
                          ),
                          child: Center(
                              child: Text(
                            "Send OTP",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          uploadImage();
                          //_signInWithPhoneNumber();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8)),
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 20,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 20,
                          ),
                          child: Center(
                              child: Text(
                            "Verify OTP",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                        ),
                      ),
              ],
            ),
            // RaisedButton(
            //   onPressed: () {
            //     uploadImage();
            //   },
            //   color: Colors.redAccent,
            //   child: Text('Sign up'),
            // ),
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
      });
    }
  }

  void _verifyPhoneNumber() async {
    setState(() {
      _message = '';
    });

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _message = 'Received phone auth credential: $phoneAuthCredential';
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        _message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber.phoneNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  bool check(String s) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(s);
  }

  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    if (currentUser != null) {
      CharityApp.sharedPreferences.setString(CharityApp.authtype, 'phoneauth');
      writeDataToDataBase(currentUser);
      //.then((s) {
      //Navigator.pop(context);
      Route newRoute = MaterialPageRoute(
          builder: (_) => StoreHome(
                currentIndex: 2,
              ));
      Navigator.pushReplacement(context, newRoute);
      //});

      _message = 'Successfully signed in, uid: ' + user.uid;

      print(_message);
    } else {
      _message = 'Sign in failed';
    }
  }

  writeDataToDataBase(FirebaseUser currentUser) async {
    String reduced_uid = currentUser.uid.substring(0, 4);
    String fcmToken = await _fbm.getToken();
    if (fcmToken != null) {
      await CharityApp.firestore
          .collection(CharityApp.collectionUser)
          .document(reduced_uid)
          .setData({
        CharityApp.userUID: reduced_uid,
        CharityApp.userEmail: _emailController.text,
        CharityApp.userPhone: currentUser.phoneNumber,
        CharityApp.userName: _nameController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
        // CharityApp.userAvatarUrl: userPhotoUrl
      }, merge: true);
      ////
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
      await CharityApp.firestore
          .collection(CharityApp.collectionUser)
          .document(reduced_uid)
          .setData({
        CharityApp.userUID: reduced_uid,
        CharityApp.userEmail: _emailController.text,
        CharityApp.userPhone: currentUser.phoneNumber,
        CharityApp.userName: _nameController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
        // CharityApp.userAvatarUrl: userPhotoUrl
      }, merge: true);
    }
    // await CharityApp.firestore
    //     .collection(CharityApp.collectionUser)
    //     .document(reduced_uid)
    //     .setData({
    //   CharityApp.userUID: reduced_uid,
    //   CharityApp.userEmail: _emailController.text,
    //   CharityApp.userPhone: currentUser.phoneNumber,
    //   CharityApp.userName: _nameController.text,
    //   // CharityApp.userAvatarUrl: userPhotoUrl
    // }, merge: true);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userUID, reduced_uid);
    await CharityApp.sharedPreferences
        .setStringList(CharityApp.userCartList, ['garbageValue']);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userEmail, _emailController.text);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userPhone, currentUser.phoneNumber);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userName, _nameController.text);

    DocumentReference _db2 = CharityApp.firestore
        .collection(CharityApp.collectionUser)
        .document(reduced_uid);

    _db2.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data}');
        print('Subscribe:  ');
        print(documentSnapshot.data['is_subscribe']);
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

    // await CharityApp.sharedPreferences
    //     .setString(CharityApp.userAvatarUrl, userPhotoUrl);
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

//final FirebaseAuth _auth = FirebaseAuth.instance;
