import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard2.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            title: Text("My Orders"),
            backgroundColor: Colors.blueGrey,
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: CharityApp.firestore
                  .collection(CharityApp.collectionUser)
                  .document(CharityApp.sharedPreferences
                      .getString(CharityApp.userUID))
                  .collection(CharityApp.collectionOrders)
                  .snapshots(),
              builder: (_, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (_, index) {
                          return FutureBuilder<QuerySnapshot>(
                              future:
                                  // Firestore.instance
                                  //     .collection('items')
                                  Firestore.instance
                                      // .collection('items')
                                      .collection(CharityApp.collectionUser)
                                      .document(CharityApp.sharedPreferences
                                          .getString(CharityApp.userUID))
                                      .collection(CharityApp.userItem2)
                                      .where('item',
                                          whereIn: snapshot
                                              .data
                                              .documents[index]
                                              .data[CharityApp.productID])
                                      .getDocuments(),
                              builder: (_, snap) {
                                return snap.hasData
                                    ? OrderCard(
                                        itemCount: snap.data.documents.length,
                                        data: snap.data.documents,
                                        orderID: snapshot
                                            .data.documents[index].documentID)
                                    : Center(child: LoadingWidget());
                              });
                        })
                    : Center(child: LoadingWidget());
              })),
    );
  }
}
