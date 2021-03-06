import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulzion/Widgets/custcont2.dart';
import '../widgets/homecontainer.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Config/config.dart';
import 'dart:async';
import '../globals.dart' as globals;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DocumentReference _db2;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        //color: Colors.red,
        // padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: StreamBuilder<QuerySnapshot>(
            stream: CharityApp.firestore.collection('centres').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      print(snapshot.data.documents[index].data['name']);
                      print(snapshot.data.documents[index].documentID);
                      String id = snapshot.data.documents[index].documentID;
                      String name = snapshot.data.documents[index].data['name'];
                      String address =
                          snapshot.data.documents[index].data['address'];
                      String images =
                          snapshot.data.documents[index].data['images'];
                      String website =
                          snapshot.data.documents[index].data['website'];
                      String phone_no =
                          snapshot.data.documents[index].data['phone_no'];
                      String pincode =
                          snapshot.data.documents[index].data['pincode'];
                      String stars =
                          snapshot.data.documents[index].data['stars'];
                      String place =
                          snapshot.data.documents[index].data['place'];
                      List<dynamic> categ =
                          snapshot.data.documents[index].data['categories'];
                      return CustCont2(
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
                      );
                    });
              } else {
                return LinearProgressIndicator();
              }
            }),
      ),
    );
  }
}
