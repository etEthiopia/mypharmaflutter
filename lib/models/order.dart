import 'package:flutter/material.dart';

class Order {
  int id;
  int userid;
  int postd;
  int quantity;
  double tax;
  double net;
  double price;
  String status;
  String date;
  String address;
  String town;
  String phone;
  String note;
  String name;
  String receiver;
  String sender;

  Order.receviedlist(
      {@required this.id,
      @required this.userid,
      @required this.postd,
      @required this.quantity,
      @required this.price,
      @required this.status,
      @required this.date,
      @required this.name,
      @required this.sender});

  static List<Order> generateOrderList(List<dynamic> orderslist) {
    List<Order> ordersfetched = List<Order>();

    for (var order in orderslist) {
      ordersfetched.add(Order.receviedlist(
        id: order['id'],
        postd: order['post_id'],
        userid: order['user_id'],
        price: order['net_total_price'],
        quantity: order['order_quantity'],
        date: order['updated_at'],
        status: order['order_processing'],
        sender: order['name'],
        name: order['productname'],
      ));
    }
    return ordersfetched;
  }

  factory Order.fromJsonreceivedlist(Map<String, dynamic> json) {
    return Order.receviedlist(
      id: json['id'],
      postd: json['post_id'],
      userid: json['user_id'],
      price: json['net_total_price'],
      quantity: json['json_quantity'],
      date: json['updated_at'],
      status: json['json_processing'],
      sender: json['name'],
      name: json['productname'],
    );
  }

  @override
  String toString() =>
      'Order {id: $id, name: $name, price: $price, quantity: $quantity}';
}
