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
  double tax;
  String genericName;
  String manufacturer;
  String manuDate;
  String expDate;
  double packagePrice;
  int packageCapacity;
  String stockStatus;
  int amountInStock;
  int vendorId;
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
      @required this.vendorId,
      @required this.packagePrice,
      @required this.packageCapacity,
      @required this.stockStatus,
      @required this.amountInStock,
      @required this.manufacturerCountry});

  factory Product.fromJsonDetial(Map<String, dynamic> json) {
    print(json);
    return Product.detail(
      id: int.parse(json['id'].toString()),
      title: json['title'],
      price: double.tryParse(json['max_price'].toString()) ?? 0.0,
      vendor: json['vendorname'],
      image: json['thumbnail'],
      date: json['updated_at'],
      description: json['descriptioin'],
      gallery: [],
      category: int.tryParse(json['category_id'].toString()) ?? 0,
      batchNo: json['batch_number'],
      genericName: json['generic_name'] ?? "-",
      tax: 0,
      userid: int.tryParse(json['user_id'].toString()) ?? 0,
      vendorId: int.tryParse(json['vendor_id'].toString()) ?? 0,
      manufacturer: json['manufacturer_company'] ?? "-",
      manuDate: json['manufactured_date'] ?? "-",
      expDate: json['expiry_date'] ?? "-",
      packageCapacity: json['package_capacity'] != null
          ? int.tryParse(json['package_capacity'].toString()) ?? 0
          : 0,
      packagePrice: json['package_price'] != null
          ? double.tryParse(json['package_price'].toString()) ?? 0
          : 0,
      stockStatus: json['stock_status'] ?? "-",
      amountInStock: json['stock_quantity'] != null
          ? int.parse(json['stock_quantity'].toString())
          : 0,
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
          id: int.parse(products['id'].toString()),
          price: double.parse(products['max_price'].toString()),
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
          id: int.parse(products['id'].toString()),
          price: double.tryParse(products['max_price'].toString()) ?? 0.0,
          title: products['title'],
          vendor: products['vendorname'],
          image: products['thumbnail']));
    }
    print("Products Fetched: $productsfetched");
    return productsfetched;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()),
      title: json['title'],
      price: double.parse(json['max_price'].toString()),
      vendor: json['vendorname'],
      image: json['thumbnail'],
    );
  }

  @override
  String toString() =>
      'Product {id: $id, title: $title, price: $price, image: $image}';
}
