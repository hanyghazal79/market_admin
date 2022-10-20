import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/models/category.dart';
import 'package:market_admin/resources/database/firebase.dart';
import 'package:market_admin/resources/enums/ui_events_enum.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/add_subcategory_field.dart';
import 'package:market_admin/viewmodels/category_viewmodel.dart';
import 'package:market_admin/views/categories/categories.dart';
import 'package:provider/provider.dart';

class AddNewCategory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AddNewCategoryState();
  }
}

class _AddNewCategoryState extends State<AddNewCategory> {
  File _imageFile;
  CategoryViewModel _categoryViewModel;
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  TextEditingController _nameController;
  DatabaseHelper _helper;
  var _category;
  double _animatedWidth, _animatedHeight;
  TextEditingController _subCategoryController = new TextEditingController();
List<Widget> _children = [];
Widget _nextRoute;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initReferences();
  }
initReferences(){
  _animatedHeight = 0;
  _animatedWidth = 0;
  _categoryViewModel = Provider.of<CategoryViewModel>(context, listen: false);
  _nameController = new TextEditingController();
  _helper = DatabaseHelper.instance;
  initiateUiEvents(context);

}
  initiateUiEvents(BuildContext context) {
    _categoryViewModel.uiEventController.stream.listen((event) async {
      if (event == UiEvents.loading) {
        Statics.displayProgressDialog(context);
      } else if (event == UiEvents.completed) {
        Statics.closeProgressDialog(context);
        Statics.displayMessageDialog(
            context: context, message: _categoryViewModel.message);
        setState(() {
          _nextRoute = Categories();
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => _nextRoute));
      } else if (event == UiEvents.error) {
        await Statics.displayMessageDialog(
            context: context, message: _categoryViewModel.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: Text('New Category'),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 10, top: 16, right: 10, bottom: 40),
          child: ListView.builder(
              itemCount: getChildren().length,
              itemBuilder: (context, index){
                return ListTile(title: getChildren().elementAt(index),);
              })
        ));
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _viewModel.dispose();
  //   _viewModel.uiEventController.close();
  // }
List<Widget>getChildren(){
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
                        color: Colors.green,
                        width: 1,
                        style: BorderStyle.solid)),
                child: (_categoryViewModel.imageWidget == null)
                    ? Image.asset('assets/images/null_image.jpg')
                    : _categoryViewModel.imageWidget
              // : Image.file(
              //     _imageFile,
              //     fit: BoxFit.cover,
              //   ),
            ),
            IconButton(
                icon: Icon(Icons.add_a_photo),
                padding: EdgeInsets.only(left: 300, top: 170),
                onPressed: () async {
                  await _categoryViewModel.chooseCategoryImage();
                  setState(() {
                    _imageFile = _categoryViewModel.imageFile;
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
            decoration: InputDecoration(hintText: tr('category')),
          ),
        )
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
          '${Statics.categoriesCollection}/${_nameController.value.text}';

      Statics.documentReference = _helper.firestore
          .collection(Statics.categoriesCollection)
          .doc(_nameController.value.text);
    });
  }

  void addTheData() async {
    await _categoryViewModel.uploadCategoryImage(
        image: _categoryViewModel.imageFile, parent: _nameController.value.text);

    _category = new Category(
            id: '${_nameController.value.text}_${DateTime.now().millisecondsSinceEpoch}',
            name: _nameController.value.text,
            imageUrl: _categoryViewModel.imageUrl)
        .toMap();
    await _categoryViewModel.addNewCategory(object: _category);
  }
}
