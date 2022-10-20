import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/models/childsubcategory.dart';
import 'package:market_admin/models/subcategory.dart';
import 'package:market_admin/resources/database/firebase.dart';
import 'package:market_admin/resources/enums/ui_events_enum.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/additive_widget.dart';
import 'package:market_admin/viewmodels/subcategory_viewmodel.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:market_admin/views/subcategories/subcategories.dart';
import 'package:provider/provider.dart';

class AddNewSubCategory extends StatefulWidget {
  final String category;

  const AddNewSubCategory({Key key, this.category}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AddNewSubCategoryState();
  }
}

class _AddNewSubCategoryState extends State<AddNewSubCategory> {
  File _imageFile;
  ViewModel _viewModel;
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController  _additiveController = new TextEditingController();
  var _subCategory;
  String _childStoragePath;
  List<Widget> _additiveWidgets = [];
  DatabaseHelper _helper;
  double _animatedHeight = 0.0;
  Map<String, dynamic> _childDataMap = new Map();
  List<dynamic> _children = new List();
  Widget _nextRoute;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel = Provider.of<ViewModel>(context, listen: false);
    _viewModel.clear();
    _helper = DatabaseHelper.instance;
    _initiateUiEvents(context);
  }

  _initiateUiEvents(BuildContext context) {
    _viewModel.uiEventController.stream.listen((event) async {
      if (event == UiEvents.loading) {
        Statics.displayProgressDialog(context);
      } else if (event == UiEvents.completed) {
        Statics.closeProgressDialog(context);
        Statics.displayMessageDialog(
            context: context, message: _viewModel.message);
        setState(() {
          _nextRoute =  SubCategories(category: widget.category);
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
           _nextRoute
        ));
      } else if (event == UiEvents.error) {
        await Statics.displayMessageDialog(
            context: context, message: _viewModel.message);

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: Text('${widget.category}: new sub-category', style: TextStyle(fontSize: 14),),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 5, top: 16, right: 5, bottom: 16),
          child: ListView.builder(
            itemCount: getWidgets().length,
              itemBuilder: (context, index){
              return ListTile(title: getWidgets().elementAt(index),);
              })
        ));
  }

List<Widget> getWidgets(){
    return [
      Expanded(
          flex: 3,
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
                  child: (_viewModel.imageWidgetMap['subCategory'] == null)
                      ? Image.asset('assets/images/null_image.jpg')
                      : _viewModel.imageWidgetMap['subCategory']
                // : Image.file(
                //     _imageFile,
                //     fit: BoxFit.cover,
                //   ),
              ),
              IconButton(
                  icon: Icon(Icons.add_a_photo),
                  padding: EdgeInsets.only(left: 300, top: 170),
                  onPressed: () async {
                    Statics.imageKey = "subCategory";
                    await _viewModel.chooseImage();
                    setState(() {
                      // _imageFile = _viewModel.imageFile;
                    });
                  })
            ],
          )),

      Expanded(
          flex: 2,
          child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 24),
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 16),
                  controller: _nameController,
                  decoration: InputDecoration(hintText: tr('subCategory')),
                ),
              ))),
      Expanded(
        flex: 1,
          child: AdditiveWidget(
            title: 'Child subcategory',
            controller: _additiveController,
            viewModel: _viewModel,
          )
      ),
      Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(top: 24),
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(padding: EdgeInsets.all(12),
                color: Colors.blue,
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                 
                  setReferences(); //// doc refs
                  addTheData(); //// image upload and insertion into firestore

                }),
          )),
      // ListView.builder(
      //     itemCount: _additiveWidgets.length,
      //     itemBuilder: (context, index){
      //       return ListTile(title: _additiveWidgets.elementAt(index),);
      //     })
    ];
}

  void setReferences() {
    setState(() {

      Statics.storagePath =
      '${Statics.categoriesCollection}/${widget.category}/${_nameController.value.text}';
      _childStoragePath = '${Statics.storagePath}/${_additiveController.value.text}';
      Statics.documentReference = _helper.firestore
          .collection(Statics.subCategoriesItem)
          .doc(_nameController.value.text);

    });

  }

  void addTheData() async{
    if(_additiveController.value.text != "" && _additiveController.value.text != null){
      addChildSubCategory();
    }
    addSubCategory();
  }
  void addChildSubCategory()async{
    setState(() {
      Statics.imageKey = "childSubCategory";
    });
    await _viewModel.uploadImageByStoragePath(
        image: _viewModel.imageFileMap['childSubCategory'],
        parent: _additiveController.value.text,
        storagePath: _childStoragePath
    );
    setState(() {
      _childDataMap.addAll(
          {
            "name": _additiveController.value.text,
            "imageUrl": _viewModel.imageUrl,
            "category": widget.category,
            "subCategory": _nameController.value.text
          });
      // _children.add(_childDataMap); // to be used if required
    });
  }
  void addSubCategory()async{
    setState(() {
      Statics.imageKey = "subCategory";
    });
    await _viewModel.uploadImage(
        image: _viewModel.imageFileMap['subCategory'],
        parent: _nameController.value.text);
    //===| Creating subCategory object |===//
    _subCategory = new SubCategory(
        id: '${_nameController.value.text.toLowerCase().trim()}_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.value.text,
        category: widget.category,
        imageUrl: _viewModel.imageUrl,
        children: null
    ).toMap();

    await _viewModel.addNewObject(
        object: _subCategory);

    setState(() {
      Statics.documentReference = _helper.firestore
          .collection(Statics.childSubCategoriesItem)
          .doc(_additiveController.value.text);
    });
    await _viewModel.addNewObject(object: _childDataMap);
  }
}
