import '../Payment/paymentDetailsaPage.dart';
import '../Config/config.dart';
import '../Widgets/customAppBar.dart';
import '../Widgets/wideButton.dart';
import '../notifiers/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upi_india/upi_india.dart';

class PaymentPage extends StatefulWidget {
  final String addressID;
  final double totalAmount;
  final List<dynamic> details;

  const PaymentPage({
    Key key,
    this.addressID,
    this.details,
    this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // List details = [
  //   ['Paytm', 'PhonePe', 'GooglePay'],
  //   ['8007347723@PAYTM', '8007347723@ybl', 'moharora8@okaxis'],
  //   [UpiIndiaApps.PayTM, UpiIndiaApps.PhonePe, UpiIndiaApps.GooglePay]
  // ];
  static const String receiverName = 'YourBussinessName';

  Future transaction;

  Future<String> initiateTransaction(String appType, String receiverUPIID,
      String transactionRefID, double amount) async {
    UpiIndia upi = new UpiIndia(
      app: appType,
      receiverUpiId: receiverUPIID,
      receiverName: receiverName,
      transactionRefId: transactionRefID,
      transactionNote: 'Transaction Note',
      amount: widget.totalAmount,
    );
    String response = await upi.startTransaction();
    return response;
  }

  String orderID;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(
              'Pay using UPI ₹ ${widget.totalAmount.toString()}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.details[0].length,
                  itemBuilder: (context, index) {
                    return WideButton(
                      message: widget.details[0][index],
                      onPressed: () {
                        print(widget.details[1][index]);
                        transaction = initiateTransaction(
                                widget.details[2][index],
                                widget.details[1][index],
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                widget.totalAmount)
                            .then((res) {
                          print('Printing Response $res');

                          UpiIndiaResponse _upiResponse;
                          _upiResponse = UpiIndiaResponse(res);
                          // ignore: unused_local_variable
                          String txnId = _upiResponse.transactionId;
                          // ignore: unused_local_variable
                          String resCode = _upiResponse.responseCode;
                          // ignore: unused_local_variable
                          String txnRef = _upiResponse.transactionRefId;
                          String status = _upiResponse.status;
                          // ignore: unused_local_variable
                          String approvalRef = _upiResponse.approvalRefNo;
                          // ignore: unused_local_variable
                          bool isSuccess = false;
                          Route route;
                          String currentTime =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          orderID = CharityApp.sharedPreferences
                                  .getString(CharityApp.userUID) +
                              currentTime;
                          if (status == 'success') {
                            isSuccess = true;
                            // Write  details to firebase
                            writeOrderDetails({
                              CharityApp.addressID: widget.addressID,
                              CharityApp.totalAmount: widget.totalAmount,
                              // CharityApp.productID: CharityApp.sharedPreferences
                              //     .getStringList(CharityApp.userCartList),
                              CharityApp.paymentDetails: res,
                              CharityApp.orderTime: currentTime,
                              CharityApp.isSuccess: true,
                              // CharityApp.store: CharityApp.sharedPreferences
                              //     .getStringList(CharityApp.store),
                            }).then((_) {
                              // Empty Cart
                              emptyCart();
                              route = MaterialPageRoute(
                                  builder: (_) => OrderDetails(
                                        orderID: orderID,
                                      ));
                              Navigator.push(context, route);
                            });
                          } else {
                            isSuccess = false;
                            writeOrderDetails({
                              CharityApp.addressID: widget.addressID,
                              CharityApp.totalAmount: widget.totalAmount,
                              // CharityApp.productID: CharityApp.sharedPreferences
                              //     .getStringList(CharityApp.userCartList),
                              CharityApp.paymentDetails: res,
                              CharityApp.orderTime: currentTime,
                              CharityApp.isSuccess: false,
                            });
                            route = MaterialPageRoute(
                                builder: (_) => OrderDetails(
                                      orderID: orderID,
                                    ));
                            Navigator.push(context, route);
                          }
                        });
                        setState(() {});
                      },
                    );
                  }),
            ),
            Expanded(
              child: FutureBuilder(
                future: transaction,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null)
                    return Text(' ');
                  else {
                    switch (snapshot.data.toString()) {
                      case UpiIndiaResponseError.APP_NOT_INSTALLED:
                        return Text(
                          'App not installed.',
                        );
                        break;
                      case UpiIndiaResponseError.INVALID_PARAMETERS:
                        return Text(
                          'Requested payment is invalid.',
                        );
                        break;
                      case UpiIndiaResponseError.USER_CANCELLED:
                        return Text(
                          'It seems like you cancelled the transaction.',
                        );
                        break;
                      case UpiIndiaResponseError.NULL_RESPONSE:
                        return Text(
                          'No data received',
                        );
                        break;
                      default:
                        UpiIndiaResponse _upiResponse;
                        _upiResponse = UpiIndiaResponse(snapshot.data);
                        String txnId = _upiResponse.transactionId;
                        String resCode = _upiResponse.responseCode;
                        String txnRef = _upiResponse.transactionRefId;
                        String status = _upiResponse.status;
                        String approvalRef = _upiResponse.approvalRefNo;

                        return Column(
                          children: <Widget>[
                            Text('Transaction Id: $txnId'),
                            Text('Response Code: $resCode'),
                            Text('Reference Id: $txnRef'),
                            Text('Status: $status'),
                            Text('Approval No: $approvalRef'),
                          ],
                        );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void emptyCart() {
    CharityApp.sharedPreferences
        .setStringList(CharityApp.userCartList, ['garbageValue']);
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

  Future writeOrderDetails(Map<String, dynamic> data) async {
    await CharityApp.firestore
        .collection(CharityApp.collectionUser)
        .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
        .collection(CharityApp.collectionDonations)
        .document(CharityApp.sharedPreferences.getString(CharityApp.userUID) +
            data['orderTime']) // Order ID = uid+currentID
        .setData(data, merge: true);
    await CharityApp.firestore
        .collection(CharityApp.collectionO)
        // .document(
        //     CharityApp.sharedPreferences.getString(CharityApp.userUID))
        // .collection(CharityApp.collectionDonations)
        .document(CharityApp.sharedPreferences.getString(CharityApp.userUID) +
            '#'
                '${data['orderTime']}') // Order ID = uid+currentID
        .setData(data, merge: true);
  }
}
