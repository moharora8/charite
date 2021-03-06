import '../Authentication/authenication.dart';
import '../Store/storehome.dart';
import 'package:flutter/material.dart';
import '../widgets/homecontainer.dart';
import 'package:carousel_pro/carousel_pro.dart';
import '../Widgets/categcont.dart';
import '../Widgets/connect.dart';
import '../Widgets/button.dart';
import 'dart:async';
import '../wallet/first_page.dart';
import '../Widgets/add_items.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../Config/config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../globals.dart' as globals;
import 'package:intl/intl.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> l = [
    'Places',
    'Donate Money',
    'Donate Stuff',
    'Volunteer',
    'Adopt',
    'LogOut'
  ];
  List<String> ll2 = [
    'v4.jpg',
    'donate_money.jpg',
    'donate_stuff.jpg',
    '6660.jpg',
    'child/1.jpg',
    'lg.jpg'
  ];
  int index2 = 0;
  Razorpay _razorpay;

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

  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...List.generate(3, (index) {
            return Column(
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(23)),
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: MediaQuery.of(context).size.height / 4,
                  width: 600,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...List.generate(2, (index2) {
                        return InkWell(
                            onTap: () {
                              if (ll2[2 * index + index2] == 'lg.jpg') {
                                CharityApp.auth.signOut().then((_) {
                                  Route newRoute = MaterialPageRoute(
                                      builder: (_) => AuthenticScreen());
                                  Navigator.pushReplacement(context, newRoute);
                                });
                              } else if (ll2[2 * index + index2] == 'v4.jpg') {
                                Route newRoute = MaterialPageRoute(
                                    builder: (_) => StoreHome(
                                          currentIndex: 1,
                                        ));
                                Navigator.pushReplacement(context, newRoute);
                              } else if (ll2[2 * index + index2] ==
                                  'prof.jpg') {
                                Route newRoute = MaterialPageRoute(
                                    builder: (_) => StoreHome(
                                          currentIndex: 0,
                                        ));
                                Navigator.pushReplacement(context, newRoute);
                              } else if (ll2[2 * index + index2] == 'dw.jpg') {
                                Route newRoute = MaterialPageRoute(
                                    builder: (_) => StoreHome(
                                          currentIndex: 4,
                                        ));
                                Navigator.pushReplacement(context, newRoute);
                              } else if (ll2[2 * index + index2] == 'v1.jpg') {
                                Route newRoute = MaterialPageRoute(
                                    builder: (_) => FirstPage());
                                Navigator.push(context, newRoute);
                              }
                            },
                            child: CategContainer(
                                path:
                                    'assets/images/' + ll2[2 * index + index2],
                                t: l[2 * index + index2]));
                      }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
          }),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
