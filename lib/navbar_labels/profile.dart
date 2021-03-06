import 'package:flutter/material.dart';
// import '../widgets/homecontainer.dart';
// import '../Widgets/categcont.dart';
// import '../Widgets/button.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/customtextfield.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import '../Config/config.dart';
import '../Widgets/errorDialog.dart';
import '../globals.dart' as globals;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //int timestamp;
  String url = '';
  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;

    if (fileType == 'others') {
      storageReference = FirebaseStorage.instance.ref().child(
          "${CharityApp.sharedPreferences.getString(CharityApp.userUID)}/$filename");
    }
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
  }

  Future filePicker(BuildContext context) async {
    try {
      if (fileType == 'others') {
        file = await FilePicker.getFile(type: FileType.ANY);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        _uploadFile(file, fileName);
      }
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  String fileType = '';
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(
      text: CharityApp.sharedPreferences.getString(CharityApp.userEmail));
  final TextEditingController _nameController = TextEditingController(
      text: CharityApp.sharedPreferences.getString(CharityApp.userName));
  int timestamp = CharityApp.sharedPreferences.getInt('dob');
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: CharityApp.sharedPreferences.getInt('dob') == null
            ? selectedDate
            : DateTime.fromMillisecondsSinceEpoch(
                CharityApp.sharedPreferences.getInt('dob')),
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2023));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        timestamp = selectedDate.millisecondsSinceEpoch;
        CharityApp.sharedPreferences.setInt('dob', timestamp);
        globals.dt = selectedDate;
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

  writeDataToDataBase() async {
    await CharityApp.firestore
        .collection('users')
        .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
        .setData({
      'email': _emailController.text,
      'name': _nameController.text,
      // CharityApp.isverified: false,
      'profileupdatedat': FieldValue.serverTimestamp(),
      'url': CharityApp.sharedPreferences.getString(CharityApp.userAvatarUrl) ==
              null
          ? url.toString()
          : CharityApp.sharedPreferences.getString(CharityApp.userAvatarUrl),
      'dob': CharityApp.sharedPreferences.getInt('dob') == null
          ? selectedDate
          : DateTime.fromMillisecondsSinceEpoch(
              CharityApp.sharedPreferences.getInt('dob')),
    }, merge: true);

    await CharityApp.sharedPreferences
        .setString(CharityApp.userEmail, _emailController.text);
    await CharityApp.sharedPreferences
        .setString(CharityApp.userName, _nameController.text);
    if (url != null) {
      await CharityApp.sharedPreferences
          .setString(CharityApp.userAvatarUrl, url);
    }
    //await CharityApp.sharedPreferences.setInt('dob', timestamp);
    // await CharityApp.sharedPreferences
    //     .setString(CharityApp.profilecreated, 'true');
    showMyDialog('Profile Created Successfully');
  }

  bool check(String s) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(s);
  }

  void _submit() {
    _emailController.text.isNotEmpty &&
            _nameController.text.isNotEmpty &&
            (selectedDate != null ||
                (DateTime.fromMillisecondsSinceEpoch(
                            CharityApp.sharedPreferences.getInt('dob')) !=
                        null) &&
                    check(_emailController.text))
        ? writeDataToDataBase()
        : showMyDialog('Please fill the desired fields');
  }

  List<String> l = [
    'Groceries',
    'Vegetables',
    'Food Items',
    'Raw Meat & Fish',
    'Others',
    'Combined List'
  ];
  int index2 = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
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
                      keyboardType: TextInputType.text,
                      controller: _emailController,
                      obscureText: false,
                      cursorColor: Colors.black,
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
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: EdgeInsets.all(14.0),
                      margin: EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Color(0xFFDA281C),
                            ),
                            Text('    D.O.B '),
                            SizedBox(
                              width: 40.0,
                            ),
                            Text(CharityApp.sharedPreferences.getInt('dob') ==
                                    null
                                ? '${selectedDate.toLocal()}'.split(' ')[0]
                                : '${(DateTime.fromMillisecondsSinceEpoch(CharityApp.sharedPreferences.getInt('dob')).toLocal())}'
                                    .split(' ')[0]),
                          ],
                        ),
                      )),
                  RaisedButton(
                    child: Text('Upload Avatar'),
                    onPressed: () {
                      setState(() {
                        fileType = 'others';
                      });
                      filePicker(context);
                    },
                  ),
                  Text(
                    fileName,
                    style: TextStyle(color: Colors.blue),
                  ),
                  RaisedButton(
                    onPressed: _submit,
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
