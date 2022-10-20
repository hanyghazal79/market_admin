import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/views/users/profile.dart';

class CustomDrawerHeaderText extends StatelessWidget {
  final String text;

  CustomDrawerHeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return new Text(
        text,
        style: TextStyle(
          color: Colors.white
        ),
    );
  }
}