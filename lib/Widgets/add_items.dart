import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Config/config2.dart' as c;
import '../Config/config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../notifiers/cartitemcounter.dart';
import '../Store/cart2.dart';
import 'package:provider/provider.dart';
import '../globals.dart' as globals;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../dialogs/loadingDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as pt;
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart' as p;
class AddItems extends StatefulWidget {
  AddItems({Key key}) : super(key: key);

  @override
  _AddItemsState createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  ///////////////////
  String url2 = '';
  Future<void> _uploadFile(
      String currentTime, File file, String filename2) async {
    StorageReference storageReference;

    if (fileType2 == 'others') {
      storageReference = FirebaseStorage.instance.ref().child(
          "${CharityApp.sharedPreferences.getString(CharityApp.userUID)}/uploads/$fileName2");
    }
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    url2 = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url2");
  }

  Future filePicker(String currentTime, BuildContext context) async {
    try {
      if (fileType2 == 'others') {
        file2 = await FilePicker.getFile(type: FileType.ANY);
        fileName2 = pt.basename(file2.path);
        setState(() {
          fileName2 = pt.basename(file2.path);
        });
        print(fileName2);
        _uploadFile(currentTime, file2, fileName2);
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

  String fileType2 = '';
  File file2;
  String fileName2 = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';

  ///
  int index2 = 0;
  // List temp = CharityApp.sharedPreferences.getStringList(
  //   CharityApp.userCartList,
  // );
  List urls = new List();
  List<File> files = new List();
  String userPhotoUrl = "";
  // Map<String, File> mp = new Map();
  // Map<String, String> mp2 = new Map();
  //id->File
  File _image;
  List<File> list = [];
  List<String> list2 = [];
  final TextEditingController _taskTxtController = TextEditingController();
  final TextEditingController _taskquantityController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();
////
  final picker = ImagePicker();
  Future pickImage2(File _imageFile) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  /////
  Future uploadImageToFirebase(
      BuildContext context, File _imageFile, String str) async {
    String fileName = pt.basename(_imageFile.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) {
      print("Done: $value");
      setState(() {
        str = value;
      });
    });
  }

  File image12;

  Map<dynamic, dynamic> lt;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage(String index) async {
    image12 = await ImagePicker.pickImage(source: ImageSource.gallery);
    globals.mp[index] = image12;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(
        '${CharityApp.sharedPreferences.getString(CharityApp.userUID)}/$fileName');
    StorageUploadTask uploadTask = reference.putFile(globals.mp[index]);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then((url) {
      setState(() {
        globals.mp2[index] = url;
        print('MP  : ${globals.mp2[index]}');
      });
      CharityApp.firestore
          .collection(CharityApp.collectionUser)
          .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
          .collection(CharityApp.userItem)
          .document(index)
          .setData({
        "pictureURL": globals.mp2[index],
      }, merge: true);
      CharityApp.firestore
          .collection(CharityApp.collectionUser)
          .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
          .collection(CharityApp.userItem2)
          .document(index)
          .setData({
        "pictureURL": globals.mp2[index],
      }, merge: true);
    });
  }

  Future<void> uploadImage() async {
    //upload();
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
    });
  }

  List temp = CharityApp.sharedPreferences.getStringList(
    CharityApp.userCartList,
  );
  double totalAmount;
  removeItemInCart(String productID) {
    print('Someone called me');
    // List temp = CharityApp.sharedPreferences.getStringList(
    //   CharityApp.userCartList,
    // );
    temp = CharityApp.sharedPreferences.getStringList(
      CharityApp.userCartList,
    );
    temp.remove(productID);
    //modified
    // temp.clear();
    // temp.add('garbageValue');
    CharityApp.firestore
        .collection(CharityApp.collectionUser)
        .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
        .updateData({CharityApp.userCartList: temp}).then((_) {
      Fluttertoast.showToast(msg: 'Item Removed Succesfully');
      CharityApp.sharedPreferences.setStringList(CharityApp.userCartList, temp);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
      totalAmount = 0;

      setState(() {});
    });
  }

  int k = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            temp = CharityApp.sharedPreferences.getStringList(
              CharityApp.userCartList,
            );
            if ((temp.length <= 15)
                //||(check if user is a subscriber or not)
                ) {
              _showAddTaskDialog();
            } else {
              Fluttertoast.showToast(msg: 'Cannot add more than that.');
            }
          },
          icon: Icon(Icons.add),
          label: Text('Tap here to add items'),
          elevation: 4,
          backgroundColor: c.primaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BottomAppBar(
      //   shape: CircularNotchedRectangle(),
      //   child: Row(
      //     mainAxisSize: MainAxisSize.max,
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: <Widget>[
      //       // Text('Click here to add items'),
      //       SizedBox(),
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        actions: [
          Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (_) => CartPage());
                  Navigator.push(context, route);
                },
              ),
              Positioned(
                  child: Stack(
                children: <Widget>[
                  Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: c.primaryColor.withOpacity(1),
                  ),
                  Positioned(
                      top: 3.0,
                      right: 4.0,
                      child: Center(
                        child: Consumer<CartItemCounter>(
                            builder: (context, counter, _) {
                          return Text(
                            counter.count != null
                                ? counter.count.toString()
                                : '0',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500),
                          );
                        }),
                      )),
                ],
              )),
            ],
          ),
        ],
        title: Text('ezCharge'),
      ),
      body: Container(
        child: StreamBuilder(
          stream: CharityApp.firestore
              .collection(CharityApp.collectionUser)
              .document(
                  CharityApp.sharedPreferences.getString(CharityApp.userUID))
              .collection(CharityApp.userItem)
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.isNotEmpty) {
                return ListView(
                  children: snapshot.data.documents.map((snap) {
                    File demo;
                    files.add(demo);
                    urls.add('');
                    print(snap.data['item']);
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 5,
                      ),
                      child: ListTile(
                        leading: InkWell(
                            onTap: () {
                              //pickImage2();
                              _pickImage(snap.documentID);
                              print('MP: ${globals.mp[snap.documentID]}');
                              print('MP2: ${globals.mp2[snap.documentID]}');
                              //k++;
                            },
                            // _pickImage,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.amber,
                              backgroundImage: globals.mp2[snap.documentID] ==
                                      null
                                  ? null
                                  : NetworkImage(globals.mp2[snap.documentID]),
                              // globals.mp2[snap.documentID] !=
                              //         null
                              //     ? NetworkImage(globals.mp2[snap.documentID])
                              //     : url2 != null
                              //         ? NetworkImage(url2)
                              //         : null,
                              child: globals.mp2[snap.documentID] == null
                                  ? Icon(
                                      Icons.add,
                                      size: 20,
                                      color: Colors.grey,
                                    )
                                  : null,
                              //  backgroundImage: _image == null
                              //                            ? AssetImage('assets/images/no_task.png')
                              //                            : FileImage(_image)
                            )),
                        // CircleAvatar(
                        //   radius: 30,
                        //   child: Padding(
                        //     padding: EdgeInsets.all(6),
                        //     child: FittedBox(
                        //       child: Icon(Icons.add),
                        //     ),
                        //   ),
                        // ),
                        title: Row(
                          children: [
                            Text(
                              snap.data["item"],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              '${snap.data["quantity"]}',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            IconButton(
                              color: Colors.red,
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showAddTaskDialog2(
                                    snap.documentID, snap.data['currentTime'],
                                    title: snap.data["item"],
                                    quantity2: snap.data["quantity"],
                                    description: snap.data["description"]);
                              },
                            ),
                          ],
                        ),
                        subtitle: Text(
                          snap.data["description"],
                        ),
                        trailing: IconButton(
                          padding: EdgeInsets.only(bottom: 12),
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            removeItemInCart(snap.data["item"]);
                            CharityApp.firestore
                                .collection(CharityApp.collectionUser)
                                .document(CharityApp.sharedPreferences
                                    .getString(CharityApp.userUID))
                                .collection(CharityApp.userItem)
                                .document(snap.documentID)
                                .delete();
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
                index2 = index2 + 1;
              } else {
                return Container(
                  child: Center(
                    child: Image(
                      image: AssetImage("assets/images/no_task.png"),
                    ),
                  ),
                );
              }
            }
            return Container(
              child: Center(
                child: Image(
                  image: AssetImage("assets/images/no_task.png"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool rememberMe = false;
  bool rememberMe2 = false;
  void _onRememberMeChanged() {
    setState(() {
      rememberMe = !rememberMe;
    });
  }

  void checkItemInCart(String productID, BuildContext context) {
    print(productID);
    CharityApp.sharedPreferences
            .getStringList(
              CharityApp.userCartList,
            )
            .contains(productID)
        ? Fluttertoast.showToast(msg: 'Product is already in cat')
        : temp.add(productID);
    CharityApp.firestore
        .collection(CharityApp.collectionUser)
        .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
        .updateData({CharityApp.userCartList: temp}).then((_) {
      Fluttertoast.showToast(msg: 'Item Added Succesfully');
      CharityApp.sharedPreferences.setStringList(CharityApp.userCartList, temp);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
  }

  void updateItemInCart(String productID, BuildContext context, String newID) {
    int y = temp.indexOf(productID);
    if (temp.contains(productID)) {
      setState(() {
        temp[y] = newID;
      });
      print('Done');
    }
    CharityApp.firestore
        .collection(CharityApp.collectionUser)
        .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
        .updateData({CharityApp.userCartList: temp}).then((_) {
      Fluttertoast.showToast(msg: 'Item Updated Succesfully');
      CharityApp.sharedPreferences.setStringList(CharityApp.userCartList, temp);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
  }

  void addToCart(String productID, BuildContext context) {
    temp = CharityApp.sharedPreferences.getStringList(
      CharityApp.userCartList,
    );
    temp.add(productID);
    CharityApp.firestore
        .collection(CharityApp.collectionUser)
        .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
        .updateData({CharityApp.userCartList: temp}).then((_) {
      Fluttertoast.showToast(msg: 'Item Added Succesfully');
      CharityApp.sharedPreferences.setStringList(CharityApp.userCartList, temp);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
  }

  void final_dialog() {
    TextEditingController _taskstoreController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState2) {
            return SimpleDialog(
              title: Text("Want to buy from specific store?"),
              children: [
                Row(
                  children: [
                    SizedBox(width: 30),
                    Text('Yes'),
                    Checkbox(
                        value: rememberMe,
                        onChanged: (bool newVal) {
                          setState2(() {
                            rememberMe = newVal;
                            if (rememberMe) {
                              rememberMe2 = false;
                            }
                          });
                        }),
                    SizedBox(width: 30),
                    Text('No'),
                    Checkbox(
                        value: rememberMe2,
                        onChanged: (bool newVal) {
                          setState2(() {
                            rememberMe2 = newVal;
                            if (rememberMe2) {
                              rememberMe = false;
                            }
                          });
                        }),
                  ],
                ),
                rememberMe == true
                    ? Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                        child: TextField(
                          controller: _taskstoreController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter Store name here",
                              labelText: "Store Name"),
                        ),
                      )
                    : SizedBox(),
                rememberMe == true || rememberMe2 == true
                    ? Center(
                        child: Row(
                          children: [
                            SizedBox(width: 30),
                            FlatButton(
                              color: c.primaryColor,
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            SizedBox(width: 30),
                            FlatButton(
                              color: c.primaryColor,
                              child: Text("Add to trolley"),
                              onPressed: () {
                                String store = _taskstoreController.text.trim();
                                setState(() {
                                  globals.storename = store;
                                });
                                CharityApp.firestore
                                    .collection(CharityApp.collectionUser)
                                    .document(CharityApp.sharedPreferences
                                        .getString(CharityApp.userUID))
                                    .collection(CharityApp.userOrderList)
                                    .document(DateTime.now().toString())
                                    .setData({
                                  "cart": lt,
                                  "store": globals.storename,
                                }, merge: true);
                                Navigator.of(context).pop();
                                Fluttertoast.showToast(
                                    msg: 'Items Added in Trolley Succesfully');
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            );
          });
        });
  }

//////////////
  void _showAddTaskDialog2(String id, String currentTime,
      {String title, String quantity2, String description}) {
    String pi = title;
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text("Edit product"),
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: TextField(
                  controller: _taskTxtController..text = '$title',
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write your product name here",
                      labelText: "Product Name"),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
                  controller: _taskquantityController..text = '$quantity2',
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write your product quantity here",
                      labelText: "Product quantity"),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
                  controller: _taskDescController..text = '$description',
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write your product description here",
                      labelText: "Product Description"),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                    RaisedButton(
                      color: c.primaryColor,
                      child: Text("Update"),
                      onPressed: () async {
                        String task = _taskTxtController.text.trim();
                        String desc = _taskDescController.text.trim();
                        //String cat = _taskCatController.text.trim();
                        String quantity = _taskquantityController.text.trim();
                        // int.parse(_taskquantityController.text).toString();
                        print(task);
                        String ni = task;
                        updateItemInCart(pi, context, ni);
                        String final_string = title + description + quantity2;
                        CharityApp.firestore
                            .collection(CharityApp.collectionUser)
                            .document(CharityApp.sharedPreferences
                                .getString(CharityApp.userUID))
                            .collection(CharityApp.userItem2)
                            .document(currentTime)
                            .setData({
                          "item": task,
                          "date": DateTime.now(),
                          "description": desc,
                          "quantity": quantity
                        }, merge: true);
                        CharityApp.firestore
                            .collection(CharityApp.collectionUser)
                            .document(CharityApp.sharedPreferences
                                .getString(CharityApp.userUID))
                            .collection(CharityApp.userItem)
                            .document(id)
                            .setData({
                          "item": task,
                          "date": DateTime.now(),
                          "description": desc,
                          "quantity": quantity
                        }, merge: true);

                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          );
        });
  }

  ///

  void _showAddTaskDialog() {
    String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      url2 = '';
      fileName2 = '';
    });
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text("Add new products"),
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: TextField(
                  controller: _taskTxtController..text = '',
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write your product name here",
                      labelText: "Product Name"),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
                  controller: _taskquantityController..text = '',
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write your product quantity here",
                      labelText: "Product quantity"),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
                  controller: _taskDescController..text = '',
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write your product description here",
                      labelText: "Product Description"),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                    RaisedButton(
                      color: c.primaryColor,
                      child: Text("Add"),
                      onPressed: () async {
                        String task = _taskTxtController.text.trim();
                        String desc = _taskDescController.text.trim();
                        //String cat = _taskCatController.text.trim();
                        String quantity = _taskquantityController.text.trim();
                        // int.parse(_taskquantityController.text).toString();
                        print(task);
                        checkItemInCart(task, context);

                        CharityApp.firestore
                            .collection(CharityApp.collectionUser)
                            .document(CharityApp.sharedPreferences
                                .getString(CharityApp.userUID))
                            .collection(CharityApp.userItem)
                            .document(currentTime)
                            .setData({
                          "item": task,
                          "date": DateTime.now(),
                          //"category": cat,
                          "description": desc,
                          "quantity": quantity,
                          'currentTime': currentTime,
                        }, merge: true);
                        //String final_string = task + desc + quantity;
                        // final_string = final_string.substring(0, 4);
                        CharityApp.firestore
                            .collection(CharityApp.collectionUser)
                            .document(CharityApp.sharedPreferences
                                .getString(CharityApp.userUID))
                            .collection(CharityApp.userItem2)
                            .document(currentTime)
                            .setData({
                          "item": task,
                          "date": DateTime.now(),
                          //"category": cat,
                          "description": desc,
                          "quantity": quantity
                        }, merge: true);
                        print('sdsd');

                        Navigator.of(ctx).pop();
                      },
                    ),
                    Expanded(
                      child: FlatButton(
                        child: Column(
                          children: [
                            Text("Add image"),
                            Text(
                              fileName2,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                        onPressed: () {
                          _pickImage(currentTime);
                          // print('MP: ${globals.mp[snap.documentID]}');
                          // print('MP2: ${globals.mp2[snap.documentID]}');
                          //  _pickImage(snap.documentID);
                          //   print('MP: ${globals.mp[snap.documentID]}');
                          //   print('MP2: ${globals.mp2[snap.documentID]}');
                          //Navigator.of(ctx).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          );
        });
  }
}
