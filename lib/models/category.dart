import 'package:flutter/material.dart';
import 'package:mypharma/theme/colors.dart';

class Category {
  final int id;
  final String title;
  final String description;

  Category({
    this.id,
    this.title,
    this.description,
  });

  static List<Category> categories = [];

  static List<DropdownMenuItem<dynamic>> categoryDropdowns = [];

  static generateCategoryDropdowns() {
    categoryDropdowns = [];
    for (Category cat in categories) {
      categoryDropdowns.add(DropdownMenuItem(
        value: cat.id,
        child: Text(
          cat.title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
        ),
      ));
    }
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.parse(json['id'].toString()),
      title: json['title'],
      description: json['descriptioin'],
    );
  }

  static List<Category> generateCateogryList(List<dynamic> productslist) {
    List<Category> catsfetched = List<Category>();

    for (var cat in productslist) {
      catsfetched.add(Category(
        id: cat['id'],
        title: cat['title'],
        description: cat['descriptioin'],
      ));
    }
    return catsfetched;
  }
}
