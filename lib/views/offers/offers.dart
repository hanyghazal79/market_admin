import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/data_widget_template.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:market_admin/views/offers/add_new_offer.dart';
import 'package:provider/provider.dart';

class Offers extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _OffersState();
  }

}
class _OffersState extends State<Offers>{
  ViewModel _viewModel;
  Stream<QuerySnapshot> _stream;
  List<String> _params = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  initRef() async {
    _params.addAll(['id', 'name', 'email', 'phone', 'address', 'category']);
    _viewModel = Provider.of<ViewModel>(context, listen: false);
    Statics.collectionReference =
        Statics.firestore.collection(Statics.offersCollection);
    await _viewModel.getAllItems();
    setState(() {
      _stream = _viewModel.stream;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text('Offers'),
      ),
      body: (_stream == null)
          ? Container()
          : DataWidget(
        stream: _stream,
        params: _params,
        nextRoute: getNextRoute(),
        onLongPress: onLongPressed,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddNewOffer()));},
      ),
    );
  }
  getNextRoute() {}
  onLongPressed() {}
}
