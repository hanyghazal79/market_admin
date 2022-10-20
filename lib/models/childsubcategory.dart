import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChildSubCategory{
  String id, name, imageUrl, category, subCategory;

  ChildSubCategory({this.id, this.name, this.imageUrl, this.category, this.subCategory});

  ChildSubCategory.fromDocumentSnapshot(QueryDocumentSnapshot snapshot):
        id = (snapshot != null && snapshot.get('id') != null) ? snapshot.get('id') : "",
        name = (snapshot != null && snapshot.get('name') != null) ? snapshot.get('name') : "",
        imageUrl = (snapshot != null && snapshot.get('imageUrl') != null) ? snapshot.get('imageUrl') : "",
        category = (snapshot != null && snapshot.get('category') != null) ? snapshot.get('category') : "",
        subCategory = (snapshot != null && snapshot.get('subCategory') != null) ? snapshot.get('subCategory') : "";


  ChildSubCategory.fromMap(Map<String, dynamic> map)
      : id = (map != null && map['id'] != null) ? map['id'] : "",
        name = (map != null && map['name'] != null) ? map['name'] : "",
        imageUrl = (map != null && map['imageUrl'] != null) ? map['imageUrl'] : "",
      category =
        (map != null && map['category'] != null) ? map['category'] : "",
        subCategory = (map != null && map['subCategory'] != null)
            ? map['subCategory']
            : "";



  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "name" : name,
      "imageUrl" : imageUrl,
      "category": category,
      "subCategory": subCategory
    };
  }
}