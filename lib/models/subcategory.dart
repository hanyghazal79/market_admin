import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategory{
  String id, name, imageUrl, category;
  List<dynamic> children;
  SubCategory({this.id, this.name, this.imageUrl, this.category, this.children});

  SubCategory.fromDocumentSnapshot(QueryDocumentSnapshot snapshot):
      id = (snapshot != null && snapshot.get('id') != null) ? snapshot.get('id') : "",
      name = (snapshot != null && snapshot.get('name') != null) ? snapshot.get('name') : "",
      imageUrl = (snapshot != null && snapshot.get('imageUrl') != null) ? snapshot.get('imageUrl') : "",
      category = (snapshot != null && snapshot.get('category') != null) ? snapshot.get('category') : "",
        children = (snapshot != null && snapshot.get('children') != null) ? snapshot.get('children') : {};
  SubCategory.fromMap(Map<String, dynamic> map)
  :     id = map['id'],
        name = map['name'],
        imageUrl = map['imageUrl'],
        category = map['category'],
        children = map['children'];

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "name" : name,
      "imageUrl" : imageUrl,
      "category": category,
      "children": children
    };
  }
}