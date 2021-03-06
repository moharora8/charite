import 'package:flutter/material.dart';

class OnLaunch extends StatefulWidget {
  @override
  _OnLaunchState createState() => _OnLaunchState();
}

class _OnLaunchState extends State<OnLaunch> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('OnLaunch'),
        ),
        body: Container(color: Colors.red, child: Text('djnd')),
      ),
    );
  }
}
