import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/resources/database/firebase.dart';
import 'package:market_admin/resources/enums/ui_events_enum.dart';
import 'package:market_admin/resources/values/statics/statics.dart';

class SubCategoryViewModel extends ChangeNotifier {

  DatabaseHelper _helper = DatabaseHelper.instance;
  StreamController<UiEvents> uiEventController = new StreamController<UiEvents>.broadcast();

  String message;
  File imageFile;
  String imageName;
  String imageUrl;
  Widget imageWidget;
  String categoryName;
  Stream<QuerySnapshot> stream;

  chooseSubCategoryImage() async {
    await Statics.chooseImage().then((value) {
      imageFile = File(value.path);
      notifyListeners();
      imageWidget = Image.file(imageFile);
      notifyListeners();
    });
  }

  uploadSubCategoryImage({File image, String parent}) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        uiEventController.add(UiEvents.loading);
        notifyListeners();
        imageName = '${parent.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}';
        notifyListeners();

        imageUrl = await _helper.uploadImageToFireCloud(
            image: image,
            imageName: imageName,
            storagePath: Statics.storagePath);

        notifyListeners();
        message = "Success";
        notifyListeners();
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

  addNewSubCategory({Object object}) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // try{
      uiEventController.add(UiEvents.loading);
      notifyListeners();
      await _helper
          .addObject(
          object: object,
          documentReference: Statics.documentReference)
          .whenComplete(() {
        message = "Completed addition of a new item.";
        notifyListeners();
        uiEventController.add(UiEvents.completed);
        notifyListeners();
      }).catchError((error){
        message = error.toString();
        notifyListeners();
        uiEventController.add(UiEvents.error);
        notifyListeners();
      });

      // if(response == "Success"){
      //
      //   message = response;
      //   notifyListeners();
      //   uiEventController.add(UiEvents.runAnimation);
      //   notifyListeners();
      //
      // }else{
      //
      //   message = response;
      //   uiEventController.add(UiEvents.showMessage);
      //   notifyListeners();
      //
      // }
      // }catch(error){
      //    message = error.toString();
      //    uiEventController.add(UiEvents.showMessage);
      //    notifyListeners();
      // }
    } else {
      message = tr('no_internet');
      uiEventController.add(UiEvents.showMessage);
      notifyListeners();
    }
    ////
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    uiEventController.close();
  }

  getAllSubCategories() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      stream =  _helper.getItems(collectionReference: Statics.collectionReference);
      // stream = _helper.getItemsByCollectionName(query: Statics.query);
      notifyListeners();
    } else {
      message = tr('no_internet');
      notifyListeners();
      uiEventController.add(UiEvents.showMessage);
      notifyListeners();
    }
  }
}
