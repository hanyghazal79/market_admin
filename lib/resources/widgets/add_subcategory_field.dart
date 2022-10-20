import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubCategoryField extends StatefulWidget{
  final double width, height;
  final TextEditingController controller;
  final File imageFile;

  const SubCategoryField({Key key, this.width, this.height, this.controller, this.imageFile}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _SubCategoryFieldState();
  }
  
}
class _SubCategoryFieldState extends State<SubCategoryField>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: widget.width,
        height: widget.height,
      child: Row(
        children: [
          Expanded(
              child: TextField(controller: widget.controller,)),
          Expanded(child: InkWell(
            child: (widget.imageFile == null) ?
            Image.asset('assets/images/null_image.jpg'):
            Image.file(widget.imageFile),
          ))
        ],
      ),
    );
  }
  
}