import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/models/subcategory.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/data_widget_template.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:market_admin/views/childsubcategories/new_child_subcategory.dart';
import 'package:market_admin/views/products/products.dart';
import 'package:provider/provider.dart';

class ChildSubCategories extends StatefulWidget {
  final String category;
  final String subCategory;

  const ChildSubCategories({Key key, this.category, this.subCategory})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ChildSubCategoriesState();
  }
}

class _ChildSubCategoriesState extends State<ChildSubCategories> {
  ViewModel _viewModel;
  List<String> _params = [];
  Stream<QuerySnapshot> _stream;
  String _selectedSubCategoryName;
  String _selectedChildSubCategoryName;
  Stream<QuerySnapshot> _testStream;
  bool _exist = false;
  CollectionReference _cRef;
  Widget _nextRoute;
  List<dynamic> _list = new List();
  SubCategory _subCategory;
  Map<String, dynamic> _map = new Map();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRefs();
  }

  initRefs() async {
    // setState(() {
    //   _subCategory = (Statics.selectedSubCategory ==null) ?
    //   SubCategory.fromDocumentSnapshot(Statics.queryDocumentSnapshot)
    //   : Statics.selectedSubCategory;
    //
    //   _selectedSubCategoryName = _subCategory.name;
    //   if(_subCategory.toMap()['children'] != null){
    //     _list.addAll(_subCategory.toMap()['children']);
    //   }
    // });
    //
    // await Statics.sharedPreferences.then((prefs) {
    //   prefs.setString("subCategoryChildren", json.encode(_list));
    //   prefs.setString('subCategoryDocSnapshot', Statics.queryDocumentSnapshot.id);
    // });
    _params.addAll(['id', 'name', 'imageUrl']);
    Statics.query = Statics.firestore
        .collection(Statics.childSubCategoriesItem)
        .where('subCategory', isEqualTo: widget.subCategory);

    await Statics.sharedPreferences.then((prefs) {
      setState(() {
        _selectedSubCategoryName = prefs.getString('name');

        // _cRef = Statics.firestore
        //     .collection(
        //     '${Statics.categoriesCollection}/'
        //         '${widget.category}/'
        //         '${widget.category}/'
        //         '$_selectedSubCategoryName/'
        //         '$_selectedSubCategoryName');
      });
    });
    // _selectedSubCategoryName = Statics.documentSnapshot['name'];
    // _cRef = Statics.firestore
    //     .collection(
    //     '${Statics.categoriesCollection}/'
    //         '${widget.category}/'
    //         '${widget.category}/'
    //         '$_selectedSubCategoryName/'
    //         '$_selectedSubCategoryName');
    _viewModel = Provider.of<ViewModel>(context, listen: false);
    //
    // await _viewModel.getItems(collectionReference: _cRef); //===| get data stream |===//
    await _viewModel.getItemsByQuery(); //===| get data stream |===//
    //
    setState(() {
      _stream = _viewModel.stream;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.subCategory),//Text('$_selectedSubCategoryName'),
      ),
      body: (_stream == null)
          ? Container()
          : DataWidget(
              params: _params,
              // list: (_subCategory.children == null) ? null : _subCategory.children,
              stream: _stream,
              onTap: onTap,
              nextRoute: _nextRoute,
              onLongPress: () async {},
            ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final _route = NewChildSubCategory(
              category: widget.category,
              subCategory: widget.subCategory,
            );
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => _route));
          }),
    );
  }

  onTap() {
    setNextRoute();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => _nextRoute));
  }

  Future<Widget> setRoute() async {
    Widget _widget;
    //  await Statics.sharedPreferences.then((prefs) {
    //   setState(() {
    //     _selectedGrandCategoryName = prefs.getString('name');
    //     _widget = Products(
    //       category: widget.category,
    //       subCategory: _selectedSubCategoryName,
    //       grandCategory: _selectedGrandCategoryName,
    //     );
    //   });
    // });
    setState(() {
      _selectedChildSubCategoryName = Statics.queryDocumentSnapshot.get('name');
      _widget = Products(
        category: widget.category,
        subCategory: widget.subCategory,
        childSubCategory: _selectedChildSubCategoryName,
      );
    });
    return _widget;
  }

  setNextRoute() {
    setRoute().then((widget) {
      setState(() {
        _nextRoute = widget;
      });
    });
  }

  onLongPressed() async {
    Statics.options = [
      FlatButton(
        child: const Text('Remove', style: TextStyle(fontSize: 16)),
        onPressed: () {
          Statics.firestore
              .collection(Statics.childSubCategoriesItem)
              .doc(Statics.selectedDocumentID)
              .delete()
              .then((_) {
            Statics.displayMessageDialog(
                context: context,
                message: 'Successful deletion of a child sub-category');
          });
          Navigator.pop(context);
        },
      ),
    ];
    Statics.displayActionsDialog(context: context, options: Statics.options);
  }

  Widget getNoDataWidget() {
    return new Center(
        child: Column(children: [
      InkWell(
        child: Row(children: [Icon(Icons.add), Text('Add a child sub-category')]),
        onTap: () {},
      ),
      InkWell(
        child: Row(children: [
          Icon(Icons.add),
          Text('Add a product under this sub-category')
        ]),
        onTap: () {},
      )
    ]));
  }
}
