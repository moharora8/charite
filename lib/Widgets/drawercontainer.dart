import 'package:flutter/material.dart';

class DrawContainer extends StatelessWidget {
  String t;
  DrawContainer({this.t});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFFFFD56D),
        border: Border(bottom: BorderSide(color: Colors.black)),
      ),
      child: Text(t,
          style: TextStyle(
              fontFamily: 'EastSeaDokdo',
              fontWeight: FontWeight.w400,
              fontSize: 28,
              color: Colors.black)),
    );
  }
}
