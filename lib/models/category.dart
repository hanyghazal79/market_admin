import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String id, name, imageUrl;

  Category({this.id, this.name, this.imageUrl});

  Category.createFrom(String name, String imageUrl);

  Category.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      imageUrl = map['imageUrl'];



  Category.fromDocumentSnapshot(QueryDocumentSnapshot snapshot)
      : id = (snapshot != null && snapshot.get('id') != null) ? snapshot.get('id') : "",
        name = (snapshot != null && snapshot.get('name') != null)
            ? snapshot.get('name')
            : "",
        imageUrl = (snapshot != null && snapshot.get('imageUrl') != null)
            ? snapshot.get('imageUrl')
            : "";

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'imageUrl': imageUrl};
  }
}
