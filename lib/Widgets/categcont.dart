import 'package:flutter/material.dart';
import '../Config/config2.dart' as c;

class CategContainer extends StatelessWidget {
  String t;
  double ht;
  String path;
  CategContainer({this.t, this.ht, this.path});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Color(0xFFFFD56D),
          borderRadius: BorderRadius.circular(13)),
      child: Column(
        children: [
          Container(
            //padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            decoration: BoxDecoration(
                image: new DecorationImage(
                  image: new ExactAssetImage(
                    '$path',
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 1.0), //(x,y)
                    blurRadius: 8.0,
                  ),
                ],
                border: Border.all(color: Colors.black),
                color: Color(0xFFFFD56D),
                borderRadius: BorderRadius.circular(13)),
            height: MediaQuery.of(context).size.height / 4 - 30,
            width: MediaQuery.of(context).size.width / 2.4,
          ),
          Container(
            //decoration: BoxDecoration(color: Color(0xFFFFD56D)),
            alignment: Alignment.center,
            child: Text(
              t,
              style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold),
            ),
            height: 28,
            width: MediaQuery.of(context).size.width / 2.4,
          ),
        ],
      ),
    );
  }
}
