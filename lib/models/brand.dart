import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Brand{
  String id, name, imageUrl;
  List<dynamic> categories;
  Brand({this.id, this.name, this.imageUrl, this.categories});

  Brand.fromDocumentSnapshot(QueryDocumentSnapshot snapshot):
        id = (snapshot != null && snapshot.get('id') != null) ? snapshot.get('id') : "",
        name = (snapshot != null && snapshot.get('name') != null) ? snapshot.get('name') : "",
        imageUrl = (snapshot != null && snapshot.get('imageUrl') != null) ? snapshot.get('imageUrl') : "",
        categories = (snapshot != null && snapshot.get('categories') != null) ? snapshot.get('categories') : [];


  Brand.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        imageUrl = map['imageUrl'],
        categories = map['categories'];

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "name" : name,
      "imageUrl" : imageUrl,
      "categories": categories
    };
  }
}