import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import '../Config/config.dart';
import '../utils/query.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Database database = Database();
  // String walletAmount = '';

  void initState() {
    // DocumentSnapshot userInfo = database.retrieveUserInfo();
    // if (userInfo.exists) {
    //   print('Document data: ${userInfo.data}');
    //   print('Subscribe:  ');
    //   print(userInfo.data['is_subscribe']);
    //   if (userInfo.data['wallet_amount'] == null) {
    //     setState(() {
    //       walletAmount = '0';
    //     });
    //     // CharityApp.firestore
    //     //     .collection(CharityApp.collectionUser)
    //     //     .document(reduced_uid)
    //     //     .setData({
    //     //   'wallet_amount': '0',
    //     // }, merge: true);
    //   } else {
    //     setState(() {
    //       walletAmount = userInfo.data['wallet_amount'];
    //     });
    //   }
    // } else {
    //   print('Document does not exist on the database');
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 32),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  _buildHeader(),
                  SizedBox(height: 16),
                  _buildGradientBalanceCard(),
                  SizedBox(height: 24.0),
                  _buildCategories(),
                ],
              ),
            ),
            SizedBox(height: 32),
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Expanded(
      child: Container(
        //height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.grey.withOpacity(0.1),
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0 * 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Transaction",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "See All",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16.0 * 2),
                  _buildTransactionItem(
                    color: Colors.deepPurpleAccent,
                    iconData: Icons.photo_size_select_actual,
                    title: "Electric Bill",
                    date: "Today",
                    amount: 11.5,
                  ),
                  SizedBox(height: 24),
                  _buildTransactionItem(
                    color: Colors.green,
                    iconData: Icons.branding_watermark,
                    title: "Water Bill",
                    date: "Today",
                    amount: 15.8,
                  ),
                  SizedBox(height: 24),
                  _buildTransactionItem(
                    color: Colors.orange,
                    iconData: Icons.music_video,
                    title: "Spotify",
                    date: "Yesterday",
                    amount: 05.5,
                  ),
                  SizedBox(height: 24),
                  _buildTransactionItem(
                    color: Colors.red,
                    iconData: Icons.wifi,
                    title: "Internet",
                    date: "Yesterday",
                    amount: 10.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildCategoryCard(
          bgColor: Constants.sendBackgroundColor,
          iconColor: Constants.sendIconColor,
          iconData: Icons.send,
          text: "Send",
        ),
        _buildCategoryCard(
          bgColor: Constants.activitiesBackgroundColor,
          iconColor: Constants.activitiesIconColor,
          iconData: Icons.work,
          text: "Activities",
        ),
        _buildCategoryCard(
          bgColor: Constants.statsBackgroundColor,
          iconColor: Constants.statsIconColor,
          iconData: Icons.trending_up,
          text: "Stats",
        ),
        _buildCategoryCard(
          bgColor: Constants.paymentBackgroundColor,
          iconColor: Constants.paymentIconColor,
          iconData: Icons.payment,
          text: "Payment",
        ),
      ],
    );
  }

  Container _buildGradientBalanceCard() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purpleAccent.withOpacity(0.9),
            Constants.deepBlue,
          ],
        ),
      ),
      child: FutureBuilder(
          future: database.retrieveUserInfo(),
          builder: (context, snapshot2) {
            String wallet_amount = snapshot2.data['wallet_amount'];
            if (snapshot2.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      wallet_amount,
                      //"\$8,458.00",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 28,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Total Balance",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '0',
                    //"\$8,458.00",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Total Balance",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
            ;
          }),
    );
  }

  Row _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Hello,",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              CharityApp.sharedPreferences.getString(CharityApp.userName),
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image:
                  CharityApp.sharedPreferences.getString(CharityApp.authtype) ==
                          'gauth'
                      ? NetworkImage(CharityApp.sharedPreferences
                          .getString(CharityApp.userAvatarUrl))
                      : AssetImage("assets/images/person.png"),
              colorFilter: ColorFilter.mode(
                Colors.deepPurple[100],
                BlendMode.darken,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _buildTransactionItem(
      {Color color,
      IconData iconData,
      String date,
      String title,
      double amount}) {
    return Row(
      children: <Widget>[
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              date,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            )
          ],
        ),
        Spacer(),
        Text(
          "-\$ $amount",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Column _buildCategoryCard(
      {Color bgColor, Color iconColor, IconData iconData, String text}) {
    return Column(
      children: <Widget>[
        Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            iconData,
            color: iconColor,
            size: 36,
          ),
        ),
        SizedBox(height: 8),
        Text(text),
      ],
    );
  }
}
