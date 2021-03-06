// import '../Store/cart.dart';
import '../Store/cart2.dart';

import '../notifiers/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Config/config2.dart' as c;

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      shadowColor: Colors.transparent,
      elevation: 0,
      backgroundColor: Color(0xFFFFD56D),
      centerTitle: true,
      title: Text("charité", style: TextStyle(color: Colors.black)),
      bottom: bottom,
      //backgroundColor: Colors.transparent,
      // actions: <Widget>[
      //   Stack(
      //     children: <Widget>[
      //       IconButton(
      //         icon: Icon(
      //           Icons.shopping_cart,
      //           color: Colors.black,
      //         ),
      //         onPressed: () {
      //           Route route = MaterialPageRoute(builder: (_) => CartPage());
      //           Navigator.push(context, route);
      //         },
      //       ),
      //       Positioned(
      //           child: Stack(
      //         children: <Widget>[
      //           Icon(
      //             Icons.brightness_1, size: 20.0,
      //             color: c.primaryColor.withOpacity(1),
      //             //Colors.deepPurple
      //           ),
      //           Positioned(
      //               top: 3.0,
      //               right: 4.0,
      //               child: Center(
      //                 child: Consumer<CartItemCounter>(
      //                     builder: (context, counter, _) {
      //                   return Text(
      //                     counter.count != null
      //                         ? counter.count.toString()
      //                         : '0',
      //                     style: TextStyle(
      //                         color: Colors.white,
      //                         fontSize: 11.0,
      //                         fontWeight: FontWeight.w500),
      //                   );
      //                 }),
      //               )),
      //         ],
      //       )),
      //     ],
      //   ),
      // ],
    );
  }

  // Adding 80 because height of bottom SearchBox container is 80
  @override
  // ignore: todo
  // TODO: implement preferredSize
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
