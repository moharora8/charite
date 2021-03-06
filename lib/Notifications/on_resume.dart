import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Config/config.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OnResume extends StatefulWidget {
  Map<String, dynamic> message;
  OnResume({this.message});
  @override
  _OnResumeState createState() => _OnResumeState();
}

class _OnResumeState extends State<OnResume> {
  TextEditingController _couController = TextEditingController();
  bool cou = false;
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
      CharityApp.firestore
          .collection('orders')
          .document(
              widget.message['data']['order_id']) // Order ID = uid+currentID
          .setData({
        'payment_status': 'Done',
        'payment_mode': 'Online',
      }, merge: true);
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

  List<dynamic> ste;
  DocumentReference _db2;
  @override
  void initState() {
    _db2 = CharityApp.firestore
        .collection('orders')
        .document(widget.message['data']['order_id']);
    _db2.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data}');
        print('Images:  ');
        print(documentSnapshot.data['productIDs']);
        setState(() {
          ste = documentSnapshot.data['productIDs'];
        });
      } else {
        print('Document does not exist on the database');
      }
    });
    print(widget.message['data']['agent_id']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: widget.message['data']['tag2'] == 'order_delivered'
              ? Text('Order Delivered')
              : widget.message['data']['tag2'] == 'order_accept'
                  ? Text('Order Accepted')
                  : Text('Order Picked'),
        ),
        body: Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Divider(
                    thickness: 4,
                    height: 4,
                    color: Colors.black,
                  ),
                ),
                Text('Order Details',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Divider(
                    thickness: 4,
                    height: 4,
                    color: Colors.black,
                  ),
                ),
                Text.rich(
                  TextSpan(
                      text: 'Order ID: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      children: <InlineSpan>[
                        TextSpan(
                          text: '${widget.message['data']['order_id']}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        )
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                ),
                widget.message['data']['tag2'] == 'order_accept'
                    ? Text('Products',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                ),
                widget.message['data']['tag2'] == 'order_accept'
                    ? Center(
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection('orders')
                                .document(widget.message['data']['order_id'])
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    reverse: true,
                                    itemCount:
                                        snapshot.data['productIDs'].length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return index != 0
                                          ? Text(
                                              snapshot.data['productIDs']
                                                  [index],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400))
                                          : SizedBox();
                                    });
                              }
                              return CircularProgressIndicator();
                            }),
                      )
                    : SizedBox(),
                // : Center(
                //     child: StreamBuilder<DocumentSnapshot>(
                //         stream: Firestore.instance
                //             .collection('orders')
                //             .document(widget.message['data']['order_id'])
                //             .snapshots(),
                //         builder: (BuildContext context,
                //             AsyncSnapshot<DocumentSnapshot> snapshot) {
                //           if (snapshot.hasData) {
                //             List.generate(snapshot.data['mp1'].length,
                //                 (index) {
                //               String key = snapshot.data['mp1'].keys
                //                   .elementAt(index);
                //               return Row(
                //                 children: [
                //                   Text(key),
                //                   SizedBox(width: 30),
                //                   Text(snapshot.data['mp1'][key]),
                //                 ],
                //               );
                //             });
                //           }
                //           return CircularProgressIndicator();
                //         }),
                //   ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Divider(
                    thickness: 4,
                    height: 4,
                    color: Colors.black,
                  ),
                ),
                Text('Agent Details',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                // widget.message['data']['tag2'] == 'order_accept'
                //     ? Text('Agent Details',
                //         style: TextStyle(
                //             fontSize: 20, fontWeight: FontWeight.bold))
                //     : SizedBox(),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Divider(
                    thickness: 4,
                    height: 4,
                    color: Colors.black,
                  ),
                ),
                // widget.message['data']['tag2'] == 'order_accept'
                //     ?
                Center(
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection('agents')
                          .document(widget.message['data']['agent_id'])
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot2) {
                        print(widget.message['data']['agent_id']);
                        if (snapshot2.hasData) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Text('Agent Name: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  snapshot2.data['agent_name'] != null
                                      ? Text(snapshot2.data['agent_name'],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400))
                                      : Text('Not Avaiable Yet'),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Divider(
                                  //thickness: 4,
                                  height: 2,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Text('Agent Number: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text(snapshot2.data['phonenumber'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ],
                          );
                        }
                        return CircularProgressIndicator();
                      }),
                ),
                // : SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Divider(
                    thickness: 4,
                    height: 4,
                    color: Colors.black,
                  ),
                ),
                ////////////////

                ///
                widget.message['data']['tag2'] == 'order_picked'
                    ? Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('Trolley Amount: '),
                                Text(widget.message['data']['amount']),
                              ],
                            ),
                            cou == false
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        cou = true;
                                      });
                                    },
                                    child: Text('Do you have a coupon?'))
                                : Row(
                                    children: [
                                      Container(
                                        width: 200,
                                        child: TextField(
                                            controller: _couController,
                                            decoration: InputDecoration(
                                              hintText: 'Coupon Code',
                                              labelText: 'Enter Coupon Code',
                                            )),
                                      ),
                                      FlatButton(
                                        child: Text('Apply'),
                                        onPressed: () {
                                          Fluttertoast.showToast(
                                              msg: 'Code is invalid');
                                          //users->doc->offers->doc
                                        },
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      )
                    : SizedBox(),
                widget.message['data']['tag2'] == 'order_accept'
                    ? Container(
                        margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                        child: Row(
                          children: [
                            RaisedButton(
                              child: Text('Back'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Spacer(),
                            RaisedButton(
                              child: Text('Okay'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      )
                    : widget.message['data']['tag2'] == 'order_picked'
                        ? Container(
                            margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                            child: Row(
                              children: [
                                RaisedButton(
                                  child: Text('Pay Online'),
                                  onPressed: () {
                                    int len = widget.message['data']['amount']
                                        .toString()
                                        .length;
                                    int y = int.parse(
                                        widget.message['data']['amount']);
                                    String u = y.toStringAsFixed(0);
                                    print(u);
                                    print(int.parse(u));
                                    openCheckout(
                                      price: 25,
                                      name: CharityApp.sharedPreferences
                                          .getString(CharityApp.userName),
                                      mail: CharityApp.sharedPreferences
                                          .getString(CharityApp.userEmail),
                                      phone: int.parse(CharityApp
                                          .sharedPreferences
                                          .getString(CharityApp.userPhone)),
                                    );
                                    //Navigator.pop(context);
                                  },
                                ),
                                Spacer(),
                                RaisedButton(
                                  child: Text('COD'),
                                  onPressed: () {
                                    CharityApp.firestore
                                        .collection('orders')
                                        .document(widget.message['data'][
                                            'order_id']) // Order ID = uid+currentID
                                        .setData({
                                      //'payment_status': 'Done',
                                      'payment_mode': 'COD',
                                    }, merge: true);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          )
                        : widget.message['data']['tag2'] == 'order_delivered'
                            ? Container(
                                margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                                child: Row(
                                  children: [
                                    RaisedButton(
                                      child: Text('Rate Us'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    Spacer(),
                                    RaisedButton(
                                      child: Text('Your Feedback'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),

                widget.message['data']['tag2'] == 'order_accept'
                    ? Center(
                        child: RaisedButton(
                          child: Text('Reject Now'),
                          onPressed: () {
                            // Make code for rejecting the  Order
                            //Navigator.pop(context);
                          },
                        ),
                      )
                    : SizedBox(),
              ],
            )),
      ),
    );
  }
}
