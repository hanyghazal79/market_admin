import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  String id, type, productId;
  Map<String, dynamic> data;
  DateTime startDate, endDate;

  Offer(
      {this.id,
      this.type,
      this.data,
      this.productId,
      this.startDate,
      this.endDate});

  Offer.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = (snapshot != null && snapshot.get('id') != null)
            ? snapshot.get('id')
            : "",
        type = (snapshot != null && snapshot.get('type') != null)
            ? snapshot.get('type')
            : "",
        data = (snapshot != null && snapshot.get('data') != null)
            ? snapshot.get('data')
            : "",
        productId = (snapshot != null && snapshot.get('productId') != null)
            ? snapshot.get('productId')
            : "",
        startDate = (snapshot != null && snapshot.get('startDate') != null)
            ? snapshot.get('startDate')
            : "",
        endDate = (snapshot != null && snapshot.get('endDate') != null)
            ? snapshot.get('endDate')
            : "";

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "data": data,
      "productId": productId,
      "startDate": startDate,
      "endDate": endDate
    };
  }
}
