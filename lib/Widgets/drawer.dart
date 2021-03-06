import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart' as p;
import '../Widgets/settings.dart';
import '../Widgets/about.dart';
import '../Widgets/tnc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'drawercontainer.dart';
import '../Authentication/authenication.dart';
import '../Config/config.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../Config/config2.dart' as c;
import '../Store/myOrders.dart';
import '../globals.dart' as globals;
import 'package:path_provider/path_provider.dart';
import 'package:place_picker/place_picker.dart';
import 'maps.dart';
import 'dynamic_links_service.dart';
import 'package:share/share.dart';
import 'package:clipboard/clipboard.dart';
import '../Store/storehome.dart';
import '../Store/cart2.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class Drawwer extends StatefulWidget {
  @override
  _DrawwerState createState() => _DrawwerState();
}

class _DrawwerState extends State<Drawwer> {
  _launchURL1() async {
    const url =
        'https://firebasestorage.googleapis.com/v0/b/fir-90846.appspot.com/o/home%2FABOUT%20US.pdf?alt=media&token=b3c20292-a7d0-4238-a0fa-668148ddde42';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURL2() async {
    const url =
        'https://firebasestorage.googleapis.com/v0/b/fir-90846.appspot.com/o/home%2FTerms%20and%20Conditions-converted-converted.pdf?alt=media&token=7bef526c-3439-4458-a794-34d44250f64c';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ///////////////
  String url = '';
  String fileType = '';
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';
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

  final TextEditingController _feedbackController =
      TextEditingController(text: '');
  String ref_code = '';
  Razorpay _razorpay;
  //CharityApp.sharedPreferences.getString(CharityApp.userUID);
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();

  double x;
  double y;
  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyBxD2_Z_ocwyuGrdEZxKTXH1BZt86dPVK8")));
    print(result.latLng);
    print(result.latLng.latitude);
    print(result.latLng.longitude);
    setState(() {
      x = result.latLng.latitude;
      y = result.latLng.longitude;
    });
    // Handle the result in your way
    print(result);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIos: 4);
    setState(() {
      CharityApp.sharedPreferences.setString(CharityApp.isSubscribe, 'true');
      CharityApp.firestore
          .collection(CharityApp.collectionUser)
          .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
          .setData({'is_subscribe': true}, merge: true);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIos: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
  }

  @override
  void initState() {
    setState(() {
      ref_code = CharityApp.sharedPreferences.getString(CharityApp.userUID);
    });
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void openCheckout({int price, String name, int phone, String mail}) async {
    var options = {
      'key': 'rzp_test_xcAxAunudJHN5U',
      'amount': 100 * price,
      'name': name != null ? name : 'John',
      'description': 'Subscription Fee',
      'prefill': {
        'contact': phone != null ? phone : '8888888888',
        'email': mail != null ? mail : 'abcd@gmail.com'
      },
      'external': {
        'wallets': ['paytm']
      },
      'send_sms_hash': true,
      'remember_customer': true
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 8,
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xFFFFD56D),
        child: ListView(
          children: [
            SizedBox(
              height: 140,
              child: DrawerHeader(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Color(0xFFFFD56D),
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(30)),
                margin: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: c.primaryColor,
                      backgroundImage: CharityApp.sharedPreferences
                                  .getString(CharityApp.authtype) ==
                              'gauth'
                          ? NetworkImage(CharityApp.sharedPreferences
                              .getString(CharityApp.userAvatarUrl))
                          : null,
                      child: CharityApp.sharedPreferences
                                  .getString(CharityApp.authtype) ==
                              'phoneauth'
                          ? Icon(
                              Icons.account_circle,
                              size: 50,
                              color: c.secondaryColor,
                            )
                          : null,
                      // ),
                    ),
                    //Icon(Icons.account_circle, size: 60),
                    SizedBox(width: 15),
                    // Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Text(
                            CharityApp.sharedPreferences
                                .getString(CharityApp.userName),
                            style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Colors.black)),
                        Text(
                            CharityApp.sharedPreferences
                                .getString(CharityApp.userEmail),
                            style: TextStyle(
                                fontFamily: 'EastSeaDokdo',
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
                child: DrawContainer(t: 'My Account'),
                onTap: () {
                  Route newRoute = MaterialPageRoute(
                      builder: (_) => StoreHome(
                            currentIndex: 0,
                          ));
                  Navigator.pushReplacement(context, newRoute);
                }),
            //Go to Profile from drawer
            // InkWell(
            //     onTap: () {
            //       Route newRoute = MaterialPageRoute(
            //           builder: (_) => StoreHome(
            //                 currentIndex: 3,
            //               ));
            //       Navigator.pushReplacement(context, newRoute);

            //       //MyOrders()
            //     },
            //     child: DrawContainer(t: 'My Orders')),
            // InkWell(
            //     onTap: () {
            //       Route newRoute =
            //           MaterialPageRoute(builder: (_) => CartPage());
            //       Navigator.push(context, newRoute);
            //     },
            //     child: DrawContainer(t: 'My Trolley')),
            // //got to cart2.dart
            // InkWell(
            //     child: DrawContainer(t: 'Subscription'),
            //     onTap: () {
            //       showModalBottomSheet(
            //           isScrollControlled: true,
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.only(
            //             topLeft: Radius.circular(20),
            //             topRight: Radius.circular(20),
            //           )),
            //           backgroundColor: Colors.white,
            //           context: context,
            //           builder: (context) {
            //             return Container(
            //               margin: EdgeInsets.fromLTRB(22, 14, 20, 0),
            //               height: MediaQuery.of(context).size.height * 0.5,
            //               width: MediaQuery.of(context).size.width,
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 children: [
            //                   Container(
            //                     height: 120,
            //                     width: MediaQuery.of(context).size.width,
            //                     child: Row(
            //                       crossAxisAlignment:
            //                           CrossAxisAlignment.stretch,
            //                       children: [
            //                         Expanded(
            //                           child: Container(
            //                             padding:
            //                                 EdgeInsets.fromLTRB(0, 15, 0, 0),
            //                             child: Text(
            //                                 'Subscribe Now to get benefits Subscribe Now to get benefits Subscribe Now to get benefits Subscribe Now to get benefits Subscribe Now to get benefits.',
            //                                 style: TextStyle(
            //                                     fontSize: 15,
            //                                     fontWeight: FontWeight.w600)),
            //                           ),
            //                         ),
            //                         //Spacer(),
            //                         ClipRRect(
            //                           child: Image.asset(
            //                               'assets/images/2121.jpg',
            //                               height: 100,
            //                               width: 100),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     height: 10,
            //                   ),
            //                   Divider(
            //                     color: Colors.black,
            //                     height: 2,
            //                   ),
            //                   CharityApp.sharedPreferences.getString(
            //                               CharityApp.isSubscribe) !=
            //                           'true'
            //                       ? FlatButton(
            //                           color: Colors.amber,
            //                           onPressed: () {
            //                             openCheckout(
            //                               price: 2,
            //                               name: 'Mohit',
            //                               mail: 'moharora8@gmail.com',
            //                               phone: 8007347723,
            //                             );
            //                           },
            //                           child: Text('Subscribe now'),
            //                         )
            //                       : Padding(
            //                           padding: const EdgeInsets.only(top: 10.0),
            //                           child: Text('You are already Subscribed'),
            //                         ),
            //                 ],
            //               ),
            //             );
            //           });
            //     }),
            //Modal Bottom Sheet showing subscription status and facility to subscribe using payment gateway
            InkWell(
                onTap: () {
                  Route newRoute =
                      MaterialPageRoute(builder: (_) => Settings());
                  Navigator.push(context, newRoute);
                },
                child: DrawContainer(t: 'Settings')),
            //Take from another app
            InkWell(
              onTap: () {
                //_launchURL2();
                // Route newRoute = MaterialPageRoute(builder: (_) => TnC());
                // Navigator.push(context, newRoute);
                // MapsLauncher.launchCoordinates(
                //     x != null ? x : globals.abcd.geoPoint.latitude + 10,
                //     y != null ? y : globals.abcd.geoPoint.longitude);
              },
              child: DrawContainer(t: 'Terms & Conditions'),
            ),
            //show a alert box for Terms and Condition
            // InkWell(
            //     onTap: () {
            //       showModalBottomSheet(
            //           isScrollControlled: true,
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.only(
            //             topLeft: Radius.circular(20),
            //             topRight: Radius.circular(20),
            //           )),
            //           backgroundColor: Colors.white,
            //           context: context,
            //           builder: (context) {
            //             return Container(
            //               margin: EdgeInsets.fromLTRB(22, 14, 20, 0),
            //               height: MediaQuery.of(context).size.height * 0.6,
            //               width: MediaQuery.of(context).size.width,
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 children: [
            //                   Container(
            //                     height: 120,
            //                     width: MediaQuery.of(context).size.width,
            //                     child: Row(
            //                       crossAxisAlignment:
            //                           CrossAxisAlignment.stretch,
            //                       children: [
            //                         Expanded(
            //                           child: Container(
            //                             padding:
            //                                 EdgeInsets.fromLTRB(0, 15, 0, 0),
            //                             child: Text(
            //                                 'Share your referral code to get benefits. The person who is sharing and who is using the referral code wont have to pay the delivery charge for their first five orders.',
            //                                 style: TextStyle(
            //                                     fontSize: 15,
            //                                     fontWeight: FontWeight.w600)),
            //                           ),
            //                         ),
            //                         //Spacer(),
            //                         ClipRRect(
            //                           child: Image.asset('assets/images/22.jpg',
            //                               height: 100, width: 100),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     height: 10,
            //                   ),
            //                   Divider(
            //                     color: Colors.black,
            //                     height: 2,
            //                   ),
            //                   Expanded(
            //                     // height: 200,
            //                     // width: MediaQuery.of(context).size.width,
            //                     child: FutureBuilder<Uri>(
            //                         future: _dynamicLinkService
            //                             .createDynamicLink(ref_code),
            //                         builder: (context, snapshot) {
            //                           if (snapshot.hasData) {
            //                             Uri uri = snapshot.data;
            //                             return Center(
            //                               child: Column(
            //                                 mainAxisAlignment:
            //                                     MainAxisAlignment.spaceAround,
            //                                 children: [
            //                                   InkWell(
            //                                       onTap: () {
            //                                         Clipboard.setData(
            //                                             new ClipboardData(
            //                                                 text: uri
            //                                                     .toString()));
            //                                         Fluttertoast.showToast(
            //                                             msg:
            //                                                 'Copied to Clipboard');
            //                                       },
            //                                       child: Text(uri.toString())),
            //                                   Divider(
            //                                     color: Colors.black,
            //                                     height: 2,
            //                                   ),
            //                                   FlatButton(
            //                                     color: Colors.amber,
            //                                     onPressed: () =>
            //                                         Share.share(uri.toString()),
            //                                     child: Text('Share'),
            //                                   ),
            //                                 ],
            //                               ),
            //                             );
            //                           } else {
            //                             return Container();
            //                           }
            //                         }),
            //                   ),
            //                 ],
            //               ),
            //             );
            //           });
            // showPlacePicker();
            // showDialog(
            //   context: context,
            //   builder: (context) => AlertDialog(
            //     content: Container(
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Container(
            //               child: Text(
            //                   'Share your referral code to get benefits. The person who is sharing and who is using the referral code wont have to pay the delivery charge for their first five orders.')),
            //         ],
            //       ),
            //     ),
            //     actions: <Widget>[
            //       FlatButton(
            //         child: Text('Ok'),
            //         onPressed: () => Navigator.of(context).pop(),
            //       ),
            //     ],
            //   ),
            // );
            // },
            // child: DrawContainer(t: 'Referrals')),
            //Referral System
            InkWell(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (context) {
                        // return StatefulBuilder(
                        //     //stream: null,
                        //     builder: (context, setState2) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(22, 14, 20, 0),
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 15, 0, 0),
                                            child: Text(
                                                'Kindly give your feedback so that we can serve you better :-)',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        ),
                                        ClipRRect(
                                          child: Image.asset(
                                              'assets/images/download.jpg',
                                              height: 100,
                                              width: 100),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height: 20,
                                      child: Text(
                                        'Subscription Status:  ${CharityApp.sharedPreferences.getString(CharityApp.isSubscribe)}',
                                      )
                                      //${CharityApp.sharedPreferences.getString(CharityApp.isSubscribe)}'),
                                      ),
                                  Divider(
                                    color: Colors.black,
                                    height: 2,
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter your feedback here',
                                      labelText: 'Feedback',
                                    ),
                                    maxLines: 3,
                                    controller: _feedbackController,
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    height: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, 12, 0, 0),
                                            child: FlatButton(
                                              color: Colors.amber,
                                              onPressed: () {
                                                setState(() {
                                                  fileType = 'others';
                                                });
                                                filePicker(context);
                                              },
                                              child: Text('Add a document'),
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            child: Text(
                                              fileName,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //SizedBox(width: 40),
                                      FlatButton(
                                          color: Colors.amber,
                                          onPressed: () {
                                            String currentTime = DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString();
                                            print(_feedbackController.text);
                                            print('Filename: $fileName');
                                            CharityApp.firestore
                                                .collection('feedback')
                                                .document(CharityApp
                                                    .sharedPreferences
                                                    .getString(
                                                        CharityApp.userUID))
                                                .collection('tickets')
                                                .document(CharityApp
                                                        .sharedPreferences
                                                        .getString(CharityApp
                                                            .userUID) +
                                                    '#' +
                                                    currentTime)
                                                .setData({
                                              'subscription_status': CharityApp
                                                          .sharedPreferences
                                                          .getString(CharityApp
                                                              .isSubscribe) ==
                                                      'true'
                                                  ? 'Subscribed'
                                                  : 'Un Subscribed',
                                              'url': url,
                                              'fileName': fileName,
                                              'feedback_text':
                                                  _feedbackController.text
                                            }, merge: true);
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Your Feedback is received!!\nThanks :-)');
                                            setState(() {
                                              url = '';
                                              fileName = '';
                                              _feedbackController.text = '';
                                            });
                                          },
                                          child: Text('Submit')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        // });
                      });
                  // Route newRoute = MaterialPageRoute(builder: (_) => Maps());
                  // Navigator.push(context, newRoute);
                  //Make a modalBottomSheet containing textfield, showing subscription status and uploading pdf.
                },
                child: DrawContainer(t: 'Feedback')),
            InkWell(
                onTap: () {
                  // _launchURL1();
                },
                child: DrawContainer(t: 'About us')),
            //Alert Dialog box
            //DrawContainer(t: 'Gatted Community'),
            //As it is
            DrawContainer(t: 'Community'),
            //As it is
            InkWell(
              child: DrawContainer(t: 'Log Out'),
              onTap: () {
                print('bh');
                showDialog(
                    context: context,
                    builder: (con) {
                      return AlertDialog(
                        title: Text('Are you sure you want to log out?'),
                        actions: [
                          InkWell(
                              onTap: () async {
                                Navigator.pop(context);
                                await googleSignIn.signOut();
                                await CharityApp.auth.signOut();
                                Route newRoute = MaterialPageRoute(
                                    builder: (_) => AuthenticScreen());
                                Navigator.pushReplacement(context, newRoute);
                                // CharityApp.auth.signOut().then((_) {
                                //   //CharityApp.sharedPreferences.setString(CharityApp.userUID, null);
                                //   if (CharityApp.authtype == 'gauth') {
                                //     googleSignIn.signOut();
                                //   }

                                //   Route newRoute = MaterialPageRoute(
                                //       builder: (_) => AuthenticScreen());
                                //   Navigator.pushReplacement(context, newRoute);
                                // });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  'Yes',
                                  style: TextStyle(fontSize: 21),
                                ),
                              ))
                        ],
                      );
                    });
              },
            ),
            //Add AlertBox
          ],
        ),
      ),
    );
  }
}
