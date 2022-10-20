import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CustomTextField extends StatelessWidget{
  final TextEditingController controller;
  final String hintText;
  final Color labelColor;
  final String labelText;
  final int maxLines;

  const CustomTextField({Key key, this.controller, this.hintText, this.labelColor, this.labelText, this.maxLines}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      child: TextField(
        style: TextStyle(fontSize: 20),
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,

            labelStyle: TextStyle(fontSize: 14.0, color: labelColor), contentPadding: EdgeInsets.zero
        ),
        maxLines: maxLines,
      ),
    );
  }

}