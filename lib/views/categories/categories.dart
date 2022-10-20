import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/data_widget_template.dart';
import 'package:market_admin/viewmodels/category_viewmodel.dart';
import 'package:market_admin/viewmodels/subcategory_viewmodel.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:market_admin/views/categories/add_new_category.dart';
import 'package:market_admin/views/products/add_new_product.dart';
import 'package:market_admin/views/products/products.dart';
import 'package:market_admin/views/subcategories/add_new_subcategory.dart';
import 'package:market_admin/views/subcategories/subcategories.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Categories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _CategoriesState();
  }
}

class _CategoriesState extends State<Categories> {
  ViewModel _viewModel;
  List<String> _params = [];
  Stream<QuerySnapshot> _stream;
  String _selectedCategoryName;
  CollectionReference _cRef;
  Widget _nextRoute;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRefs();
  }

  initRefs() async {
    _cRef = Statics.firestore.collection(Statics.categoriesCollection);
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
        title: Text(Statics.categoriesItem),
      ),
      body: new Container(
          alignment: Alignment.center,
          child: (_stream == null )
              ? Container()
              : DataWidget(
                  params: _params, stream: _stream, onTap: onTap, nextRoute: _nextRoute)),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddNewCategory()));
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
        _selectedCategoryName = prefs.getString('name');
        _widget = SubCategories(category: _selectedCategoryName,);
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
