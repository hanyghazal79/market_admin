import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String id, type, name, email, phone, address, category, imageUrl;

  AppUser(
      {this.id,
      this.type,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.category,
      this.imageUrl});

  AppUser.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = (snapshot != null && snapshot.get('id') != null)
            ? snapshot.get('id')
            : "",
        type = (snapshot != null && snapshot.get('type') != null)
            ? snapshot.get('type')
            : "",
        name = (snapshot != null && snapshot.get('name') != null)
            ? snapshot.get('name')
            : "",
        email = (snapshot != null && snapshot.get('email') != null)
            ? snapshot.get('email')
            : "",
        phone = (snapshot != null && snapshot.get('phone') != null)
            ? snapshot.get('phone')
            : "",
        address = (snapshot != null && snapshot.get('address') != null)
            ? snapshot.get('address')
            : "",
        category = (snapshot != null && snapshot.get('category') != null)
            ? snapshot.get('category')
            : "",
        imageUrl = (snapshot != null && snapshot.get('imageUrl') != null)
            ? snapshot.get('imageUrl')
            : "";

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "category": category,
      "imageUrl": imageUrl
    };
  }
factory AppUser.fromMap(Map<String, dynamic> map){
    return AppUser(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      category: map['category'],
      imageUrl: map['imageUrl']
    );
}
}
