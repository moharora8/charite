import 'package:flutter/material.dart';
import '../style.dart' as style;

class CustCont extends StatefulWidget {
  Function abcd;
  String title;
  String img;
  @override
  CustCont({this.abcd, this.title, this.img});
  _CustContState createState() => _CustContState();
}

class _CustContState extends State<CustCont> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: InkWell(
        onTap: widget.abcd,
        child: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  child: Image.asset(
                    widget.img,
                    //'assets/images/child/1.jpg',
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(14),
                )),
            Positioned(
              left: 1,
              bottom: 1,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                      //style.Style.buttonColor,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                  //color: Colors.transparent,
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  //'Adopt a pet',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
