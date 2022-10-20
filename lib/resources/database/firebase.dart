
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class DatabaseHelper {

  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  factory DatabaseHelper(){
    return instance;
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final StorageReference storageRef = FirebaseStorage.instance.ref();

  Future<dynamic>uploadImageToFireCloud({File image, String imageName, String storagePath}) async{
    StorageReference _ref = storageRef
        .child(storagePath)
        .child(imageName);
    StorageUploadTask task = _ref.putFile(image);
    return await (await task.onComplete).ref.getDownloadURL();
  }
  Future<dynamic>uploadImageList({List<File> imageList, List<String> imageNames, String storagePath}) async{
    List<String> imageUrlList = [];
    for(int i = 0; i < imageList.length; i++){
      StorageReference _ref = storageRef
          .child(storagePath)
          .child(imageNames.elementAt(i));
      StorageUploadTask task = _ref.putFile(imageList.elementAt(i));
      String url = await (await task.onComplete).ref.getDownloadURL();
      imageUrlList.add(url.toString());
    }
    return imageUrlList;
  }
  Future<dynamic>updateImageOnFireCloud({File image, String imageName, String storagePath}) async{
    // StorageReference _ref = storageRef
    //     .child(storagePath)
    //     .child(imageName);
    //
    // StorageUploadTask task = _ref.putFile(image);
    // return await (await task.onComplete).ref.getDownloadURL();
  }
   Future<dynamic> addObject({Object object, DocumentReference documentReference})async{
    await documentReference.set(object);
  }

  Future<dynamic> addObjectByCollection({Object object, CollectionReference collectionReference})async{
    await collectionReference.add(object);
  }

  Stream<QuerySnapshot> getItems({CollectionReference collectionReference}) {
    var snapshots =  collectionReference.snapshots();
    return snapshots;
  }
  Stream<QuerySnapshot> getItemsByQuery({Query query}) {
    var snapshots = query.snapshots();
    return snapshots;
  }

  Future<dynamic> updateObject({DocumentReference documentReference, Object object})async{
    await documentReference.update(object);
  }
  Future<dynamic> updateObjectField({DocumentReference documentReference, String field, Object object})async{
    await documentReference.update({field: object});
  }
  QueryDocumentSnapshot getDocSnapshot(AsyncSnapshot<QuerySnapshot> asyncSnapshot, int index){
    QueryDocumentSnapshot documentSnapshot = asyncSnapshot.data.docs.elementAt(index);
    return documentSnapshot;
  }



}