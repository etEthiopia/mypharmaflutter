import 'package:flutter/material.dart';

class Cart {
  int id;
  String name;
  int postId;

  int quantity;
  String date;
  double price;
  static double allTotal;
  static int count = 0;

  Cart(
      {@required this.id,
      @required this.name,
      @required this.postId,
      @required this.quantity,
      @required this.date,
      @required this.price});

  static List<Cart> generatecartlistList(List<dynamic> cartlist, int total) {
    List<Cart> cartlistfetched = List<Cart>();

    Cart.allTotal = double.parse(total.toString());
    Cart.count = cartlist.length;

    for (var cart in cartlist) {
      cartlistfetched.add(Cart(
          id: cart['id'],
          name: cart['post_title'],
          postId: cart['post_id'],
          quantity: cart['quantity'] ?? 0,
          date: cart['updated_at'] ?? '-',
          price: double.parse(cart['price'].toString()) ?? 0.0));
    }
    return cartlistfetched;
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
        id: json['id'],
        name: json['post_title'],
        postId: json['post_id'],
        quantity: json['quantity'] ?? 0,
        date: json['updated_at'] ?? '-',
        price: double.parse(['price'].toString()) ?? 00);
  }

  @override
  String toString() =>
      'Cart {id: $id, name: $name, price: $price, amount: $quantity,  postId: $postId}';
}
