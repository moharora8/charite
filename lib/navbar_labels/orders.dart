import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/homecontainer.dart';
import 'package:carousel_pro/carousel_pro.dart';
import '../Widgets/categcont.dart';
import '../Widgets/button.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/homecontainer.dart';
// import 'package:carousel_pro/carousel_pro.dart';
import '../Widgets/categcont.dart';
import '../Widgets/button.dart';
import 'dart:async';
import '../Config/config.dart';
import 'orders/all.dart';
import 'orders/completed.dart';
import 'orders/ongoing.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<bool> abcd = new List();
  List<bool> abcd2 = new List();
  int index2 = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3, // length of tabs
        initialIndex: 0,
        child: Column(
          children: [
            Container(
              child: TabBar(
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Color(0xFFCC9B66),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(
                      child: FittedBox(
                    child: Text(
                      'All',
                      style: TextStyle(fontSize: 16),
                    ),
                  )),
                  Tab(
                      child: Text(
                    'Successful',
                    style: TextStyle(fontSize: 16),
                  )),
                  Tab(
                      child: Text(
                    'Failed',
                    style: TextStyle(fontSize: 16),
                  )),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: TabBarView(children: <Widget>[
                All(),
                Completed(),
                Ongoing(),
              ]),
            ),
          ],
        ));
  }
}
