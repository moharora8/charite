import '../Store/storehome.dart';

import '../Widgets/customTextField.dart';
import '../dialogs/errorDialog.dart';
import '../dialogs/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';
import '../globals.dart' as globals;

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
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
                    data: Icons.person_outline,
                    controller: _emailController,
                    hintText: 'Email',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock_outline,
                    controller: _passwordController,
                    hintText: 'Password',
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                _emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty
                    ? _login()
                    : showDialog(
                        context: context,
                        builder: (con) {
                          return ErrorAlertDialog(
                            message: 'Please fill the desired fields',
                          );
                        });
              },
              color: Colors.redAccent,
              child: Text('Log in'),
            ),
            SizedBox(height: 20),
            InkWell(
                onTap: () {
                  setState(() {
                    globals.abcd2 = true;
                  });
                },
                child:
                    Text('New User? Sign Up', style: TextStyle(fontSize: 18))),
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
//////////sign in
Future readDataToDataBase(FirebaseUser currentUser) async {
  String reduced_uid = currentUser.uid.substring(0, 4);
  print('currentUser.uid');
  print(currentUser.uid);
  print('reduced_uid');
  print(reduced_uid);
  await CharityApp.firestore
      .collection('users')
      .document(currentUser.uid)
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
    await CharityApp.sharedPreferences.setString(
        CharityApp.userPhone, snapshot.data[CharityApp.userPhone]);

    // print(snapshot.data[CharityApp.userCartList]);
    // List<String> cart = snapshot.data[CharityApp.userCartList].cast<String>();
    // await CharityApp.sharedPreferences.setStringList(CharityApp.userCartList, cart);
  });
}

final FirebaseAuth _auth = FirebaseAuth.instance;
