import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_drawer_body.dart';
import 'custom_drawer_header.dart';

class CustomScaffoldDrawer extends StatelessWidget{
  final CustomDrawerHeader header;
  final CustomDrawerBody body;

  CustomScaffoldDrawer({this.header, this.body});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SafeArea(
        child: new Container(
      alignment: Alignment.center,
      width: 250,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          header,
          body
        ],
      ),
    ));
  }

}