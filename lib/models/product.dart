import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id,
      name,
      price,
      description,
      category,
  brand,
      subCategory,
      childSubCategory,
      directParentClass,
      sellerName,
      rate;
  List<String> imageUrls;
  Map<String, dynamic> specifications;

  Product(
      {this.id,
      this.name,
      this.price,
      this.category,
        this.brand,
      this.subCategory,
      this.childSubCategory,
      this.directParentClass,
      this.sellerName,
      this.rate,
      this.imageUrls,
      this.description,
      this.specifications});

  Product.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = (snapshot != null && snapshot.id != null) ? snapshot.id : "",
        name = (snapshot != null && snapshot.get('name') != null)
            ? snapshot.get('name')
            : "",
        price = (snapshot != null && snapshot.get('price') != null)
            ? snapshot.get('price')
            : "",
        category = (snapshot != null && snapshot.get('category') != null)
            ? snapshot.get('category')
            : "",
        brand = (snapshot != null && snapshot.get('brand') != null)
            ? snapshot.get('brand')
            : "",
        subCategory = (snapshot != null && snapshot.get('subCategory') != null)
            ? snapshot.get('subCategory')
            : "",
        childSubCategory =
            (snapshot != null && snapshot.get('childSubCategory') != null)
                ? snapshot.get('childSubCategory')
                : "",
        directParentClass =
            (snapshot != null && snapshot.get('directParentClass') != null)
                ? snapshot.get('directParentClass')
                : "",
        sellerName = (snapshot != null && snapshot.get('sellerName') != null)
            ? snapshot.get('sellerName')
            : "",
        rate = (snapshot != null && snapshot.get('rate') != null)
            ? snapshot.get('rate')
            : "",
        imageUrls = (snapshot != null && snapshot.get('imageUrls') != null)
            ? snapshot.get('imageUrls')
            : "",
        description = (snapshot != null && snapshot.get('description') != null)
            ? snapshot.get('description')
            : "",
        specifications =
            (snapshot != null && snapshot.get('specifications') != null)
                ? snapshot.get('specifications')
                : "";

  Product.fromMap(Map<String, dynamic> map)
      : id = (map != null && map['id'] != null) ? map['id'] : "",
        name = (map != null && map['name'] != null) ? map['name'] : "",
        price = (map != null && map['price'] != null) ? map['price'] : "",
        category =
            (map != null && map['category'] != null) ? map['category'] : "",
        brand =
        (map != null && map['brand'] != null) ? map['brand'] : "",
        subCategory = (map != null && map['subCategory'] != null)
            ? map['subCategory']
            : "",
        childSubCategory = (map != null && map['childSubCategory'] != null)
            ? map['childSubCategory']
            : "",
        directParentClass = (map != null && map['directParentClass'] != null)
            ? map['directParentClass']
            : "",
        sellerName =
            (map != null && map['sellerName'] != null) ? map['sellerName'] : "",
        rate = (map != null && map['rate'] != null) ? map['rate'] : "",
        imageUrls =
            (map != null && map['imageUrls'] != null) ? map['imageUrls'] : "",
        description = (map != null && map['description'] != null)
            ? map['description']
            : "",
        specifications = (map != null && map['specifications'] != null)
            ? map['specifications']
            : "";

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "category": category,
      "brand": brand,
      "subCategory": subCategory,
      "childSubCategory": childSubCategory,
      "directParentClass": directParentClass,
      "sellerName": sellerName,
      "rate": rate,
      "imageUrls": imageUrls,
      "description": description,
      "specifications": specifications
    };
  }
}
