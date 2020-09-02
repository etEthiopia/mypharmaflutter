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
  int price;
  double tax;

  Product({
    @required this.id,
    @required this.title,
    @required this.vendor,
    @required this.price,
    @required this.image,
    this.description,
  });

  Product.detail(
      {@required this.id,
      @required this.userid,
      @required this.title,
      @required this.vendor,
      @required this.date,
      @required this.price,
      @required this.image,
      @required this.description,
      @required this.gallery,
      @required this.batchNo,
      @required this.category,
      @required this.tax});

  factory Product.fromJsonDetial(Map<String, dynamic> json) {
    return Product.detail(
        id: json['id'],
        title: json['title'],
        price: json['min_price'],
        vendor: json['vendorname'],
        image: json['thumbnail'],
        date: json['updated_at'],
        description: json['descriptioin'],
        gallery: null,
        category: json['category_id'],
        batchNo: json['batch_number'],
        tax: double.parse(json['taxt_rate'].toString()),
        userid: json['user_id']);
  }

  static List<String> getGallery(String mainn) {
    List<String> pp;
    if (mainn != null) {
      if (mainn.contains(',')) {
        pp = mainn.split(',');
      } else {
        pp = List<String>();
        pp[0] = mainn;
      }
      return pp;
    }
    return null;
  }

  static List<Product> generateStockList(List<dynamic> productslist) {
    List<Product> productsfetched = List<Product>();

    for (var products in productslist) {
      productsfetched.add(Product(
          id: products['id'],
          price: products['min_price'],
          title: products['title'],
          vendor: null,
          image: products['thumbnail'],
          description: products['descriptioin']));
    }
    return productsfetched;
  }

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
