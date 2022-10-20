import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/resources/database/firebase.dart';
import 'package:market_admin/resources/enums/ui_events_enum.dart';
import 'package:market_admin/resources/values/statics/statics.dart';

class ViewModel extends ChangeNotifier{

  DatabaseHelper helper = DatabaseHelper.instance;
  StreamController<UiEvents> uiEventController = new StreamController<UiEvents>.broadcast();

  String message;
  File imageFile;
  String imageName;
  String imageUrl;
  Widget imageWidget;
  Stream<QuerySnapshot> stream;
  //===| Added during product design |===//
  List<String> imageUrlList = [];
  List<String> imageNameList = [];
  StreamController<List<String>> imageUrlController = new StreamController<List<String>>.broadcast();
  StreamController<List<Widget>> imageWidgetListController = new StreamController<List<Widget>>.broadcast();
  StreamController<Widget> imageWidgetController = new StreamController<Widget>.broadcast();

  Map<String, dynamic> specificationMap; //===| For product specifications |===//
  List<Widget> children = [];
  int childrenLength = 0;
  List<Widget> imageWidgetsList = [];
  List<File> imageFileList = [];
  QueryDocumentSnapshot documentSnapshot;
  String selectedItemProperty;
  CollectionReference collectionReference;
  Map<String, dynamic> categoryMap;
  Map<String, Widget> imageWidgetMap = new Map();
  Map<String, File> imageFileMap = new Map();
  Map<String, dynamic> imageUrlMap = new Map();


  // ViewModel(
  //     this.helper,
  //     this.uiEventController,
  //     this.message,
  //     this.imageFile,
  //     this.imageName,
  //     this.imageUrl,
  //     this.imageWidget,
  //     this.stream);
  clear(){
    this.message = "";
    this.imageWidgetsList = [];
    this.imageUrl = "";
    this.imageWidget = null;
    this.imageWidgetMap = {};
    this.stream = null;
    this.collectionReference = null;
    this.children.clear();
    this.documentSnapshot = null;
    this.imageFile = null;
    this.imageFileList = [];
    this.imageUrlMap = {};
    this.imageFileMap = {};
    this.imageNameList = [];
    this.imageName = "";
    this.selectedItemProperty = "";
    this.categoryMap = {};

  }
  setCategoryMap({String category, String subCategory, String grandCategory}){
    categoryMap = {'category':category, 'subcategory':subCategory, 'grandCategory': grandCategory};
    notifyListeners();
  }
  increaseChildren(){
    childrenLength += 1;
    notifyListeners();
  }
addProductSpecRows({Widget row}){

  for(int i = 0; i < childrenLength; i++){
    children.add(row);
    notifyListeners();
  }
  notifyListeners();

}
  chooseImage() async {
    await Statics.chooseImage().then((value) {
      imageFile = File(value.path);
      notifyListeners();
      imageFileMap.addAll({Statics.imageKey: imageFile});
      notifyListeners();
      imageFileList.add(imageFile);
      notifyListeners();
      imageWidget = Image.file(imageFile, fit: BoxFit.cover,);
      notifyListeners();
      imageWidgetMap.addAll({Statics.imageKey: imageWidget});
      notifyListeners();
      imageWidgetController.add(imageWidget);
      notifyListeners();
      //===
      imageWidgetsList.add(imageWidget);
      notifyListeners();
      // imageWidgetListController.add(imageWidgetsList);
      // notifyListeners();

    });
  }

removeImageAt({int index}){
    imageWidgetsList.removeAt(index);
    notifyListeners();
}
  uploadImage({File image, String parent}) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        uiEventController.add(UiEvents.loading);
        notifyListeners();
        imageName = '${parent.toLowerCase().trim()}_${DateTime.now().millisecondsSinceEpoch}';
        notifyListeners();
        imageUrl = await helper.uploadImageToFireCloud(
            image: image, imageName: imageName, storagePath: Statics.storagePath);
        notifyListeners();
        imageUrlMap.addAll({Statics.imageKey: imageUrl});
        notifyListeners();
        message = "Success";
        notifyListeners();
        //===
        imageUrlList.add(imageUrl);
        notifyListeners();
        imageUrlController.add(imageUrlList);
        notifyListeners();
        //===
        uiEventController.add(UiEvents.completed);
        notifyListeners();
      } catch (error) {
        message = error.toString();
        notifyListeners();
        uiEventController.add(UiEvents.showMessage);
        notifyListeners();
      }
    } else {
      message = tr('no_internet');
      notifyListeners();
      uiEventController.add(UiEvents.showMessage);
      notifyListeners();
    }
  }
  uploadImageByStoragePath({File image, String parent, String storagePath}) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        uiEventController.add(UiEvents.loading);
        notifyListeners();
        imageName = '${parent.toLowerCase().trim()}_${DateTime.now().millisecondsSinceEpoch}';
        notifyListeners();
        imageUrl = await helper.uploadImageToFireCloud(
            image: image, imageName: imageName, storagePath: storagePath);
        notifyListeners();
        message = "Success";
        notifyListeners();
        //===
        imageUrlList.add(imageUrl);
        notifyListeners();
        imageUrlController.add(imageUrlList);
        notifyListeners();
        //===
        uiEventController.add(UiEvents.completed);
        notifyListeners();
      } catch (error) {
        message = error.toString();
        notifyListeners();
        uiEventController.add(UiEvents.showMessage);
        notifyListeners();
      }
    } else {
      message = tr('no_internet');
      notifyListeners();
      uiEventController.add(UiEvents.showMessage);
      notifyListeners();
    }
  }
  uploadImageList({List<File> imageList, String parent, String storagePath}) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        uiEventController.add(UiEvents.loading);
        notifyListeners();

        for(int i = 0; i < imageList.length; i++){
          imageName = '${parent.toLowerCase().trim()}_${DateTime.now().millisecondsSinceEpoch}_$i';
          notifyListeners();
          imageNameList.add(imageName);
          notifyListeners();
        }
        //===
        imageUrlList = await helper.uploadImageList(
            imageList: imageList, imageNames: imageNameList, storagePath: storagePath);
        notifyListeners();
        //===
        // message = "Success";
        // notifyListeners();
        imageUrlController.add(imageUrlList);
        notifyListeners();
        //===
        uiEventController.add(UiEvents.completed);
        notifyListeners();
      } catch (error) {
        message = error.toString();
        notifyListeners();
        uiEventController.add(UiEvents.showMessage);
        notifyListeners();
      }
    } else {
      message = tr('no_internet');
      notifyListeners();
      uiEventController.add(UiEvents.showMessage);
      notifyListeners();
    }
  }
  addNewObject({Object object}) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // try{
      uiEventController.add(UiEvents.loading);
      notifyListeners();

      await helper
          .addObject(
          object: object,
          documentReference: Statics.documentReference)
          .whenComplete(() {
        message = "Completed addition.";
        notifyListeners();
        uiEventController.add(UiEvents.completed);
        notifyListeners();
      }).catchError((error){
        message = error.toString();
        notifyListeners();
        uiEventController.add(UiEvents.error);
        notifyListeners();
      });
    } else {
      message = tr('no_internet');
      uiEventController.add(UiEvents.showMessage);
      notifyListeners();
    }
  }
  addNewObjectByDocRef({DocumentReference documentReference, Object object}) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // try{
      uiEventController.add(UiEvents.loading);
      notifyListeners();

      await helper
          .addObject(
          object: object,
          documentReference: documentReference)
          .whenComplete(() {
        message = "Completed addition.";
        notifyListeners();
        uiEventController.add(UiEvents.completed);
        notifyListeners();
      }).catchError((error){
        message = error.toString();
        notifyListeners();
        uiEventController.add(UiEvents.error);
        notifyListeners();
      });
    } else {
      message = tr('no_internet');
      uiEventController.add(UiEvents.showMessage);
      notifyListeners();
    }
  }
  addNewObjectByCollection({Object object}) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // try{
      uiEventController.add(UiEvents.loading);
      notifyListeners();

      await helper
          .addObjectByCollection(
          object: object,
          collectionReference: Statics.collectionReference)
          .whenComplete(() {
        message = "Completed addition.";
        notifyListeners();
        uiEventController.add(UiEvents.completed);
        notifyListeners();
      }).catchError((error){
        message = error.toString();
        notifyListeners();
        uiEventController.add(UiEvents.error);
        notifyListeners();
      });
    } else {
      message = tr('no_internet');
      uiEventController.add(UiEvents.showMessage);
      notifyListeners();
    }
  }

  getAllItems() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      stream =  helper.getItems(collectionReference: Statics.collectionReference);
      notifyListeners();
    } else {
      message = tr('no_internet');
      notifyListeners();
      uiEventController.add(UiEvents.showMessage);
      notifyListeners();
    }
  }
  getItems({CollectionReference collectionReference}) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      stream =  helper.getItems(collectionReference: collectionReference);
      notifyListeners();
    } else {
      message = tr('no_internet');
      notifyListeners();
      uiEventController.add(UiEvents.showMessage);
      notifyListeners();
    }
  }
  getItemsByQuery() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      stream =  helper.getItemsByQuery(query: Statics.query);
      notifyListeners();
    } else {
      message = tr('no_internet');
      notifyListeners();
      uiEventController.add(UiEvents.showMessage);
      notifyListeners();
    }
  }
  getItemsByDynamicQuery({Query query}) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      stream =  helper.getItemsByQuery(query: query);
      notifyListeners();
    } else {
      message = tr('no_internet');
      notifyListeners();
      uiEventController.add(UiEvents.showMessage);
      notifyListeners();
    }
  }

  updateObject({Object object}) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // try{
      uiEventController.add(UiEvents.loading);
      notifyListeners();

      await helper
          .updateObject(
          object: object,
          documentReference: Statics.documentReference)
          .whenComplete(() {
        message = "Completed update.";
        notifyListeners();
        uiEventController.add(UiEvents.completed);
        notifyListeners();
      }).catchError((error){
        message = error.toString();
        notifyListeners();
        uiEventController.add(UiEvents.error);
        notifyListeners();
      });
    } else {
      message = tr('no_internet');
      uiEventController.add(UiEvents.showMessage);
      notifyListeners();
    }
  }
  updateObjectField({String field, Object object}) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // try{
      uiEventController.add(UiEvents.loading);
      notifyListeners();

      await helper
          .updateObjectField(
        field: field,
          object: object,
          documentReference: Statics.documentReference)
          .whenComplete(() {
        message = "Completed update.";
        notifyListeners();
        uiEventController.add(UiEvents.completed);
        notifyListeners();
      }).catchError((error){
        message = error.toString();
        notifyListeners();
        uiEventController.add(UiEvents.error);
        notifyListeners();
      });
    } else {
      message = tr('no_internet');
      uiEventController.add(UiEvents.showMessage);
      notifyListeners();
    }
  }

  deleteStoredImage({String imageUrl})async{
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      uiEventController.add(UiEvents.loading);
      notifyListeners();
      await Statics.firebaseStorage.getReferenceFromUrl(imageUrl).then((storageRef){
        storageRef.delete();
      });
      uiEventController.add(UiEvents.completed);
      notifyListeners();
    }
  }
deleteItem({DocumentReference documentReference, String imageUrl})async{
  var connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {

    uiEventController.add(UiEvents.loading);
    notifyListeners();

    await Statics.firebaseStorage
        .getReferenceFromUrl(imageUrl)
        .then((storageRef) {
      storageRef.delete();
    });
    await documentReference.delete();
    uiEventController.add(UiEvents.completed);
    notifyListeners();
  } else {
    message = tr('no_internet');
    notifyListeners();
    uiEventController.add(UiEvents.showMessage);
    notifyListeners();
  }
}
getSelectedDocSnapshot({AsyncSnapshot<QuerySnapshot> asyncSnapshot, int index}){
    documentSnapshot = helper.getDocSnapshot(asyncSnapshot, index);
    notifyListeners();
}
getSelectedItemProperty({QueryDocumentSnapshot documentSnapshot, int index}){
    selectedItemProperty = documentSnapshot.data().values.elementAt(index);
    notifyListeners();
}
setCollectionReference({String path}){
    collectionReference = helper.firestore.collection(path);
    notifyListeners();
}
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    uiEventController.close();
    imageUrlController.close();
    imageWidgetListController.close();
    imageWidgetController.close();
  }

}