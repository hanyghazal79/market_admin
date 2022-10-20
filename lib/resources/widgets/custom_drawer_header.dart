import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:market_admin/resources/widgets/custom_drawer_header_text.dart';
import 'package:market_admin/views/users/profile.dart';

class CustomDrawerHeader extends StatefulWidget{
  final Widget imageWidget;
  final CustomDrawerHeaderText textWidget;

  CustomDrawerHeader({this.imageWidget, this.textWidget});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _CustomDrawerHeaderState();
  }

}

class _CustomDrawerHeaderState extends State<CustomDrawerHeader>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new InkWell(
      child: Container(
        alignment: Alignment.center,
        color: Colors.blue,
        padding: EdgeInsets.all(10.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.imageWidget,
            widget.textWidget
          ],
        ),
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile()));
      },
    );
  }

}