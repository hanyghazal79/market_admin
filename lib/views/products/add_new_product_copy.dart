// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:market_admin/models/product.dart';
// import 'package:market_admin/models/subcategory.dart';
// import 'package:market_admin/resources/database/firebase.dart';
// import 'package:market_admin/resources/enums/ui_events_enum.dart';
// import 'package:market_admin/resources/values/statics/statics.dart';
// import 'package:market_admin/resources/widgets/add_image_widget.dart';
// import 'package:market_admin/resources/widgets/additive_widget.dart';
// import 'package:market_admin/resources/widgets/custom_textfield.dart';
// import 'package:market_admin/viewmodels/viewmodel_template.dart';
// import 'package:market_admin/views/products/products.dart';
// import 'package:provider/provider.dart';
//
// class AddNewProduct extends StatefulWidget {
//   final String category;
//   final String subCategory;
//   final String childSubCategory;
//
//   const AddNewProduct(
//       {Key key, this.category, this.subCategory, this.childSubCategory})
//       : super(key: key);
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return new _AddNewProductState();
//   }
// }
//
// class _AddNewProductState extends State<AddNewProduct> {
//   ViewModel _productViewModel;
//
//   var _product;
//   TextEditingController _nameController;
//   TextEditingController _priceController;
//   TextEditingController _sellerController;
//   TextEditingController _descriptionController;
//   DatabaseHelper _helper;
//   DocumentReference _docRef;
//   List<String> _imageUrlList = [];
//   String _storagePath;
//   String _categoryName, _subCategoryName, _childSubCategoryName, _directParentClass;
//   String _dropDownValue;
//   List<dynamic> _categories = new List();
//   List<dynamic> _subCategories = new List();
//   CollectionReference _categoriesCollRef, _subCategCollRef, _childSubCatCollRef;
//   Stream<QuerySnapshot> _categStream, _subCategStream, _childSubCatStream;
//   List<dynamic> _children = new List();
//   List<dynamic> _childSubCategories = new List();
//   List<QueryDocumentSnapshot> _subCatDocs = new List();
//   List<QueryDocumentSnapshot> _childSubCatDocs = new List();
//
//   TextEditingController _additiveController = new TextEditingController();
//   Map<String, dynamic> _subCatAndChildren = new Map();
//   List<dynamic> _list = new List();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initRefs();
//     _initiateUiEvents(context);
//   }
//
//   initRefs() async {
//     _productViewModel = Provider.of<ViewModel>(context, listen: false);
//     _nameController = new TextEditingController();
//     _priceController = new TextEditingController();
//     _sellerController = new TextEditingController();
//     _descriptionController = new TextEditingController();
//     _helper = DatabaseHelper.instance;
//      _dropDownValue = 'Select';
//     _subCategCollRef = Statics.firestore.collection(Statics.subCategoriesItem);
//     _childSubCatCollRef = Statics.firestore.collection(Statics.childSubCategoriesItem);
//     _categoryName = widget.category;
//     _subCategoryName = widget.subCategory;
//     _childSubCategoryName = widget.childSubCategory;
//
//     getCategories();
//   }
//   getCategories() async{
//     setState(() {
//       _categoriesCollRef = Statics.firestore.collection(Statics.categoriesItem);
//     });
//     await _productViewModel.getItems(collectionReference: _categoriesCollRef);
//     setState(() {
//       _categStream = _productViewModel.stream;
//     });
//     _categStream.listen((event) {
//       event.docs.forEach((element) {
//         setState(() {
//           _categories.clear();
//           _categories.add(element.data()['name']);
//         });
//       });
//     });
//   }
// getSubCategories()async{
//   await _productViewModel.getItemsByQuery();
//
//   setState(() {
//     _subCategStream = _productViewModel.stream;
//   });
//   _subCategStream.listen((event) {
//     setState(() {
//       _subCatDocs.clear();
//       _subCatDocs.addAll(event.docs);
//       _subCatDocs.forEach((doc) {
//         setState(() {
//           _subCategories.clear();
//           _subCategories.add(doc.data()['name']);
//
//         });
//       });
//
//     });
//   });
// }
// getChildSubCategories() async{
//   await _productViewModel.getItemsByQuery();
//
//   setState(() {
//     _childSubCatStream = _productViewModel.stream;
//   });
//   _childSubCatStream.listen((event) {
//     setState(() {
//       _childSubCatDocs.clear();
//       _childSubCatDocs.addAll(event.docs);
//       _childSubCatDocs.forEach((doc) {
//         setState(() {
//           _childSubCategories.clear();
//           _childSubCategories.add(doc.data()['name']);
//
//         });
//       });
//
//     });
//   });
// }
//   _initiateUiEvents(BuildContext context) {
//     _productViewModel.uiEventController.stream.listen((event) async {
//       if (event == UiEvents.loading) {
//         Statics.displayProgressDialog(context);
//       } else if (event == UiEvents.completed) {
//         Statics.closeProgressDialog(context);
//         Statics.displayMessageDialog(
//             context: context, message: _productViewModel.message);
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => Products(
//                   category: widget.category,
//                   subCategory: widget.subCategory,
//                   childSubCategory: widget.childSubCategory,
//                 )));
//       } else if (event == UiEvents.error) {
//         Statics.closeProgressDialog(context);
//         await Statics.displayMessageDialog(
//             context: context, message: _productViewModel.message);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return new Scaffold(
//         appBar: new AppBar(
//           title: Text('New product'),
//         ),
//         body: new Container(
//           padding: EdgeInsets.all(16.0),
//           child: ListView(
//             children: getChildren(),
//           ),
//         ));
//   }
//
//   void setReferences() {
//     setState(() {
//       // Statics.storagePath
//       _categoryName = (_categoryName == null) ? "" : _categoryName;
//       _subCategoryName = (_subCategoryName == null) ? "" : _subCategoryName;
//       _childSubCategoryName = (_childSubCategoryName == null) ? "" : _childSubCategoryName;
//       _directParentClass = (_directParentClass == null) ? "" : _directParentClass;
//
//       _storagePath = '${Statics.categoriesCollection}/'
//           '${widget.category}/'
//           '${widget.subCategory}/'
//           '${widget.childSubCategory}/'
//           '$_directParentClass/'
//           '${_nameController.value.text}';
//
//       // Statics.documentReference
//       _docRef = _helper.firestore
//           .collection(Statics.productsItem)
//           .doc('${DateTime.now().millisecondsSinceEpoch}');
//     });
//   }
//
//   void addTheData() async {
//     await _productViewModel.uploadImageList(
//         imageList: _productViewModel.imageFileList,
//         parent: _nameController.value.text,
//         storagePath: _storagePath);
//     setState(() {});
//
//     _product = new Product(
//             id: '${_nameController.value.text.toLowerCase().trim()}_${DateTime.now().millisecondsSinceEpoch}',
//             name: _nameController.value.text,
//             price: '${_priceController.value.text} ${Statics.currencySymbol}',
//             category: _categoryName,
//             subCategory: _subCategoryName,
//             childSubCategory: _childSubCategoryName,
//             sellerName: null,
//             imageUrls: _productViewModel.imageUrlList)
//         .toMap();
//     await _productViewModel.addNewObjectByDocRef(
//         documentReference: _docRef, object: _product);
//   }
//
//   List<DropdownMenuItem> getItems(List<dynamic> list) {
//     List<DropdownMenuItem> items = [];
//     list.forEach((element) {
//       setState(() {
//         DropdownMenuItem item = new DropdownMenuItem(child: Text(element));
//         items.add(item);
//       });
//     });
//     return items;
//   }
//
//   List<Widget> getChildren() {
//     List<Widget> list = [
//       AddImageWidget(),
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(padding: EdgeInsets.all(5),child: Text('Category $_dropDownValue', style: TextStyle(color: Colors.blue)),),
//             Container(
//               height: 42,
//               padding: EdgeInsets.only(left: 10),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.blue, width: 1, style: BorderStyle.solid),
//                 borderRadius: BorderRadius.all(Radius.circular(15))
//               ),
//               child: DropdownButton(
//                   isExpanded: true,
//                   items: getItems(_categories),
//                   onChanged: (result) async{
//                     setState(() {
//                       Statics.query = _subCategCollRef.where('category', isEqualTo: result);
//                       getSubCategories();
//                       _categoryName = result;
//                       _dropDownValue = result;
//
//                     });
//
//                   }),
//             ),
//             Container(padding: EdgeInsets.all(5), child: Text('Sub-Category', style: TextStyle(color: Colors.blue)),),
//             Container(
//               height: 42,
//               padding: EdgeInsets.only(left: 10),
//               decoration: BoxDecoration(
//                   border: Border.all(color: Colors.blue, width: 1, style: BorderStyle.solid),
//                   borderRadius: BorderRadius.all(Radius.circular(15))
//               ),
//               child: DropdownButton(
//                 isExpanded: true,
//                 items: getItems(_subCategories),
//                 onChanged: (result) {
//                   setState(() {
//                     Statics.query = _childSubCatCollRef.where('subCategory', isEqualTo: result);
//                     getChildSubCategories();
//                     _subCategoryName = result;
//                   });
//                 }
//             ),),
//             Container(padding: EdgeInsets.all(5), child: Text('Sub-Category child', style: TextStyle(color: Colors.blue),)),
//             Container(
//               height: 42,
//               padding: EdgeInsets.only(left: 10),
//               decoration: BoxDecoration(
//                   border: Border.all(color: Colors.blue, width: 1, style: BorderStyle.solid),
//                   borderRadius: BorderRadius.all(Radius.circular(15))
//               ),
//               child: DropdownButton(
//                 isExpanded: true,
//                   items: getItems(_childSubCategories),
//                 onChanged: (result) {
//                   setState(() {
//                     _childSubCategoryName = result;
//                   });
//                 }
//                 ),),
//
//           ],
//         ),
//       ),
//       Expanded(child: AdditiveWidget(
//         title: 'Add a direct parent class',
//         titleColor: Colors.blue,
//         iconColor: Colors.blue,
//         controller: _additiveController,
//         viewModel: _productViewModel,
//       )),
//       Expanded(
//         child: CustomTextField(
//           controller: _nameController,
//           labelText: tr('product'),
//           labelColor: Colors.blue,
//         ),
//       ),
//       Expanded(
//         child: CustomTextField(
//           controller: _priceController,
//           labelText: tr('price'),
//           labelColor: Colors.blue,
//         ),
//       ),
//       Expanded(
//         child: CustomTextField(
//           controller: _sellerController,
//           labelText: tr('seller'),
//           labelColor: Colors.blue,
//         ),
//       ),
//       Expanded(
//         child: CustomTextField(
//           controller: _descriptionController,
//           labelText: tr('description'),
//           labelColor: Colors.blue,
//         ),
//       ),
//       Expanded(
//           child: Container(
//         margin: EdgeInsets.only(top: 24),
//         width: MediaQuery.of(context).size.width,
//         height: 48,
//         child: RaisedButton(
//             color: Colors.blue,
//             child: Text(
//               'Add',
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             onPressed: () async {
//               setReferences();
//               // Statics.displayMessageDialog(
//               //     context: context,
//               //     message:
//               //    _viewModel.imageFileList.elementAt(0).absolute.path
//               // );
//               addTheData();
//             }),
//       )),
//     ];
//     return list;
//   }
//
//   Widget getWidgetFromList(List<Widget> list) {
//     Widget widget;
//     for (int i = 0; i < list.length; i++) {
//       widget = list.elementAt(i);
//     }
//     return widget;
//   }
//
//   Widget getRow() {
//     Widget row = Statics.productSpecificationsRow(
//         title: CustomTextField(
//           controller: null,
//           labelText: 'title',
//         ),
//         details: CustomTextField(
//           controller: null,
//           labelText: 'details',
//         ),
//         action: IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () {
//               // _viewModel.increaseChildren();
//             }));
//
//     return row;
//   }
//
// }
