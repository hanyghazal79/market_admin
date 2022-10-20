import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/data_widget_template.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:market_admin/views/childsubcategories/new_child_subcategory.dart';
import 'package:market_admin/views/childsubcategories/child_subcategories.dart';
import 'package:market_admin/views/products/add_new_product.dart';
import 'package:market_admin/views/subcategories/add_new_subcategory.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubCategories extends StatefulWidget {
  final String category;
  const SubCategories({Key key, this.category}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _SubCategoriesState();
  }
}

class _SubCategoriesState extends State<SubCategories> {
  ViewModel _viewModel;
  List<String> _params = [];
  Stream<QuerySnapshot> _stream;
  bool _isLongPressed;
  CollectionReference _grandCategoriesRef;
  String _selectedCategoryName;
  String _selectedSubCategoryName;
  Stream<QuerySnapshot> _testStream;
  SharedPreferences _sharedPrefs;
  bool _hasChildren;
  CollectionReference _cRef;
  Widget _nextRoute;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRef();
  }

  initRef() async {
    _params.addAll(['id', 'name', 'imageUrl']);

    // await Statics.sharedPreferences.then((prefs) {
    //   setState(() {
    //     _selectedCategoryName = prefs.getString('name');
    //   });
    // });
    _selectedCategoryName = Statics.queryDocumentSnapshot['name'];
    _isLongPressed = false;
    _viewModel = Provider.of<ViewModel>(context, listen: false);
    Statics.query = Statics.firestore
        .collection(Statics.subCategoriesItem)
        .where('category', isEqualTo: _selectedCategoryName);

    await _viewModel.getItemsByQuery(); //===| get data stream |===//
    setState(() {
      _stream = _viewModel.stream;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text(_selectedCategoryName),
      ),
      body: new Container(
          alignment: Alignment.center,
          child: (_stream == null)
              ? Container()
              : DataWidget(
                  params: _params,
                  stream: _stream,
                  onTap: onTap,
                  nextRoute: _nextRoute,
                  onLongPress: onLongPressed)),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNewSubCategory(
                      category: _selectedCategoryName,
                    )));
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
    //     _selectedSubCategoryName = prefs.getString('name');
    //     _widget = GrandCategories(
    //         category: _selectedCategoryName,
    //         subCategory: _selectedSubCategoryName);
    //   });
    // });
    setState(() {
      _selectedSubCategoryName = Statics.queryDocumentSnapshot.get('name');
      _widget = ChildSubCategories(
          category: _selectedCategoryName,
          subCategory: _selectedSubCategoryName);
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
    await Statics.sharedPreferences.then((prefs) {
      setState(() {
        _selectedSubCategoryName = prefs.getString('name');
      });
    });

    Statics.options = [
      FlatButton(
        child: const Text(
          'Add a new child sub-category',
          style: TextStyle(fontSize: 16),
        ),
        onPressed: () {
          final _route = NewChildSubCategory(
              category: _selectedCategoryName,
              subCategory: _selectedSubCategoryName);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => _route));
          Navigator.pop(context);
        },
      ),
      FlatButton(
        child: const Text('Remove', style: TextStyle(fontSize: 16)),
        onPressed: () {
          Statics.firestore
              .collection(Statics.categoriesCollection)
              .doc(_selectedCategoryName)
              .collection(_selectedCategoryName)
              .doc(Statics.selectedDocumentID)
              .delete()
              .then((_) {
            Statics.displayMessageDialog(
                context: context,
                message: 'Successful deletion of a subcategory');
          });
          Navigator.pop(context);
        },
      ),
    ];
    Statics.displayActionsDialog(context: context, options: Statics.options);
  }

  Widget getTemporaryWidget() {
    return new Container(
      child: Center(
        child: Column(
          children: [
            InkWell(
              child: Row(
                children: [
                  Icon(Icons.add),
                  FlatButton(
                      child: Text('Add a grand-category'),
                      onPressed: () {
                        final _route = AddNewSubCategory(
                          category: _selectedCategoryName,
                        );
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => _route));
                      })
                ],
              ),
            ),
            InkWell(
              child: Row(
                children: [
                  Icon(Icons.add),
                  FlatButton(
                      child: Text('Add a product'),
                      onPressed: () {
                        final _route = AddNewProduct(
                          category: _selectedCategoryName,
                        );
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => _route));
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
