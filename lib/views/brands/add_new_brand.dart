import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/models/brand.dart';
import 'package:market_admin/models/category.dart';
import 'package:market_admin/resources/database/firebase.dart';
import 'package:market_admin/resources/enums/ui_events_enum.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/add_subcategory_field.dart';
import 'package:market_admin/viewmodels/category_viewmodel.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:market_admin/views/brands/brands.dart';
import 'package:market_admin/views/categories/categories.dart';
import 'package:provider/provider.dart';

class NewBrand extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _NewBrandState();
  }
}

class _NewBrandState extends State<NewBrand> {
  File _imageFile;
  ViewModel _viewModel;
  TextEditingController _nameController;
  DatabaseHelper _helper;
  var _brand;
  String _categoryName;
  List<dynamic> _brandCategories = new List();
  CollectionReference _categoriesRef;
  List<Category> _categories = new List();
  Stream<QuerySnapshot> _stream;
  Widget _nextRoute;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initReferences();
  }

  initReferences() {
    _viewModel = Provider.of<ViewModel>(context, listen: false);
    _viewModel.clear();
    _nameController = new TextEditingController();
    _helper = DatabaseHelper.instance;
    initiateUiEvents(context);
    getCategories();
  }

  initiateUiEvents(BuildContext context) {
    _viewModel.uiEventController.stream.listen((event) async {
      if (event == UiEvents.loading) {
        Statics.displayProgressDialog(context);
      } else if (event == UiEvents.completed) {
        Statics.closeProgressDialog(context);
        Statics.displayMessageDialog(
            context: context, message: _viewModel.message);
        setState(() {
          _nextRoute = Brands();
        });
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => _nextRoute));
      } else if (event == UiEvents.error) {
        await Statics.displayMessageDialog(
            context: context, message: _viewModel.message);
      }
    });
  }

  getCategories() async {
    setState(() {
      _categories.clear();
      _categoriesRef = _helper.firestore.collection(Statics.categoriesItem);
    });
    await _viewModel.getItems(collectionReference: _categoriesRef);
    setState(() {
      _stream = _viewModel.stream;
    });
    _stream.listen((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _categories.add(Category.fromMap(doc.data()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: Text('New Brand'),
        ),
        body: Container(
            padding: EdgeInsets.only(left: 10, top: 16, right: 10, bottom: 40),
            child: ListView.builder(
                itemCount: getChildren().length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: getChildren().elementAt(index),
                  );
                })));
  }

  List<Widget> getChildren() {
    return [
      Expanded(
          // flex: 3,
          child: Stack(
        children: [
          Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.green, width: 1, style: BorderStyle.solid)),
              child: (_viewModel.imageWidget == null)
                  ? Image.asset('assets/images/null_image.jpg')
                  : _viewModel.imageWidget
              // : Image.file(
              //     _imageFile,
              //     fit: BoxFit.cover,
              //   ),
              ),
          IconButton(
              icon: Icon(Icons.add_a_photo),
              padding: EdgeInsets.only(left: 300, top: 170),
              onPressed: () async {
                await _viewModel.chooseImage();
                setState(() {
                  _imageFile = _viewModel.imageFile;
                });
              })
        ],
      )),
      Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 24),
          padding: EdgeInsets.only(top: 16),
          child: Expanded(
            child: TextField(
              style: TextStyle(fontSize: 20),
              controller: _nameController,
              decoration: InputDecoration(hintText: tr('brand')),
            ),
          )),
      DropdownSearch<Category>(
        mode: Mode.MENU,
        label: 'Brand',
        items: _categories,
        itemAsString: (category) => category.name,
        onChanged: (category) {
          setState(() {
            _categoryName = category.name;
            _brandCategories.clear();
            _brandCategories.add(_categoryName);
          });
        },
      ),
      Container(
        margin: EdgeInsets.only(top: 24),
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: RaisedButton(
            color: Colors.blue,
            child: Text(
              'Add',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              setReferences();
              addTheData();
            }),
      )
    ];
  }

  void setReferences() {
    setState(() {
      Statics.storagePath =
          '${Statics.brandsCollection}/${_nameController.value.text}';

      Statics.documentReference = _helper.firestore
          .collection(Statics.brandsCollection)
          .doc(_nameController.value.text);
    });
  }

  void addTheData() async {
    await _viewModel.uploadImage(
        image: _viewModel.imageFile, parent: _nameController.value.text);

    _brand = new Brand(
            id: '${_nameController.value.text}_${DateTime.now().millisecondsSinceEpoch}',
            name: _nameController.value.text,
            imageUrl: _viewModel.imageUrl,
            categories: _brandCategories)
        .toMap();
    await _viewModel.addNewObject(object: _brand);
  }
}
