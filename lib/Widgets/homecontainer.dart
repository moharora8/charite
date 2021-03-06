import 'package:flutter/material.dart';

class HomeContainer extends StatelessWidget {
  String t;
  double ht;
  HomeContainer({this.t, this.ht});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      height: ht == null ? 50 : ht,
      decoration: BoxDecoration(
        color: Color(0xFFFFD56D),
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Center(
          child: Text(
        t,
        style: TextStyle(
            fontSize: 20,
            height: 1.5,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold),
      )),
    );
  }
}
