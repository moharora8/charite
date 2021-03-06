import 'package:flutter/material.dart';
import '../Config/config2.dart' as c;

class Button extends StatefulWidget {
  String str;
  Button({this.str});
  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [primaryColor, secondaryColor],
          // ),
          color: c.primaryColor,
          borderRadius: BorderRadius.circular(8)),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
      child: Center(
          child: Text(
        '${widget.str}',
        style: TextStyle(
          color: Colors.white,
        ),
      )),
    );
  }
}
