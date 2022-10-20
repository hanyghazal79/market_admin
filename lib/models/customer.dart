import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String id, name, email, phone, address, imageUrl;

  Customer(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.address,
        this.imageUrl});

  Customer.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = (snapshot != null && snapshot.get('id') != null)
      ? snapshot.get('id')
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
        imageUrl = (snapshot != null && snapshot.get('imageUrl') != null)
            ? snapshot.get('imageUrl')
            : "";

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "imageUrl": imageUrl
    };
  }
}
