import 'package:flutter/material.dart';
import 'package:mypharma/models/models.dart';

class Vendor {
  int id;
  String userid;
  String name;
  String description;
  String icon;
  String banner;
  Address address;
  List<Product> products;

  Vendor(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.userid,
      @required this.icon,
      @required this.banner,
      @required this.address,
      @required this.products});

  factory Vendor.fromJson(Map<String, dynamic> json) {
    //print("VENDOR: $json");
    return Vendor(
        id: json['ven_info']['id'],
        name: json['ven_info']['title'],
        description: json['ven_info']['descriptioin'],
        icon: json['ven_info']['icon'] ?? '-',
        banner: json['ven_info']['banner'] ?? '-',
        userid: json['ven_info']['user_id'].toString(),
        address: Address.fromJsonforVendor(json['addrs']),
        products: Product.generateProductList(json['product']));
  }

  @override
  String toString() =>
      'Vendor {id: $id, title: $name, description: $description, image: $icon, address: $address, products: $products}';
}
