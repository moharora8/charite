import 'package:flutter/material.dart';
import '../Config/config.dart';

import '../Config/config2.dart' as c;

class Charge extends StatefulWidget {
  @override
  _ChargeState createState() => _ChargeState();
}

class _ChargeState extends State<Charge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/new.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pair with charger",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      //   child: Text(
                      //     "Done",
                      //     style: TextStyle(
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Image.asset('assets/images/cc.jpg',
                    fit: BoxFit.cover, height: 300),
                // CharityApp.sharedPreferences
                //             .getString(CharityApp.authtype) ==
                //         'gauth'
                //     ? Column(
                //         children: [
                //           ClipRRect(
                //             borderRadius: BorderRadius.circular(20),
                //             child: Image.network(CharityApp.sharedPreferences
                //                 .getString(CharityApp.userAvatarUrl)),
                //           ),
                //           Text(CharityApp.sharedPreferences
                //               .getString(CharityApp.userName)),
                //         ],
                //       )
                //     : SizedBox()
              ],
            ),
          )),
    );
  }
}
