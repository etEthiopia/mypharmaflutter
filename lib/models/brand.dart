import 'package:flutter/material.dart';
import 'package:mypharma/theme/colors.dart';

class Brand {
  final int id;
  final String name;
  final String description;

  Brand({
    this.id,
    this.name,
    this.description,
  });

  static List<Brand> brands = [];

  static List<DropdownMenuItem<dynamic>> brandDropdowns = [];

  static generateBrandDropdowns() {
    brandDropdowns = [];
    for (Brand cat in brands) {
      brandDropdowns.add(DropdownMenuItem(
        value: cat.id,
        child: Text(
          cat.name,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
        ),
      ));
    }
  }

  static List<Brand> generateBrandsList(List<dynamic> productslist) {
    List<Brand> productsfetched = List<Brand>();

    for (var products in productslist) {
      productsfetched.add(Brand(
        id: products['id'],
        name: products['brand_name'],
        description: products['brand_disc'],
      ));
    }
    return productsfetched;
  }

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: int.parse(json['id'].toString()),
      name: json['brand_name'],
      description: json['brand_disc'],
    );
  }
}
