import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  String id;
  TestScreen({this.id});
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [Text(widget.id), Text('hey')],
        ),
      ),
    );
  }
}
