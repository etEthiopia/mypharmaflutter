import 'package:flutter/material.dart';

class Cart {
  int id;
  String name;
  int postId;
  String picture;
  int quantity;
  String date;
  double price;
  static double allTotal;
  static int count = 0;

  Cart(
      {@required this.id,
      @required this.name,
      @required this.picture,
      @required this.postId,
      @required this.quantity,
      @required this.date,
      @required this.price});

  static List<Cart> generatecartlistList(List<dynamic> cartlist, double total) {
    List<Cart> cartlistfetched = List<Cart>();
    print('here');
    Cart.allTotal = double.tryParse(total.toString()) ?? 0.0;
    print("Cart All Total: ${Cart.allTotal}");
    Cart.count = cartlist.length;

    for (var cart in cartlist) {
      cartlistfetched.add(Cart(
          id: int.parse(cart['id'].toString()),
          name: cart['post_title'],
          postId: int.parse(cart['post_id'].toString()) ?? 0,
          picture: cart['thumbnail'],
          quantity: int.tryParse(cart['quantity'].toString()) ?? 0,
          date: cart['updated_at'] ?? '-',
          price: double.tryParse(cart['price'].toString()) ?? 0.0));
    }
    print("Cart Fetched : $cartlistfetched");

    return cartlistfetched;
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
        id: int.parse(json['id'].toString()),
        name: json['post_title'],
        postId: int.parse(json['post_id'].toString()),
        picture: json['thumbnail'],
        quantity: int.parse(json['quantity'].toString()) ?? 0,
        date: json['updated_at'] ?? '-',
        price: double.parse(['price'].toString()) ?? 00);
  }

  @override
  String toString() =>
      'Cart {id: $id, name: $name, price: $price, amount: $quantity,  postId: $postId}';
}
