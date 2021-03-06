import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pulzion/Config/config.dart';
import 'package:pulzion/Payment/payment.dart';
import 'package:upi_india/upi_india.dart';
import 'package:url_launcher/url_launcher.dart';
import '../style.dart' as style;

class CustCont2 extends StatefulWidget {
  Function abcd;
  String title;
  String img;
  String address;
  List<dynamic> categ;
  String images;
  String phone;
  String website;
  String place;
  String stars;
  String icon;
  String id;
  @override
  CustCont2(
      {this.address,
      this.categ,
      this.id,
      this.images,
      this.icon,
      this.website,
      this.phone,
      this.place,
      this.stars,
      this.abcd,
      this.title,
      this.img});
  _CustCont2State createState() => _CustCont2State();
}

class _CustCont2State extends State<CustCont2> {
  DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
  bool c11 = false;
  DateTime day = DateTime.now();
  bool c12 = false;
  TimeOfDay start_now3 = TimeOfDay(hour: 10, minute: 10);
  int _currentValue3 = 2;
  String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
  @override
  TextEditingController _amountController = TextEditingController();

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 250,
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: InkWell(
              onTap: widget.abcd,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      style.Style.lowerGradientColor,
                      style.Style.upperGradientColor,

                      // Colors.white54,
                      // Colors.white,
                    ],
                  ),
                ),
              )),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15, 0, 20, 0),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(widget.icon),
                radius: 30,
              ),
              Spacer(),
              Text(widget.stars + ' / ' + '5.0',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  )),
              SizedBox(
                width: 60,
              ),
              Text('~3.8km~',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ))
            ],
          ),
        ),
        Positioned(
            top: 60,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                    )),
                SizedBox(height: 15),
                Row(
                  children: [
                    ...List.generate(widget.categ.length, (index) {
                      return Text(widget.categ[index] + ' | ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ));
                    })
                  ],
                ),
                SizedBox(height: 10),
                Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width - 40,
                    child: Text(widget.address,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ))),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Place: ' + widget.place,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        )),
                    SizedBox(width: 30),
                    InkWell(
                      onTap: () async {
                        final url = widget.images;
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text('View Images',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          )),
                    ),
                    SizedBox(width: 30),
                    InkWell(
                      onTap: () async {
                        final url = widget.website;
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text('Website',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          )),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width - 40,
                  color: Colors.white38,
                ),
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  title: Text('Add amount to donate'),
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      child: TextField(
                                        controller: _amountController,
                                        decoration: InputDecoration(
                                          labelText: 'Amount',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    FlatButton(
                                      color: Theme.of(context).primaryColor,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Route route = MaterialPageRoute(
                                            builder: (_) => PaymentPage(
                                                  addressID: widget.id,
                                                  totalAmount: double.parse(
                                                      _amountController.text),
                                                  details: [
                                                    [
                                                      'Paytm',
                                                      'PhonePe',
                                                      'GooglePay'
                                                    ],
                                                    [
                                                      '8007347723@PAYTM',
                                                      '8007347723@ybl',
                                                      'moharora8@okaxis'
                                                    ],
                                                    [
                                                      UpiIndiaApps.PayTM,
                                                      UpiIndiaApps.PhonePe,
                                                      UpiIndiaApps.GooglePay
                                                    ]
                                                  ],
                                                ));
                                        Navigator.push(context, route);
                                      },
                                      child: Text('Donate now'),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text('Donate',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      Text('Volunteer',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              )),
                              isScrollControlled: true,
                              //isDismissible: false,
                              backgroundColor: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    //stream: null,
                                    builder: (context, setState2) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.75,
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      padding:
                                          EdgeInsets.fromLTRB(15, 15, 15, 0),
                                      child: ListView(
                                        children: [
                                          Center(
                                              child: Text(
                                                  'Scheduling Appointment')),
                                          Divider(),
                                          Row(
                                            children: <Widget>[
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.blue),
                                                  )),
                                              Spacer(),
                                              FlatButton(
                                                  onPressed: () {
                                                    String strDate = dateFormat
                                                        .format(day)
                                                        .toString();
                                                    setState(() {
                                                      CharityApp.firestore
                                                          .collection(CharityApp
                                                              .collectionUser)
                                                          .document(CharityApp
                                                              .sharedPreferences
                                                              .getString(
                                                                  CharityApp
                                                                      .userUID))
                                                          .collection(
                                                              'appointments')
                                                          .document(widget.id +
                                                              currentTime)
                                                          .setData({
                                                        'day': strDate,
                                                        'createdAt': FieldValue
                                                            .serverTimestamp(),
                                                        'platform': Platform
                                                            .operatingSystem,
                                                        //CharityApp.isSubscribe: false,
                                                      }, merge: true);
                                                      //Add to database
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'Save',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.blue),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                15, 0, 15, 0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      'Meet me at',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Spacer(),
                                                    FlatButton(
                                                      onPressed: () {
                                                        setState2(() {
                                                          c11 = !c11;
                                                          c12 = false;
                                                        });

                                                        //startPeriodTime1();
                                                      },
                                                      child: Text(
                                                        day.day.toString() +
                                                            '/' +
                                                            day.month
                                                                .toString() +
                                                            '/' +
                                                            day.year
                                                                .toString() +
                                                            '  ' +
                                                            day.hour
                                                                .toString() +
                                                            ':' +
                                                            day.minute
                                                                .toString() +
                                                            '  ' +
                                                            day.timeZoneName,
                                                        //.format(context),
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              108, 45, 5, 1),
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                c11 == true
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors
                                                                      .black12
                                                                  : Colors
                                                                      .white38,
                                                            ),
                                                            bottom: BorderSide(
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors
                                                                      .black12
                                                                  : Colors
                                                                      .white38,
                                                            ),
                                                          ),
                                                        ),
                                                        height: 207,
                                                        child:
                                                            CupertinoDatePicker(
                                                          initialDateTime:
                                                              DateTime.now(),
                                                          onDateTimeChanged:
                                                              (DateTime
                                                                  newdate) {
                                                            setState2(() {
                                                              day = newdate;
                                                              start_now3 = TimeOfDay
                                                                  .fromDateTime(
                                                                      newdate);
                                                              print(start_now3);
                                                            });

                                                            print(newdate);
                                                          },
                                                          maximumDate:
                                                              new DateTime(
                                                                  2021, 12, 30),
                                                          minimumYear: 2010,
                                                          maximumYear: 2022,
                                                          minuteInterval: 1,
                                                          mode:
                                                              CupertinoDatePickerMode
                                                                  .dateAndTime,
                                                        ),
                                                        //datetime3(),
                                                      )
                                                    : SizedBox(height: 10),
                                                // c12 == true
                                                //     ? Container(
                                                //         decoration:
                                                //             BoxDecoration(
                                                //           border: Border(
                                                //             top: BorderSide(
                                                //               color: Theme.of(context)
                                                //                           .brightness ==
                                                //                       Brightness
                                                //                           .light
                                                //                   ? Colors
                                                //                       .black12
                                                //                   : Colors
                                                //                       .white38,
                                                //             ),
                                                //             bottom: BorderSide(
                                                //               color: Theme.of(context)
                                                //                           .brightness ==
                                                //                       Brightness
                                                //                           .light
                                                //                   ? Colors
                                                //                       .black12
                                                //                   : Colors
                                                //                       .white38,
                                                //             ),
                                                //           ),
                                                //         ),
                                                //         height: 195,
                                                //         width: MediaQuery.of(
                                                //                 context)
                                                //             .size
                                                //             .width,
                                                //         // MediaQuery.of(context)
                                                //         //         .copyWith()
                                                //         //         .size
                                                //         //         .height /
                                                //         //     5.5,
                                                //         child: NumberPicker.integer(
                                                //             selectedTextStyle: TextStyle(
                                                //                 color: Color
                                                //                     .fromRGBO(
                                                //                         51,
                                                //                         51,
                                                //                         51,
                                                //                         1),
                                                //                 fontSize: 23,
                                                //                 fontWeight:
                                                //                     FontWeight
                                                //                         .w400),
                                                //             highlightSelectedValue:
                                                //                 true,
                                                //             initialValue:
                                                //                 _currentValue3,
                                                //             minValue: 0,
                                                //             maxValue: 17,
                                                //             onChanged: (newVal) =>
                                                //                 setState2(() =>
                                                //                     _currentValue3 =
                                                //                         newVal)),
                                                //       )
                                                //     : SizedBox(
                                                //         //height: 18,
                                                //         ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              });
                        },
                        child: Text('Adopt',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      //Text('a'),
                    ],
                  ),
                  // color: Colors.white38,
                ),
              ],
            )),
      ],
    );
  }
}
