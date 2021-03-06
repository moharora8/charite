import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Config/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ongoing extends StatefulWidget {
  @override
  _OngoingState createState() => _OngoingState();
}

class _OngoingState extends State<Ongoing> {
  List<bool> abcd2 = new List();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CharityApp.firestore
          // .collection(CharityApp.collectionUser)
          // .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
          .collection('orders')
          .snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? LinearProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text('Ongoing Orders'),
                  SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        abcd2.add(false);
                        DocumentSnapshot products =
                            snapshot.data.documents[index];
                        return products.documentID.substring(0, 4) ==
                                    CharityApp.sharedPreferences
                                        .getString(CharityApp.userUID) &&
                                products['isSuccess'] == false
                            ? Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        abcd2[index] = !abcd2[index];
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('OrderID: '),
                                              FittedBox(
                                                child: Text(
                                                  '${snapshot.data.documents[index].documentID}',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  abcd2[index] == true
                                      ? Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 5, 0, 0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 55,
                                          color: Colors.black,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  products['totalAmount']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 20)),
                                              products['isSuccess'] == true
                                                  ? Text('Donation Successful',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 20))
                                                  : Text(
                                                      'Donation Not Successful',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 20))
                                            ],
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              )
                            : SizedBox();
                      },
                    ),
                  ),
                ],
              );
      },
    );
  }
}
