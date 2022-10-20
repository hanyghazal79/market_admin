import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/data_widget_template.dart';
import 'package:market_admin/viewmodels/category_viewmodel.dart';
import 'package:market_admin/viewmodels/subcategory_viewmodel.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:market_admin/views/brands/add_new_brand.dart';
import 'package:market_admin/views/categories/add_new_category.dart';
import 'package:market_admin/views/products/add_new_product.dart';
import 'package:market_admin/views/products/products.dart';
import 'package:market_admin/views/subcategories/add_new_subcategory.dart';
import 'package:market_admin/views/subcategories/subcategories.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Brands extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _BrandsState();
  }
}

class _BrandsState extends State<Brands> {
  ViewModel _viewModel;
  List<String> _params = [];
  Stream<QuerySnapshot> _stream;
  String _selectedBrandName;
  CollectionReference _cRef;
  Widget _nextRoute;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRefs();
  }

  initRefs() async {
    _cRef = Statics.firestore.collection(Statics.brandsCollection);
    _params.addAll(['id', 'name', 'imageUrl']);
    _viewModel = Provider.of<ViewModel>(context, listen: false);

    await _viewModel.getItems(collectionReference: _cRef);
    setState(() {
      _stream = _viewModel.stream;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text(Statics.brandsCollection),
      ),
      body: new Container(
          alignment: Alignment.center,
          child: (_stream == null )
              ? Container()
              : DataWidget(
              params: _params,
              stream: _stream,
              // onTap: onTap,
              // nextRoute: _nextRoute
          )
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NewBrand()));
          }),
    );
  }
  onTap(){
    setNextRoute();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => _nextRoute));
  }
  Future<Widget> setRoute()  async{
    Widget _widget;
    await Statics.sharedPreferences.then((prefs) {
      setState(() {
        _selectedBrandName = prefs.getString('name');
        _widget = SubCategories(category: _selectedBrandName,);
      });
    });
    return _widget;
  }

  setNextRoute() {
    setRoute().then((widget){
      setState(() {
        _nextRoute = widget;
      });
    });
  }
}
