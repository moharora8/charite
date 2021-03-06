import 'package:cloud_firestore/cloud_firestore.dart';
import '../Config/config.dart';
import '../Delievery/address.dart';
import '../Widgets/customAppBar.dart';
import '../Widgets/loadingWidget.dart';
import '../modals/book2.dart';
import '../notifiers/cartitemcounter.dart';
import '../notifiers/totalMoney.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Store/storehome.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import '../main.dart';
import '../Config/config2.dart' as c;
import '../globals.dart' as globals;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount;
  String store = '';

  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).display(0);
  }

  bool rememberMe = false;
  bool rememberMe2 = false;
  void final_dialog() {
    TextEditingController _taskstoreController = TextEditingController();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState2) {
            return SimpleDialog(
              title: Text("Want to buy from specific store?"),
              children: [
                Row(
                  children: [
                    SizedBox(width: 30),
                    Text('Yes'),
                    Checkbox(
                        value: rememberMe,
                        onChanged: (bool newVal) {
                          setState2(() {
                            rememberMe = newVal;
                            if (rememberMe) {
                              rememberMe2 = false;
                            }
                          });
                        }),
                    SizedBox(width: 30),
                    Text('No'),
                    Checkbox(
                        value: rememberMe2,
                        onChanged: (bool newVal) {
                          setState2(() {
                            rememberMe2 = newVal;
                            if (rememberMe2) {
                              rememberMe = false;
                            }
                          });
                        }),
                  ],
                ),
                rememberMe == true
                    ? Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                        child: TextField(
                          controller: _taskstoreController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter Store name here",
                              labelText: "Store Name"),
                        ),
                      )
                    : SizedBox(),
                rememberMe == true || rememberMe2 == true
                    ? Center(
                        child: Row(
                          children: [
                            SizedBox(width: 30),
                            FlatButton(
                              color: c.primaryColor,
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            SizedBox(width: 30),
                            FlatButton(
                              color: c.primaryColor,
                              child: Text("Add to trolley"),
                              onPressed: () {
                                store = _taskstoreController.text.trim();
                                print(store);
                                // CharityApp.sharedPreferences
                                //     .setString(CharityApp.store, store);
                                setState(() {
                                  globals.storename = store;
                                  if (rememberMe2) {
                                    globals.storename = '';
                                  }
                                  print(globals.storename);
                                  // if (store != null) {
                                  //   globals.storename = store;
                                  //   print(globals.storename);
                                  // }
                                });

                                //   CharityApp.sharedPreferences
                                //       .setString(CharityApp.store, store);
                                // } else {
                                //   CharityApp.sharedPreferences
                                //       .setString(CharityApp.store, '');
                                // }

                                // CharityApp.firestore
                                //     .collection(CharityApp.collectionUser)
                                //     .document(CharityApp.sharedPreferences
                                //         .getString(CharityApp.userUID))
                                //     .collection(CharityApp.userOrderList)
                                //     .document(DateTime.now().toString())
                                //     .setData({
                                //   // "cart": lt,
                                //   "store": store,
                                //   // "date": DateTime.now(),
                                //   // "category": cat,
                                //   // "description": desc,
                                //   // "quantity": quantity
                                // }, merge: true);
                                Route route = MaterialPageRoute(
                                    builder: (_) => Address(
                                          totalAmount: totalAmount.toDouble(),
                                        ));
                                Navigator.push(context, route);
                                Fluttertoast.showToast(
                                    msg: 'Items Added in Trolley Succesfully');
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            );
          });
        });
  }

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
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (CharityApp.sharedPreferences
                    .getStringList(CharityApp.userCartList)
                    .length ==
                1) {
              Fluttertoast.showToast(msg: 'No item in cart');
            } else {
              //Change here
              //final_dialog();
              Route route = MaterialPageRoute(
                  builder: (_) => Address(
                        totalAmount: totalAmount.toDouble(),
                      ));
              Navigator.push(context, route);
              Fluttertoast.showToast(msg: 'Items Added in Trolley Succesfully');
            }
          },
          label: Text('Check Out'),
          backgroundColor: c.primaryColor,
          //Colors.deepPurple,
          icon: Icon(Icons.navigate_next),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: MyAppBar(),
            ),
            // SliverToBoxAdapter(
            //   child: Consumer2<TotalAmount, CartItemCounter>(
            //       builder: (context, amountProvider, cartProvider, _) {
            //     return Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Center(
            //         child: cartProvider.count == 0
            //             ? Container()
            //             : Text(
            //                 'Total price: ${amountProvider.totalAmount.toString()}',
            //                 style: TextStyle(
            //                     color: Colors.black,
            //                     fontSize: 20.0,
            //                     fontWeight: FontWeight.w500),
            //               ),
            //       ),
            //     );
            //   }),
            // ),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    // .collection('items')
                    .collection(CharityApp.collectionUser)
                    .document(CharityApp.sharedPreferences
                        .getString(CharityApp.userUID))
                    .collection(CharityApp.userItem)
                    .where('item',
                        whereIn: CharityApp.sharedPreferences.getStringList(
                          CharityApp.userCartList,
                        ))
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? SliverToBoxAdapter(
                          child: Center(child: LoadingWidget()),
                        )
                      : snapshot.data.documents.length == 0
                          ? startBuildingCart()
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  BookModel2 model = BookModel2.fromJson(
                                      snapshot.data.documents[index].data);
                                  if (index == 0) {
                                    totalAmount = 0;
                                    //totalAmount = model.price + totalAmount;
                                  } else {
                                    totalAmount = 0;
                                    //model.price + totalAmount;
                                  }

                                  print('Price $totalAmount');
                                  print('index $index');
                                  print(model.toJson());
                                  print(
                                      'Lenghth ${snapshot.data.documents.length - 1}');
                                  print(
                                      'ID: ${snapshot.data.documents[index].documentID}');
                                  if (snapshot.data.documents.length - 1 ==
                                      index) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      Provider.of<TotalAmount>(context,
                                              listen: false)
                                          .display(totalAmount);
                                      // Add Your Code here.
                                    });
                                  }
                                  return sourceInfo2(model, context,
                                      removeCartFunction: () =>
                                          removeItemInCart(model.item));
                                },
                                childCount: snapshot.hasData
                                    ? snapshot.data.documents.length
                                    : 0,
                              ),
                            );
                })
          ],
        ),
      ),
    );
  }

  // ignore: todo
  // TODO Make design better
  startBuildingCart() {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.insert_emoticon, color: Colors.white),
                Text('You dont have any product in cart'),
                Text('Start building your cart now!!'),
              ],
            )),
      ),
    );
  }

  removeItemInCart(String productID) {
    print('Someone called me');
    List temp = CharityApp.sharedPreferences.getStringList(
      CharityApp.userCartList,
    );
    temp.remove(productID);

    CharityApp.firestore
        .collection(CharityApp.collectionUser)
        .document(CharityApp.sharedPreferences.getString(CharityApp.userUID))
        .updateData({CharityApp.userCartList: temp}).then((_) {
      Fluttertoast.showToast(msg: 'Item Removed Succesfully');
      CharityApp.sharedPreferences.setStringList(CharityApp.userCartList, temp);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
      totalAmount = 0;
      // CharityApp.firestore
      //     .collection(CharityApp.collectionUser)
      //     .document(
      //         CharityApp.sharedPreferences.getString(CharityApp.userUID))
      //     .collection(CharityApp.userItem)
      //     .where('item', productID).delete();
      setState(() {});
    });
  }
}
