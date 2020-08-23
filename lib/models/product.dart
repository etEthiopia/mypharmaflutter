import 'package:flutter/material.dart';

class Product {
  int id;
  int userid;
  int publishStatus;
  int postStatus;
  List<String> gallery;
  String title;
  String description;
  String date;
  String image;
  int category;
  String batchNo;
  String vendor;
  double price;

  Product(
      {@required this.id,
      @required this.title,
      @required this.vendor,
      @required this.price,
      @required this.image});

  static List<Product> generateProductList(List<dynamic> productslist) {
    List<Product> productsfetched = List<Product>();

    for (var products in productslist) {
      productsfetched.add(Product(
          id: products['id'],
          price: products['min_price'],
          title: products['title'],
          vendor: products['vendorname'],
          image: products['thumbnail']));
    }
    return productsfetched;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['min_price'],
      vendor: json['vendorname'],
      image: json['thumbnail'],
    );
  }

  @override
  String toString() =>
      'Product {id: $id, title: $title, price: $price, image: $image}';
}
