import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulzion/Widgets/custcont2.dart';
import '../Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';
import '../modals/address.dart';
import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';
// ignore: unused_import
import '../Delievery/geolocation.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatelessWidget {
  final String orderID;

  const OrderDetails({Key key, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
            future: CharityApp.firestore
                .collection(CharityApp.collectionUser)
                .document(
                    CharityApp.sharedPreferences.getString(CharityApp.userUID))
                .collection(CharityApp.collectionDonations)
                .document(orderID)
                .get(),
            builder: (_, snapshot) {
              ///Map data = snapshot.data[];
              Map data;
              if (snapshot.hasData) {
                data = snapshot.data.data;
              }
              print('Printing data : $data');
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: <Widget>[
                          DashboardScreen(),
                          StatusBanner(
                            status: data[CharityApp.isSuccess],
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(4.0),
                          //   child: Align(
                          //     alignment: Alignment.centerLeft,
                          //     child: Text(
                          //       '₹ ${data[CharityApp.totalAmount].toString()}',
                          //       style: TextStyle(
                          //           fontSize: 20, fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('Donation ID: $orderID'),
                          ),
//                              orderID: orderID,
                          data[CharityApp.isSuccess]
                              ? PaymentDetailsCard(
                                  date: data[CharityApp.orderTime],
                                  response: data[CharityApp.paymentDetails],
                                )
                              : Container(),
                          Divider(),
                          // FutureBuilder<QuerySnapshot>(
                          //     future: Firestore.instance
                          //         .collection('items')
                          //         .where('isbn',
                          //             whereIn: data[CharityApp.productID])
                          //         .getDocuments(),
                          //     builder: (_, snap) {
                          //       return snap.hasData
                          //           ? OrderCard(
                          //               itemCount: snap.data.documents.length,
                          //               data: snap.data.documents,
                          //             )
                          //           : Center(
                          //               child: LoadingWidget(),
                          //             );
                          //     }),

                          // Divider(),
                          FutureBuilder<DocumentSnapshot>(
                            future: CharityApp.firestore
                                .collection('centres')
                                .document(data[CharityApp.addressID])
                                .get(),
                            builder: (_, snapshot) {
                              String id = snapshot.data.documentID;
                              print(id);
                              String name = snapshot.data['name'];
                              print(name);
                              String address = snapshot.data['address'];
                              String images = snapshot.data['images'];
                              String website = snapshot.data['website'];
                              String phone_no = snapshot.data['phone_no'];
                              String pincode = snapshot.data['pincode'];
                              String stars = snapshot.data['stars'];
                              String place = snapshot.data['place'];
                              List<dynamic> categ = snapshot.data['categories'];
                              return snapshot.hasData
                                  ? Container(
                                      height: 200,
                                      child: CustCont2(
                                        id: id,
                                        title: name,
                                        address: address,
                                        categ: categ,
                                        place: place,
                                        website: website,
                                        images: images,
                                        stars: stars,
                                        phone: phone_no,
                                        icon: 'assets/images/10261 (1).jpg',
                                      ),
                                    )
                                  // ShippingDetails(
                                  //     model: AddressModel.fromJson(
                                  //         snapshot.data.data),
                                  //   )
                                  : LoadingWidget();
                            },
                          ),
                        ],
                      ),
                    )
                  : LoadingWidget();
            }),
      )),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;

  const StatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message;
    IconData iconData;
    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? message = 'Successful' : message = 'Not Successful';
    //'Unsuccessful';
    // ignore: todo
    // TODO: implement build
    return Container(
      color: Colors.deepPurple,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Donation is $message',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 5,
          ),
          CircleAvatar(
              radius: 8,
              backgroundColor: Colors.grey,
              child: Center(
                child: Icon(
                  iconData,
                  color: Colors.white,
                  size: 14,
                ),
              )),
        ],
      ),
    );
  }
}

class PaymentDetailsCard extends StatelessWidget {
  final String response, date;

  const PaymentDetailsCard({
    Key key,
    this.response,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UpiIndiaResponse _upiResponse;
    _upiResponse = UpiIndiaResponse(response);
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                  'Transaction Reference No: ${_upiResponse.transactionRefId}'),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child:
                  Text('Approval Reference No: ${_upiResponse.approvalRefNo}'),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('TransactionID: ${_upiResponse.transactionId}'),
            ),

            //Text(DateFormat().parse(date).toString()),
          ],
        ),
      ),
    );
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;

  const ShippingDetails({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('Shipping Details',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: _screenWidth,
          child: Table(
            children: [
              TableRow(children: [
                KeyText(message: 'Name'),
                Text(model.name),
              ]),
              TableRow(children: [
                KeyText(message: 'Phone Number'),
                Text(model.phoneNumber),
              ]),
              TableRow(children: [
                KeyText(message: 'Flat Number'),
                Text(model.flatNumber),
              ]),
              TableRow(children: [
                KeyText(message: 'Area'),
                Text(model.area),
              ]),
              TableRow(children: [
                KeyText(message: 'Landmark'),
                Text(model.landmark),
              ]),
              TableRow(children: [
                KeyText(message: 'City'),
                Text(model.city),
              ]),
              TableRow(children: [
                KeyText(message: 'State'),
                Text(model.state),
              ]),
              TableRow(children: [
                KeyText(
                  message: 'pincode',
                ),
                Text(model.pincode),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}

class FailureOrderDetails extends StatelessWidget {
  final UpiIndiaResponse upiResponse;

  FailureOrderDetails({Key key, this.upiResponse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text('Amounnt'),
          Text('Transaction Reference No: ${'ff'}'),
          Text('Approval Reference No: ${'ff'}'),
          Text('TransactionID: ${'ff'}'),
          Text('Order ID: ${'ff'}'),
          Text('Date'),
        ],
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
      style: TextStyle(
        color: Colors.black,
      ),
    );
  }
}
