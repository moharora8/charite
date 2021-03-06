import 'package:cloud_firestore/cloud_firestore.dart';
import '../Store/product_page.dart';
import '../notifiers/cartitemcounter.dart';
import '../Config/light_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../navbar_labels/orders/all.dart';
import '../navbar_labels/orders/ongoing.dart';
import '../navbar_labels/orders/completed.dart';
import '../Config/config2.dart' as c;
import '../Config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../Config/config.dart';
import '../Widgets/customAppBar.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import 'package:carousel_pro/carousel_pro.dart';
import '../Widgets/drawer.dart';
import '../Widgets/searchBox.dart';
import '../modals/book.dart';
import '../modals/coupon.dart';
import '../modals/book2.dart';
import '../navbar_labels/home.dart';
import '../navbar_labels/offers.dart';
import '../navbar_labels/orders.dart';
import '../navbar_labels/categories.dart';
import '../navbar_labels/profile.dart';
import '../widgets/homecontainer.dart';
import '../Widgets/categcont.dart';
import '../Widgets/button.dart';
import 'dart:async';
import '../Notifications/on_launch.dart';
import '../Notifications/on_resume.dart';

double width;

class StoreHome extends StatefulWidget {
  int currentIndex;
  StoreHome({this.currentIndex});
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  Map<String, Map<String, dynamic>> details = {
    'centres': {
      '1': {
        'name': 'Prayas Sevankur Bhavan',
        'place': 'Amravati',
        'address':
            'Farshi Stop, Dastur Nagar Road, Vimalnagar, Dastur Nagar, Amravati, Maharashtra 444605',
        'stars': '4.3',
        'pincode': '444605',
        'website': 'http://prayasngo.net/',
        'images':
            'https://www.google.com/maps/uv?pb=!1s0x3bd6a4c0c9c30ba5%3A0xf48173854b988f16!3m1!7e115!4shttps%3A%2F%2Flh5.googleusercontent.com%2Fp%2FAF1QipMKXDXt3vVTOuVRr8IicezXLDAFsUbOHxtKJZwt%3Dw260-h175-n-k-no!5sngo%27s%20near%20me%20-%20Google%20Search!15sCgIgAQ&imagekey=!1e10!2sAF1QipMKXDXt3vVTOuVRr8IicezXLDAFsUbOHxtKJZwt&hl=en',
        'phone_no': '7212573256',
        'categories': ['oldagehome', 'child_adoption', 'ngo'],
      },
      '2': {
        'name': 'Sahyog Youth Welfare Society',
        'place': 'Amravati',
        'address':
            'Paonaskar Layout, Maltekdi Rd, Tope Nagar, Maltekdi, Amravati, Maharashtra 444603',
        'stars': '4.8',
        'pincode': '444603',
        'website': 'http://www.sahyogyouth.org/',
        'images': 'http://www.sahyogyouth.org/',
        'phone_no': '9730771699',
        'categories': ['ngo'],
      },
      '3': {
        'name': 'Bahujan Hitay Society Amravati-Solera',
        'place': 'Amravati',
        'address':
            'Plot No-79, near, Congress Nagar Rd, Bhumiputra Colony, Shyam Nagar, Amravati, Maharashtra 444602',
        'stars': '4.7',
        'pincode': '444603',
        'website': 'http://www.bhsociety.org/',
        'images':
            'https://www.google.com/maps/uv?pb=!1s0x3bd6a4906620c86d:0x88275a8e41a3011d!3m1!7e115!4shttps://lh5.googleusercontent.com/p/AF1QipP_g7GspM6kcJaW_F5_B-sUQ36yvGRTgL_C5VYi%3Dw260-h175-n-k-no!5sngo%27s+near+me+-+Google+Search!15zQ2dJZ0FRPT0&imagekey=!1e10!2sAF1QipP_g7GspM6kcJaW_F5_B-sUQ36yvGRTgL_C5VYi&hl=en',
        'phone_no': '9011179853',
        'categories': [
          'oldagehome',
          'ngo',
          'animal_adoption',
          'child_adoption'
        ],
      },
      '4': {
        'name': 'DISHA for victims',
        'place': 'Amravati',
        'address':
            'Teacher\'s colony Post, L.I.C. colony, Rukhmini Nagar, Vivekanand Colony, Amravati, Maharashtra 444606',
        'stars': '4.6',
        'pincode': '444606',
        'website':
            'https://www.google.com/maps/uv?pb=!1s0x3bd6a4959eb82175%3A0xdc69c478cb805165!3m1!7e115!4shttps%3A%2F%2Flh5.googleusercontent.com%2Fp%2FAF1QipOLVNLq535sk1YkAZN-5Tn-d2hperETnmggQvu5%3Dw260-h175-n-k-no!5sngos%20near%20me%20-%20Google%20Search!15sCgIgAQ&imagekey=!1e10!2sAF1QipOLVNLq535sk1YkAZN-5Tn-d2hperETnmggQvu5&hl=en',
        'images':
            'https://www.google.com/maps/uv?pb=!1s0x3bd6a4959eb82175%3A0xdc69c478cb805165!3m1!7e115!4shttps%3A%2F%2Flh5.googleusercontent.com%2Fp%2FAF1QipOLVNLq535sk1YkAZN-5Tn-d2hperETnmggQvu5%3Dw260-h175-n-k-no!5sngos%20near%20me%20-%20Google%20Search!15sCgIgAQ&imagekey=!1e10!2sAF1QipOLVNLq535sk1YkAZN-5Tn-d2hperETnmggQvu5&hl=en',
        'phone_no': '9011179853',
        'categories': ['oldagehome', 'ngo', 'animal_adoption'],
      },
    },
  };
  uploadTracks() async {
    // beginners
    int id = 1;
    details['centres'].forEach((key, value) async {
      DocumentReference documentReferencer =
          CharityApp.firestore.collection('centres').document(key);
      Map<String, dynamic> name = details['centres'][key];
      print(name);
      id = id + 1;

      await documentReferencer.setData(name, merge: true).whenComplete(() {
        print("$key track added to the database");
      }).catchError((e) => print(e));
    });
  }

  Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    dynamic data;
    dynamic notification;
    if (message.containsKey('data')) {
      // Handle data message
      data = message['data'];
    }
    if (message.containsKey('notification')) {
      // Handle notification message
      notification = message['notification'];
    }
    print('Data: $data');
    print('Notification: $notification');
    // Or do other work.
  }

  final fbm = FirebaseMessaging();
  _registerOnFirebase() {
    fbm.subscribeToTopic('all');
    fbm.subscribeToTopic('users');
    fbm.getToken().then((token) => print(token));
  }

  void getMessage() {
    fbm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('received message');
          String tag = message['data']['tag2'];
          // List<String> lt = message['data']['products'];
          print('ABCD:${message['data']['tag2']}');
          print('Tag: $tag');
          // print('Products:$lt');
          Route route = MaterialPageRoute(
              builder: (_) => OnResume(
                    message: message,
                  ));
          Navigator.push(context, route);
        },
        onResume: (Map<String, dynamic> message) async {
          print('received message');
          String tag = message['data']['tag2'];
          print('received message');
          //String tag = message['data']['tag2'];
          print('Tag: $tag');
          if (tag == 'order_accept') {
            print('Tag is $tag');
            print("onResume: $message");
            Route route = MaterialPageRoute(
                builder: (_) => OnResume(
                      message: message,
                    ));
            Navigator.push(context, route);
          } else if (tag == 'order_delivered') {
            print('Tag is $tag');
            print("onResume: $message");
            Route route =
                MaterialPageRoute(builder: (_) => OnResume(message: message));
            Navigator.push(context, route);
            //Show order is delivered successfully and mark order_status as Completed in database and remove it from agent's side
          } else if (tag == 'order_picked') {
            print('Tag is $tag');
            print("onResume: $message");
            Route route =
                MaterialPageRoute(builder: (_) => OnResume(message: message));
            Navigator.push(context, route);
          }
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('received message');
          String tag = message['data']['tag2'];

          print('Tag: $tag');

          if (tag == 'order_accept') {
            print('Tag is $tag');
            print("onLaunch: $message");
            Route route = MaterialPageRoute(
                builder: (_) => OnResume(
                      message: message,
                    ));
            Navigator.push(context, route);
            // Route route = MaterialPageRoute(builder: (_) => OnLaunch());
            // Navigator.push(context, route);
          } else if (tag == 'order_delivered') {
            print('Tag is $tag');
            print("onLaunch: $message");
            Route route = MaterialPageRoute(
                builder: (_) => OnResume(
                      message: message,
                    ));
            Navigator.push(context, route);
            //Show order is delivered successfully and mark order_status as Completed in database and remove it from agent's side
          } else if (tag == 'order_picked') {
            print('Tag is $tag');
            print("onLaunch: $message");
            Route route = MaterialPageRoute(
                builder: (_) => OnResume(
                      message: message,
                    ));
            Navigator.push(context, route);
          }
          //_navigateToItemDetail(message);
        },
        onBackgroundMessage: myBackgroundMessageHandler);
  }

  void initState() {
    //uploadTracks();
    _registerOnFirebase();
    Future.delayed(Duration(seconds: 2), () {
      getMessage();
    });
    super.initState();
  }

  // List<String> l = [
  //   'Groceries',
  //   'Vegetables',
  //   'Food Items',
  //   'Raw Meat & Fish',
  //   'Others',
  //   'Combined List'
  // ];

  //int widget.currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/new.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Color(0xFFF9EE23),
          showUnselectedLabels: true,
          currentIndex: widget.currentIndex,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.place_sharp),
              label: 'Places',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.history,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.map,
              ),
              label: 'Map',
            ),
          ],
          onTap: (index) {
            setState(() {
              widget.currentIndex = index;
            });
          },
        ),
        extendBodyBehindAppBar: true,
        drawer: Drawwer(),
        //MyDrawer(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: MyAppBar(),
            ),
            // widget.currentIndex == 1
            //     //2
            //     //|| widget.currentIndex == 4
            //     ? SliverPersistentHeader(
            //         pinned: true, delegate: SearchBoxDelegate())
            //     : SliverToBoxAdapter(child: SizedBox()),
            SliverToBoxAdapter(
              /// _buildCarousel() in your case....
              child: widget.currentIndex == 2
                  ? Categories()
                  //Home()
                  : widget.currentIndex == 1
                      ? Home()
                      //Categories()
                      : widget.currentIndex == 0
                          ? Profile()
                          : widget.currentIndex == 3
                              ? Orders()
                              : Offers(),
            ),

            widget.currentIndex == 4
                ? StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('users')
                        .document(CharityApp.sharedPreferences
                            .getString(CharityApp.userUID))
                        .collection('offers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? SliverToBoxAdapter(
                              child: Center(child: LoadingWidget()),
                            )
                          : SliverStaggeredGrid.countBuilder(
                              crossAxisCount: 1,
                              staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                              itemBuilder: (context, index) {
                                Coupon model2 = Coupon.fromJson(
                                    snapshot.data.documents[index].data);
                                return couponInfo(model2, context);
                              },
                              itemCount: snapshot.data.documents.length,
                            );
                    })
                : SliverToBoxAdapter(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

/////////////////////
Widget couponInfo(Coupon model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      // Route route =
      //     MaterialPageRoute(builder: (_) => ProductPage(bookModel: model));
      // Navigator.push(context, route);
    },
    splashColor: LightColor.purple,
    child: Container(
        //here
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
            color: Colors.black87, borderRadius: BorderRadius.circular(7)),
        height: 170,
        width: width - 20,
        child: Row(
          children: <Widget>[
            Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: .7,
                    child: card(
                        primaryColor: background, imgPath: model.thumbnailUrl),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    alignment: Alignment.topRight,
                    width: 50.0,
                    height: 50.0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${model.discount}%',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "OFF",
                            style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Text(model.title,
                            style: TextStyle(
                                color: LightColor.purple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 0.0,
                          ),
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Days remaining: ",
                                  style: AppTheme.h6Style.copyWith(
                                    fontSize: 14,
                                    color: LightColor.grey,
                                  )),
                              Text(model.days_remaining,
                                  style: AppTheme.h6Style.copyWith(
                                    fontSize: 14,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                        ),
                        Text(model.couponcode,
                            style: TextStyle(
                                color: LightColor.purple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      //color: Colors.amber,
                      onTap: () {},
                      child:
                          Text('Copy', style: TextStyle(color: Colors.amber)),
                    ),
                  ],
                ),
                Flexible(
                  child: Container(),
                ),
                Divider(
                  height: 4,
                )
              ],
            ))
          ],
        )),
  );
}

///
///

Widget sourceInfo2(BookModel2 model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      // Route route =
      //     MaterialPageRoute(builder: (_) => ProductPage(bookModel: model));
      // Navigator.push(context, route);
    },
    splashColor: LightColor.purple,
    child: Container(
        //here
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: Colors.black87, borderRadius: BorderRadius.circular(7)),
        height: 135,
        width: width - 20,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //SizedBox(height: 15),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Text(model.item,
                            style: TextStyle(
                                color: LightColor.purple,
                                //LightColor.purple,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            Text('${model.quantity}',
                                style: TextStyle(
                                  color: LightColor.grey,
                                  fontSize: 18,
                                )),
                            // IconButton(
                            //     color: LightColor.purple,
                            //     onPressed: () {},
                            //     icon: Icon(Icons.delete)),
                          ],
                        ),
                      ),
                      SizedBox(width: 10)
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(),
                      alignment: Alignment.topLeft,
                      width: 40.0,
                      height: 40.0,
                      child: Text(
                          model.description != null ? model.description : ' ',
                          style: TextStyle(
                              color: LightColor.purple,
                              fontSize: 16,
                              fontWeight: FontWeight.w400)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                          ),
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ],
                ),
                Flexible(
                  child: Container(),
                ),
                Divider(
                  height: 4,
                )
              ],
            ))
          ],
        )),
  );
}

Widget sourceInfo(BookModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route =
          MaterialPageRoute(builder: (_) => ProductPage(bookModel: model));
      Navigator.push(context, route);
    },
    splashColor: LightColor.purple,
    child: Container(
        //here
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
            color: Colors.black87, borderRadius: BorderRadius.circular(7)),
        height: 170,
        width: width - 20,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: .7,
              child:
                  card(primaryColor: background, imgPath: model.thumbnailUrl),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Text(model.title,
                            style: TextStyle(
                                color: LightColor.purple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: background,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(model.weight,
                          style: TextStyle(
                            color: LightColor.grey,
                            fontSize: 14,
                          )),
                      SizedBox(width: 10)
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      alignment: Alignment.topLeft,
                      width: 40.0,
                      height: 40.0,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "50%",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              "OFF",
                              style: TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              Text("M.R.P.: ₹",
                                  style: AppTheme.h6Style.copyWith(
                                    fontSize: 14,
                                    color: LightColor.grey,
                                  )),
                              Text("1500.0",
                                  style: AppTheme.h6Style.copyWith(
                                      fontSize: 14,
                                      color: LightColor.grey,
                                      decoration: TextDecoration.lineThrough)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 0.0,
                          ),
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Price: ",
                                  style: AppTheme.h6Style.copyWith(
                                    fontSize: 14,
                                    color: LightColor.grey,
                                  )),
                              Text(
                                "₹",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14.0),
                              ),
                              Text(model.price.toString(),
                                  style: AppTheme.h6Style.copyWith(
                                    fontSize: 14,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Flexible(
                  child: Container(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: removeCartFunction == null
                      ? IconButton(
                          icon: Icon(
                            Icons.add_shopping_cart,
                            color: c.primaryColor.withOpacity(1),
                            // c.primaryColor.withBlue(56)
                            //LightColor.purple,
                          ),
                          onPressed: () {
                            checkItemInCart(model.isbn, context);
                          })
                      : IconButton(
                          icon: Icon(
                            Icons.remove_shopping_cart,
                            color: c.primaryColor.withOpacity(1),
                            //LightColor.purple,
                          ),
                          onPressed: () {
                            print('StoreHome.dart');
                            removeCartFunction();
                            //checkItemInCart(model.isbn, context);
                          }),
                ),
                Divider(
                  height: 4,
                )
              ],
            ))
          ],
        )),
  );
}

// ignore: unused_element
Widget _chip(String text, Color textColor,
    {double height = 0, bool isPrimaryCard = false}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Chip(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
      label: Text(
        text,
        style: TextStyle(
            color: isPrimaryCard ? Colors.white : textColor, fontSize: 12),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
      height: 150,
      width: width * .34,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(0, 5), blurRadius: 10, color: Color(0x12000000))
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Image.network(
          imgPath,
          height: 150,
          width: width * .34,
          fit: BoxFit.fill,
        ),
      ));
}

void checkItemInCart(String productID, BuildContext context) {
  print(productID);

  ///print(cartItems);
  CharityApp.sharedPreferences
          .getStringList(
            CharityApp.userCartList,
          )
          .contains(productID)
      ? Fluttertoast.showToast(msg: 'Product is already in cat')
      : addToCart(productID, context);
}

void addToCart(String productID, BuildContext context) {
  List temp = CharityApp.sharedPreferences.getStringList(
    CharityApp.userCartList,
  );
  temp.add(productID);
  CharityApp.firestore
      .collection(CharityApp.collectionUser)
      .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
      .updateData({CharityApp.userCartList: temp}).then((_) {
    Fluttertoast.showToast(msg: 'Item Added Succesfully');
    CharityApp.sharedPreferences.setStringList(CharityApp.userCartList, temp);
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
