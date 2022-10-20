import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomProfileImage extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  final String imageUrl;
  final File imageFile;

  const CustomProfileImage(
      {Key key, this.width, this.height, this.radius, this.imageUrl, this.imageFile})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _CustomProfileImageState();
  }
}

class _CustomProfileImageState extends State<CustomProfileImage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      width: widget.width,
      height: widget.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          image: DecorationImage(
            image: getImage(),
            fit: BoxFit.cover,
          )),
    );
  }
   getImage(){
    if(widget.imageUrl == null && widget.imageFile != null){
      return FileImage(widget.imageFile);
    }else if(widget.imageUrl != null && widget.imageFile == null){
      return NetworkImage(widget.imageUrl);
    }else if(widget.imageUrl == null && widget.imageFile ==null){
      return AssetImage('assets/images/profile.png');
    }
  }
}
