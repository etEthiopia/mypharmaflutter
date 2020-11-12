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
  String genericName;
  String manufacturer;
  String manuDate;
  String expDate;
  int packagePrice;
  int packageCapacity;
  String stockStatus;
  int amountInStock;
  String manufacturerCountry;
  static bool isSearch;

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
      @required this.tax,
      @required this.genericName,
      @required this.manufacturer,
      @required this.manuDate,
      @required this.expDate,
      @required this.packagePrice,
      @required this.packageCapacity,
      @required this.stockStatus,
      @required this.amountInStock,
      @required this.manufacturerCountry});

  factory Product.fromJsonDetial(Map<String, dynamic> json) {
    print("prod: " + json.toString());
    return Product.detail(
      id: json['id'],
      title: json['title'],
      price: json['max_price'],
      vendor: json['vendorname'],
      image: json['thumbnail'],
      date: json['updated_at'],
      description: json['descriptioin'],
      gallery: null,
      category: json['category_id'],
      batchNo: json['batch_number'],
      genericName: json['generic_name'] ?? "-",
      tax: double.parse(json['taxt_rate'].toString()),
      userid: json['user_id'],
      manufacturer: json['manufacturer_company'] ?? "-",
      manuDate: json['manufactured_date'] ?? "-",
      expDate: json['expiry_date'] ?? "-",
      packageCapacity: json['package_price'] ?? 0,
      packagePrice: json['package_price'] ?? 0,
      stockStatus: json['stock_status'] ?? "-",
      amountInStock: json['stock_quantity'] ?? 0,
      manufacturerCountry: json['manufacturer_country'] ?? "-",
    );
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
          price: products['max_price'],
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
          price: products['max_price'],
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
      price: json['max_price'],
      vendor: json['vendorname'],
      image: json['thumbnail'],
    );
  }

  @override
  String toString() =>
      'Product {id: $id, title: $title, price: $price, image: $image}';
}
