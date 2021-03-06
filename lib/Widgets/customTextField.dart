import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type1;
  final IconData data;
  final String hintText;
  bool isObsecure = true;
  int maxlength;
  CustomTextField(
      {Key key,
      this.type1,
      this.controller,
      this.data,
      this.hintText,
      this.isObsecure,
      this.maxlength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(10),
      child: TextFormField(
        validator: (value) => value.isEmpty ? 'Field can\'t be blank' : null,
        keyboardType: type1,
        maxLength: maxlength != null ? maxlength : null,
        controller: controller,
        obscureText: isObsecure,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              data,
              color: Color(0xFFDA281C),
            ),
            focusColor: Color(0xFFDA281C),
            hintText: hintText),
      ),
    );
  }
}
