import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget{
  final String id;

  const ProductDetails({Key key, this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ProductDetailsState();
  }

}
class _ProductDetailsState extends State<ProductDetails>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold();
  }

}