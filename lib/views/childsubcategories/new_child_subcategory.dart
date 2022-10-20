import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/models/childsubcategory.dart';
import 'package:market_admin/resources/database/firebase.dart';
import 'package:market_admin/resources/enums/ui_events_enum.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:market_admin/views/childsubcategories/child_subcategories.dart';
import 'package:provider/provider.dart';

class NewChildSubCategory extends StatefulWidget {
  final String category;
  final String subCategory;
  const NewChildSubCategory({Key key, this.category, this.subCategory})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _NewChildSubCategoryState();
  }
}

class _NewChildSubCategoryState extends State<NewChildSubCategory> {
  ViewModel _viewModel;
  TextEditingController _nameController;
  DatabaseHelper _helper;
  File _imageFile;
  var _childSubCategory;
  String _docId;
  List<dynamic> _children = [];
  String _selectedSubCategoryName;
  Widget _nextRoute;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRef();
  }

  initRef() async {
    _viewModel = Provider.of<ViewModel>(context, listen: false);
    _viewModel.clear();
    _nameController = new TextEditingController();
    _helper = DatabaseHelper.instance;
    await Statics.sharedPreferences.then((prefs) {
      setState(() {
        _selectedSubCategoryName = prefs.getString('name');
      });
    });
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
          _nextRoute = ChildSubCategories(
            category: widget.category,
            subCategory: widget.subCategory,
          );
        });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => _nextRoute));
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
          title: Text(
            '${widget.subCategory}: new child sub-category',
            style: TextStyle(fontSize: 14),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 10, top: 16, right: 10, bottom: 40),
          child: Column(
            children: [
              Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      Container(
                          width: 400,
                          height: 200,
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
              Expanded(
                  flex: 2,
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 24),
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 20),
                          controller: _nameController,
                          decoration:
                              InputDecoration(labelText: 'Child sub-category'),
                        ),
                      ))),
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(top: 24),
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          'Add',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          setReferences(); //// doc refs
                          addTheData(); //// image upload and insertion into firestore
                        }),
                  ))
            ],
          ),
        ));
  }

  void setReferences() async {
    setState(() {
      Statics.storagePath =
          '${Statics.categoriesCollection}/${widget.category}/${widget.subCategory}/${_nameController.value.text}';

      // Statics.documentReference = _helper.firestore
      //     .collection(Statics.childSubCategoriesItem).doc(_nameController.value.text);//<==here
    });
    await Statics.sharedPreferences.then((prefs) {
      setState(() {
        _docId = prefs.getString('subCategoryDocSnapshot');
        Statics.documentReference =
            _helper.firestore.collection(Statics.subCategoriesItem).doc(_docId);
      });
    });
  }

  void addTheData() async {
    await _viewModel.uploadImage(
        image: _viewModel.imageFile,
        parent: _nameController.value.text);
    // //===| Updating subCategory children |===//
    // var _child = {"name": _nameController.value.text, "imageUrl": _childSubCatViewModel.imageUrl};
    // await Statics.sharedPreferences.then((prefs){
    //   setState(() {
    //     List<dynamic> _data = json.decode(prefs.getString("subCategoryChildren"));
    //     _children.addAll(_data);
    //     _children.add(_child);
    //   });
    // });
    // // await Statics.documentReference.update({"children":_children});
    // await _childSubCatViewModel.updateObjectField(field: "children", object: _children);
    setState(() {
      Statics.documentReference = _helper.firestore
          .collection(Statics.childSubCategoriesItem)
          .doc(_nameController.value.text);
    });
    //===| Creating ChildSubCategory object |===//
    _childSubCategory = new ChildSubCategory(
            id: '${_nameController.value.text.trim().toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}',
            name: _nameController.value.text,
            imageUrl: _viewModel.imageUrl,
            category: widget.category,
            subCategory: widget.subCategory)
        .toMap();

    await _viewModel.addNewObject(object: _childSubCategory);
  }
}
