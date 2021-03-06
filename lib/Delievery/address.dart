import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:place_picker/place_picker.dart';
import '../Config/config.dart';
import '../Payment/paymentDetailsaPage.dart';
import '../Payment/payment.dart';
import '../Widgets/customAppBar.dart';
import '../notifiers/cartitemcounter.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/wideButton.dart';
import '../modals/address.dart';
import '../notifiers/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Config/config2.dart' as c;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'addAddress.dart';
import '../globals.dart' as globals;

class Address extends StatefulWidget {
  final double totalAmount;
  const Address({Key key, this.totalAmount}) : super(key: key);
  @override
  _AddressState createState() => _AddressState();
}

int currentIndex = 0;

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/new.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MyAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Select address',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
              Consumer<AddressChanger>(builder: (context, address, _) {
                return Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: CharityApp.firestore
                        .collection(CharityApp.collectionUser)
                        .document(CharityApp.sharedPreferences
                            .getString(CharityApp.userUID))
                        .collection(CharityApp.subCollectionAddress)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(child: LoadingWidget())
                          : snapshot.data.documents.length == 0
                              ? noAddressCard()
                              : ListView.builder(
                                  reverse: true,
                                  itemCount: snapshot.data.documents.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return AddressCard(
                                      currentIndex: address.count,
                                      value: index,
                                      addressID: snapshot
                                          .data.documents[index].documentID,
                                      totalAmount: widget.totalAmount,
                                      model: AddressModel.fromJson(
                                          snapshot.data.documents[index].data),
                                    );
                                  });
                    },
                  ),
                );
              }),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (_) => AddAddress());
              Navigator.push(context, route);
            },
            label: Text('Add Address'),
            backgroundColor: c.primaryColor.withOpacity(1),
            //Colors.deepPurple,
            icon: Icon(Icons.add_location),
          ),
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color:
          //c.primaryColor.withOpacity(0.5),
          Colors.deepPurple.withOpacity(0.5),
      child: Container(
          height: 100,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.add_location, color: Colors.white),
              Text('You dont have any address with us'),
              Text('Add your address so that we can deliever prodoct !!'),
            ],
          )),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final int currentIndex;
  final int value;
  final String addressID;
  final double totalAmount;
  const AddressCard(
      {Key key,
      this.model,
      this.currentIndex,
      this.value,
      this.addressID,
      this.totalAmount})
      : super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  String orderID;
  bool isSuccess;
  @override
  void dispose() {
    super.dispose();
    //_razorpay.clear();
  }

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
      // is_subscribed = true;
      // _db.collection("users").document(globals.uid).setData({
      //   "is_subscribed": true,
      // }, merge: true);
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

  Future writeOrderDetails(Map<String, dynamic> data) async {
    await CharityApp.firestore
        .collection(CharityApp.collectionUser)
        .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
        .collection(CharityApp.collectionOrders)
        .document(CharityApp.sharedPreferences.getString(CharityApp.userUID) +
            data['orderTime']) // Order ID = uid+currentID
        .setData(data, merge: true);
    await CharityApp.firestore
        .collection(CharityApp.collectionO)
        // .document(
        //     CharityApp.sharedPreferences.getString(CharityApp.userUID))
        // .collection(CharityApp.collectionOrders)
        .document(CharityApp.sharedPreferences.getString(CharityApp.userUID) +
            '#'
                '${data['orderTime']}') // Order ID = uid+currentID
        .setData(data, merge: true);
  }

  void emptyCart() {
    setState(() {
      CharityApp.sharedPreferences
          .setStringList(CharityApp.userCartList, ['garbageValue']);
    });
    print('Someone called me');
    List temp = CharityApp.sharedPreferences.getStringList(
      CharityApp.userCartList,
    );

    CharityApp.firestore
        .collection(CharityApp.collectionUser)
        .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
        .updateData({CharityApp.userCartList: temp}).then((_) {
      CharityApp.sharedPreferences.setStringList(CharityApp.userCartList, temp);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
  }

  bool rememberMe = false;
  bool rememberMe2 = false;
  String store = '';
  void final_dialog() {
    TextEditingController _taskstoreController = TextEditingController();

    showDialog(
        barrierDismissible: false,
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
                              child: Text("Proceed"),
                              onPressed: () {
                                store = _taskstoreController.text.trim();
                                print('store:  $store');
                                print('tr:  $tr');
                                //print('qaz:  $qaz');

                                setState(() {
                                  globals.storename = store;
                                  if (rememberMe2) {
                                    globals.storename = '';
                                  }
                                  print(globals.storename);
                                });

                                Route route;
                                String currentTime = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                orderID = CharityApp.sharedPreferences
                                        .getString(CharityApp.userUID) +
                                    currentTime;
                                isSuccess = false;
                                ////////////////
                                if (globals.rythu == 'RB') {
                                  CharityApp.firestore
                                      .collection(CharityApp.collectionUser)
                                      .document(CharityApp.sharedPreferences
                                          .getString(CharityApp.userUID))
                                      .collection(CharityApp.collectionOrders)
                                      .document(CharityApp.sharedPreferences
                                              .getString(CharityApp.userUID) +
                                          currentTime) // Order ID = uid+currentID
                                      .setData({
                                    'rythuBazzar': true,
                                    'category': globals.category,
                                    CharityApp.addressID: widget.addressID,
                                    CharityApp.totalAmount: widget.totalAmount,
                                    'store': globals.storename,
                                    //CharityApp.sharedPreferences
                                    //     .getString(CharityApp.store),
                                    CharityApp.productID: CharityApp
                                        .sharedPreferences
                                        .getStringList(CharityApp.userCartList),
                                    // CharityApp.paymentDetails: res,
                                    CharityApp.orderTime: currentTime,
                                    CharityApp.isSuccess: false,
                                    'location_string': tr.toString(),
                                    'position': pqrs.data,
                                    //pqrs.data,
                                  }, merge: true);

                                  //2nd
                                  CharityApp.firestore
                                      .collection('rythubazaar')
                                      .document(CharityApp.sharedPreferences
                                              .getString(CharityApp.userUID) +
                                          '#'
                                              '$currentTime') // Order ID = uid+currentID
                                      .setData({
                                    'category': globals.category,
                                    'rythuBazzar': true,
                                    'store': globals.storename,
                                    CharityApp.addressID: widget.addressID,
                                    CharityApp.totalAmount: widget.totalAmount,
                                    // CharityApp.store: CharityApp.sharedPreferences
                                    //     .getString(CharityApp.store),
                                    CharityApp.productID: CharityApp
                                        .sharedPreferences
                                        .getStringList(CharityApp.userCartList),
                                    // CharityApp.paymentDetails: res,
                                    CharityApp.orderTime: currentTime,
                                    CharityApp.isSuccess: false,
                                    'location_string': tr,
                                    'position': pqrs.data,
                                    //pqrs.data,
                                  }, merge: true);
                                } else {
                                  CharityApp.firestore
                                      .collection(CharityApp.collectionUser)
                                      .document(CharityApp.sharedPreferences
                                          .getString(CharityApp.userUID))
                                      .collection(CharityApp.collectionOrders)
                                      .document(CharityApp.sharedPreferences
                                              .getString(CharityApp.userUID) +
                                          currentTime) // Order ID = uid+currentID
                                      .setData({
                                    'category': globals.category,
                                    CharityApp.addressID: widget.addressID,
                                    CharityApp.totalAmount: widget.totalAmount,
                                    'store': globals.storename,
                                    //CharityApp.sharedPreferences
                                    //     .getString(CharityApp.store),
                                    CharityApp.productID: CharityApp
                                        .sharedPreferences
                                        .getStringList(CharityApp.userCartList),
                                    // CharityApp.paymentDetails: res,
                                    CharityApp.orderTime: currentTime,
                                    CharityApp.isSuccess: false,
                                    'location_string': tr,
                                    'position': pqrs.data,
                                    //pqrs.data,
                                  }, merge: true);

                                  //2nd
                                  CharityApp.firestore
                                      .collection(CharityApp.collectionO)
                                      .document(CharityApp.sharedPreferences
                                              .getString(CharityApp.userUID) +
                                          '#'
                                              '$currentTime') // Order ID = uid+currentID
                                      .setData({
                                    'category': globals.category,
                                    'store': globals.storename,
                                    CharityApp.addressID: widget.addressID,
                                    CharityApp.totalAmount: widget.totalAmount,
                                    // CharityApp.store: CharityApp.sharedPreferences
                                    //     .getString(CharityApp.store),
                                    CharityApp.productID: CharityApp
                                        .sharedPreferences
                                        .getStringList(CharityApp.userCartList),
                                    // CharityApp.paymentDetails: res,
                                    CharityApp.orderTime: currentTime,
                                    CharityApp.isSuccess: false,
                                    'location_string': tr,
                                    'position': pqrs.data,
                                    //pqrs.data,
                                  }, merge: true);
                                }

                                ///

                                emptyCart();
                                //Deleting all elements from cart
                                CharityApp.firestore
                                    .collection('users')
                                    .document(CharityApp.sharedPreferences
                                        .getString(CharityApp.userUID))
                                    .collection(CharityApp.userItem)
                                    .getDocuments()
                                    .then((snapshot) {
                                  for (DocumentSnapshot doc
                                      in snapshot.documents) {
                                    doc.reference.delete();
                                  }
                                });

                                route = MaterialPageRoute(
                                    builder: (_) => OrderDetails(
                                          orderID: orderID,
                                        ));
                                Navigator.push(context, route);

                                print(widget.model.toJson());
                                Fluttertoast.showToast(
                                    msg: 'Order is placed Succesfully');
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

  GeoFirePoint pqrs;
  final geo = Geoflutterfire();
  GeoFirePoint abcd;
  Map<String, dynamic> abcd2 = {};
  String tr = '';
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Card(
        color: Colors.black12,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.deepPurple,
                  onChanged: (val) {
                    Provider.of<AddressChanger>(context, listen: false)
                        .displayResult(val);
                    print(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      width: _screenWidth * 0.8,
                      child: Table(
                        //border: TableBorder.all(),
                        children: [
                          TableRow(children: [
                            KeyText(message: 'Name'),
                            Text(widget.model.name),
                          ]),
                          TableRow(children: [
                            KeyText(message: 'Phone Number'),
                            Text(widget.model.phoneNumber),
                          ]),
                          TableRow(children: [
                            KeyText(message: 'Flat Number'),
                            Text(widget.model.flatNumber),
                          ]),
                          TableRow(children: [
                            KeyText(message: 'Area'),
                            Text(widget.model.area),
                          ]),
                          TableRow(children: [
                            KeyText(message: 'Landmark'),
                            Text(widget.model.landmark),
                          ]),
                          TableRow(children: [
                            KeyText(message: 'City'),
                            Text(widget.model.city),
                          ]),
                          TableRow(children: [
                            KeyText(message: 'State'),
                            Text(widget.model.state),
                          ]),
                          TableRow(children: [
                            KeyText(
                              message: 'pincode',
                            ),
                            Text(widget.model.pincode),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                ? WideButton(
                    message: 'Proceed',
                    onPressed: () {
                      // LocationResult result;
                      // List<String> qaz = new List();

                      DocumentReference _db2;
                      _db2 = CharityApp.firestore
                          .collection('users')
                          .document(CharityApp.sharedPreferences
                              .getString(CharityApp.userUID))
                          .collection('userAddress')
                          .document(widget.addressID);
                      _db2.get().then((DocumentSnapshot documentSnapshot) {
                        if (documentSnapshot.exists) {
                          print(documentSnapshot.data['position']);
                          print(documentSnapshot.data['location_string']);
                          setState(() {
                            tr = documentSnapshot.data['location_string'];
                            GeoPoint geopoint =
                                documentSnapshot.data['position']['geopoint'];
                            print('Lat: ${geopoint.latitude}');
                            print('Lon: ${geopoint.longitude}');
                            // result.latLng = LatLng(
                            //     double.parse('${geopoint.latitude}'),
                            //     double.parse(
                            //         '${geopoint.longitude}'));
                            pqrs = geo.point(
                                latitude: geopoint.latitude,
                                longitude: geopoint.longitude);
                            // qaz.add((geopoint.latitude).toString());
                            // print(qaz);
                            // qaz.add((geopoint.longitude).toString());
                            // print(qaz);
                            // abcd2['position'] = {
                            //   'geopoint': qaz,
                            // };

                            print(tr);
                            //print(pqrs);
                          });
                        } else {
                          print('Document does not exist on the database');
                        }
                      });
                      final_dialog();
                      // Route route;
                      // String currentTime =
                      //     DateTime.now().millisecondsSinceEpoch.toString();
                      // orderID = CharityApp.sharedPreferences
                      //         .getString(CharityApp.userUID) +
                      //     currentTime;
                      // isSuccess = false;
                      // CharityApp.firestore
                      //     .collection(CharityApp.collectionUser)
                      //     .document(CharityApp.sharedPreferences
                      //         .getString(CharityApp.userUID))
                      //     .collection(CharityApp.collectionOrders)
                      //     .document(CharityApp.sharedPreferences
                      //             .getString(CharityApp.userUID) +
                      //         currentTime) // Order ID = uid+currentID
                      //     .setData({
                      //   CharityApp.addressID: widget.addressID,
                      //   CharityApp.totalAmount: widget.totalAmount,
                      //   'store': globals.storename,
                      //   //CharityApp.sharedPreferences
                      //   //     .getString(CharityApp.store),
                      //   CharityApp.productID: CharityApp.sharedPreferences
                      //       .getStringList(CharityApp.userCartList),
                      //   // CharityApp.paymentDetails: res,
                      //   CharityApp.orderTime: currentTime,
                      //   CharityApp.isSuccess: false,
                      // }, merge: true);

                      // //2nd
                      // CharityApp.firestore
                      //     .collection(CharityApp.collectionO)

                      //     .document(CharityApp.sharedPreferences
                      //             .getString(CharityApp.userUID) +
                      //         '#'
                      //             '$currentTime') // Order ID = uid+currentID
                      //     .setData({
                      //   'store': globals.storename,
                      //   CharityApp.addressID: widget.addressID,
                      //   CharityApp.totalAmount: widget.totalAmount,
                      //   // CharityApp.store: CharityApp.sharedPreferences
                      //   //     .getString(CharityApp.store),
                      //   CharityApp.productID: CharityApp.sharedPreferences
                      //       .getStringList(CharityApp.userCartList),
                      //   // CharityApp.paymentDetails: res,
                      //   CharityApp.orderTime: currentTime,
                      //   CharityApp.isSuccess: false,
                      // }, merge: true);
                      // emptyCart();
                      // //Deleting all elements from cart
                      // CharityApp.firestore
                      //     .collection(CharityApp.userItem)
                      //     .getDocuments()
                      //     .then((snapshot) {
                      //   for (DocumentSnapshot doc in snapshot.documents) {
                      //     doc.reference.delete();
                      //   }
                      // });

                      // route = MaterialPageRoute(
                      //     builder: (_) => OrderDetails(
                      //           orderID: orderID,
                      //         ));
                      // Navigator.push(context, route);

                      // print(widget.model.toJson());
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class KeyText extends StatelessWidget {
  final String message;

  KeyText({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    );
  }
}

// in payment page make a section of select payment method on selection of upi navigate user to new screen with upi options like paytm, phonepay and complete payment
