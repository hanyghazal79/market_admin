import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/models/brand.dart';
import 'package:market_admin/models/category.dart';
import 'package:market_admin/models/childsubcategory.dart';
import 'package:market_admin/models/product.dart';
import 'package:market_admin/models/subcategory.dart';
import 'package:market_admin/models/user.dart';
import 'package:market_admin/resources/database/firebase.dart';
import 'package:market_admin/resources/enums/ui_events_enum.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/add_image_widget.dart';
import 'package:market_admin/resources/widgets/additive_widget.dart';
import 'package:market_admin/resources/widgets/custom_textfield.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:market_admin/views/products/products.dart';
import 'package:provider/provider.dart';

class AddNewProduct extends StatefulWidget {
  final String category;
  final String subCategory;
  final String childSubCategory;

  const AddNewProduct(
      {Key key, this.category, this.subCategory, this.childSubCategory})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AddNewProductState();
  }
}

class _AddNewProductState extends State<AddNewProduct> {
  ViewModel _viewModel;

  var _product;
  TextEditingController _nameController;
  TextEditingController _priceController;
  TextEditingController _sellerController;
  TextEditingController _descriptionController;
  DatabaseHelper _helper;
  DocumentReference _docRef;
  List<String> _imageUrlList = [];
  String _storagePath;
  String _categoryName,
      _subCategoryName,
      _childSubCategoryName,
      _directParentClass,
      _brand,
      _seller;
  String _dropDownValue;
  List<Category> _categories = new List();
  List<SubCategory> _subCategories = new List();
  CollectionReference _categoriesCollRef, _subCategCollRef, _childSubCatCollRef;
  Stream<QuerySnapshot> _categStream,
      _subCategStream,
      _childSubCatStream,
      _brandStream,
      _sellerStream;
  List<ChildSubCategory> _childSubCategories = new List();
  List<QueryDocumentSnapshot> _subCatDocs = new List();
  List<QueryDocumentSnapshot> _childSubCatDocs = new List();
  TextEditingController _additiveController = new TextEditingController();
  Map<String, dynamic> _subCatAndChildren = new Map();
  List<dynamic> _list = new List();
  Query _query;
  List<Brand> _brands = new List();
  List<AppUser> _sellers = new List();
  Widget _nextRoute;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRefs();
    _initiateUiEvents(context);
  }

  initRefs() async {
    _viewModel = Provider.of<ViewModel>(context, listen: false);
    _viewModel.clear();
    _nameController = new TextEditingController();
    _priceController = new TextEditingController();
    _sellerController = new TextEditingController();
    _descriptionController = new TextEditingController();
    _helper = DatabaseHelper.instance;
    // _dropDownValue = 'Select';

    _subCategCollRef = Statics.firestore.collection(Statics.subCategoriesItem);
    _childSubCatCollRef =
        Statics.firestore.collection(Statics.childSubCategoriesItem);
    _categoryName = widget.category;
    _subCategoryName = widget.subCategory;
    _childSubCategoryName = widget.childSubCategory;

    getCategories();
    getBrands();
    getSellers();
  }

  getCategories() async {
    setState(() {
      _categStream = null;
      _categories.clear();
      _categoriesCollRef = Statics.firestore.collection(Statics.categoriesItem);
    });
    await _viewModel.getItems(collectionReference: _categoriesCollRef);
    setState(() {
      _categStream = _viewModel.stream;
    });
    _categStream.listen((event) {
      event.docs.forEach((element) {
        setState(() {
          _categories.add(Category.fromMap(element.data()));
        });
      });
    });
  }

  getBrands() async {
    CollectionReference _cRef;
    setState(() {
      _brandStream = null;
      _brands.clear();
       _cRef =
          Statics.firestore.collection(Statics.brandsCollection);
    });
    await _viewModel.getItems(collectionReference: _cRef);
    setState(() {
      _brandStream = _viewModel.stream;
    });
    _brandStream.listen((event) {
      event.docs.forEach((element) {
        setState(() {
          _brands.add(Brand.fromMap(element.data()));
        });
      });
    });
  }

  getSubCategories(Query query) async {

    await _viewModel.getItemsByDynamicQuery(query: query);

    setState(() {
      _subCategories.clear();
      _subCategStream = _viewModel.stream;
    });
    _subCategStream.listen((event) {
      setState(() {
        _subCatDocs.clear();
        _subCatDocs.addAll(event.docs);
        _subCatDocs.forEach((doc) {
          setState(() {
            _subCategories.add(SubCategory.fromMap(doc.data()));
          });
        });
      });
    });
  }

  Future<List<ChildSubCategory>> getChildSubCategories(Query query) async {
    await _viewModel.getItemsByDynamicQuery(query: query);

    setState(() {
      _childSubCategories.clear();
      _childSubCatStream = _viewModel.stream;
    });
    _childSubCatStream.listen((event) {
      setState(() {
        _childSubCatDocs.clear();
        _childSubCatDocs.addAll(event.docs);
        _childSubCatDocs.forEach((doc) {
          setState(() {
            _childSubCategories.add(ChildSubCategory.fromMap(doc.data()));
          });
        });
      });
    });
    return _childSubCategories;
  }

  getSellers() async {
    ViewModel _viewModel = Provider.of<ViewModel>(context, listen: false);
    setState(() {
      _sellerStream = null;
      _sellers.clear();
      Statics.collectionReference = Statics.firestore
          .collection(Statics.usersCollection)
          .doc(Statics.userTypes['Sellers']['plural'])
          .collection(Statics.userTypes['Sellers']['plural']);
    });
    await _viewModel.getAllItems();
    setState(() {
      _sellerStream = _viewModel.stream;
    });
    _sellerStream.listen((event) {
      event.docs.forEach((element) {
        setState(() {
          _sellers.add(AppUser.fromMap(element.data()));
        });
      });
    });
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
          _nextRoute = Products(
            category: widget.category,
            subCategory: widget.subCategory,
            childSubCategory: widget.childSubCategory,
          );
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => _nextRoute));
      } else if (event == UiEvents.error) {
        Statics.closeProgressDialog(context);
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
          title: Text('New product'),
        ),
        body: new Container(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: getChildren(),
          ),
        ));
  }

  void setReferences() {
    setState(() {
      // Statics.storagePath
      // _categoryName = (_categoryName == null) ? "" : _categoryName;
      // _subCategoryName = (_subCategoryName == null) ? "" : _subCategoryName;
      // _childSubCategoryName =
      //     (_childSubCategoryName == null) ? "" : _childSubCategoryName;
      _directParentClass =
          (_directParentClass == null) ? "" : _directParentClass;

      _storagePath = '${Statics.categoriesCollection}/'
          '$_categoryName/'
          '$_subCategoryName/'
          '$_childSubCategoryName/'
          '$_directParentClass/'
          '${_nameController.value.text}';

      // Statics.documentReference
      _docRef = _helper.firestore
          .collection(Statics.productsItem)
          .doc('${DateTime.now().millisecondsSinceEpoch}');
    });
  }

  void addTheData() async {
    await _viewModel.uploadImageList(
        imageList: _viewModel.imageFileList,
        parent: _nameController.value.text,
        storagePath: _storagePath);
    setState(() {});

    _product = new Product(
            id: '${_nameController.value.text.toLowerCase().trim()}_${DateTime.now().millisecondsSinceEpoch}',
            name: _nameController.value.text,
            price: '${_priceController.value.text} ${Statics.currencySymbol}',
            category: _categoryName,
            brand: _brand,
            subCategory: _subCategoryName,
            childSubCategory: _childSubCategoryName,
            directParentClass: _directParentClass,
            sellerName: _seller,
            description: _descriptionController.value.text,
            imageUrls: _viewModel.imageUrlList)
        .toMap();
    await _viewModel.addNewObjectByDocRef(
        documentReference: _docRef, object: _product);
  }

  List<DropdownMenuItem> getItems(List<dynamic> list) {
    List<DropdownMenuItem> items = [];
    list.forEach((element) {
      setState(() {
        DropdownMenuItem item = new DropdownMenuItem(child: Text(element));
        items.add(item);
      });
    });
    return items;
  }

  List<Widget> getChildren() {
    List<Widget> list = [
      AddImageWidget(),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownSearch<Brand>(
              mode: Mode.MENU,
              label: 'Brand',
              items: _brands,
              itemAsString: (brand) => brand.name,
              onChanged: (Brand brand) {
                setState(() {
                  _brand = brand.name;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            DropdownSearch<Category>(
                mode: Mode.MENU,
                label: 'Category',
                // showSelectedItem: true,
                items: _categories,
                itemAsString: (category) => category.name,
                onChanged: (Category category) {
                  setState(() {
                    _categoryName = category.name;
                    _query = Statics.firestore
                        .collection(Statics.subCategoriesItem)
                        .where('category', isEqualTo: _categoryName);
                  });
                  Statics.displayMessageDialog(context: context, message: _categoryName);
                  getSubCategories(_query);
                }),
            SizedBox(
              height: 10,
            ),
            Visibility(
                visible: (_subCategories.length > 0) ? true : false,
                child: DropdownSearch<SubCategory>(
                  mode: Mode.MENU,
                  label: 'Sub-category',
                  items: _subCategories,
                  itemAsString: (subCategory) => subCategory.name,
                  onChanged: (SubCategory subCategory) {
                    setState(() {
                      _subCategoryName = subCategory.name;
                      _query = Statics.firestore
                          .collection(Statics.childSubCategoriesItem)
                          .where('subCategory', isEqualTo: _subCategoryName);
                    });
                    Statics.displayMessageDialog(context: context, message: _subCategoryName);
                    getChildSubCategories(_query);
                  },
                )),
            SizedBox(
              height: 10,
            ),
            Visibility(
                visible: (_childSubCategories.length > 0) ? true : false,
                child: DropdownSearch<ChildSubCategory>(
                  mode: Mode.MENU,
                  label: 'Child sub-category',
                  items: _childSubCategories,
                  itemAsString: (childSubCategory) => childSubCategory.name,
                  onChanged: (ChildSubCategory childSubCategory) {
                    setState(() {
                      _childSubCategoryName = childSubCategory.name;
                    });
                    Statics.displayMessageDialog(context: context, message: _childSubCategoryName);
                  },
                ))
          ],
        ),
      ),
      Expanded(
          child: AdditiveWidget(
        title: 'Add a direct parent class',
        titleColor: Colors.blue,
        iconColor: Colors.blue,
        controller: _additiveController,
        viewModel: _viewModel,
      )),
      Expanded(
        child: CustomTextField(
          controller: _nameController,
          labelText: tr('product'),
          labelColor: Colors.blue,
        ),
      ),
      Expanded(
        child: CustomTextField(
          controller: _priceController,
          labelText: tr('price'),
          labelColor: Colors.blue,
        ),
      ),
      Expanded(
          child: DropdownSearch<AppUser>(
        mode: Mode.MENU,
        label: 'Seller',
        items: _sellers,
        itemAsString: (appUser) => appUser.name,
        onChanged: (AppUser appUser) {
          setState(() {
            _seller = appUser.name;
          });
        },
      )
          // CustomTextField(
          //   controller: _sellerController,
          //   labelText: tr('seller'),
          //   labelColor: Colors.blue,
          // ),
          ),
      Expanded(
        child: CustomTextField(
          controller: _descriptionController,
          labelText: tr('description'),
          labelColor: Colors.blue,
        ),
      ),
      Expanded(
          child: Container(
        margin: EdgeInsets.only(top: 24),
        width: MediaQuery.of(context).size.width,
        height: 48,
        child: RaisedButton(
            color: Colors.blue,
            child: Text(
              'Add',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              setReferences();
              addTheData();
              // Statics.displayMessageDialog(context: context, message: '$_categoryName\n$_subCategoryName\n$_childSubCategoryName');
            }),
      )),
    ];
    return list;
  }

  Widget getWidgetFromList(List<Widget> list) {
    Widget widget;
    for (int i = 0; i < list.length; i++) {
      widget = list.elementAt(i);
    }
    return widget;
  }

  Widget getRow() {
    Widget row = Statics.productSpecificationsRow(
        title: CustomTextField(
          controller: null,
          labelText: 'title',
        ),
        details: CustomTextField(
          controller: null,
          labelText: 'details',
        ),
        action: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // _viewModel.increaseChildren();
            }));

    return row;
  }
}
