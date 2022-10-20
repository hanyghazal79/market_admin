import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/data_widget_template.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:market_admin/views/products/add_new_product.dart';
import 'package:market_admin/views/products/product_details.dart';
import 'package:provider/provider.dart';

class Products extends StatefulWidget {
  final String category;
  final String subCategory;
  final String childSubCategory;

  const Products({Key key, this.category, this.subCategory, this.childSubCategory})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ProductsState();
  }
}

class _ProductsState extends State<Products> {
  ViewModel _viewModel;
  List<String> _params = [];
  Stream<QuerySnapshot> _stream;
  String _selectedChildSubCategoryName;
  String _title;
  Widget _route;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRef();
  }

  initRef() async {
    // _selectedChildSubCategoryName =
    //     (Statics.queryDocumentSnapshot == null)
    //         ? null
    //         : Statics.queryDocumentSnapshot.data()['name'];

    // getTitle();
    Statics.collectionReference =
        Statics.firestore.collection(Statics.productsItem);
    _viewModel = Provider.of<ViewModel>(context, listen: false);
    _params.addAll(['id', 'name', 'imageUrls']);
    await _viewModel.getAllItems();
    setState(() {
      _stream = _viewModel.stream;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Products'),
      ),
      body: new Container(
        alignment: Alignment.center,
        child: (_stream == null)
            ? Container()
            : DataWidget(
                stream: _stream,
                params: _params,
                // nextRoute: ProductDetails(
                //   id: Statics.queryDocumentSnapshot[_params.elementAt(0)],
                // ),
                onLongPress: onLongPressed),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {
            setState(() {
              _route = AddNewProduct(
                category: widget.category,
                subCategory: widget.subCategory,
                childSubCategory: _selectedChildSubCategoryName,
              );
            });

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => _route));
          }),
    );
  }

  //=======| The following are the methods |=======//
  getTitle() {
    if (widget.category != null &&
        widget.subCategory == null &&
        _selectedChildSubCategoryName == null) {
      setState(() {
        _title = '${widget.category} products'; //
      });
    } else if (widget.category != null &&
        widget.subCategory != null &&
        _selectedChildSubCategoryName == null) {
      setState(() {
        _title = '${widget.subCategory} products'; //
      });
    } else if (widget.category != null &&
        widget.subCategory != null &&
        _selectedChildSubCategoryName != null) {
      setState(() {
        _title = '$_selectedChildSubCategoryName products'; //
      });
    }
  }

  onLongPressed() {}
}
