import 'package:flutter/material.dart';

class Order {
  int id;
  int userid;
  int postid;
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

  Order.receivedlist(
      {@required this.id,
      @required this.userid,
      @required this.postid,
      @required this.quantity,
      @required this.price,
      @required this.status,
      @required this.date,
      @required this.name,
      @required this.sender});

  static List<Order> generateOrderReceivedList(List<dynamic> orderslist) {
    // print("orderslist: " + orderslist.toString());
    List<Order> ordersfetched = List<Order>();
    for (var order in orderslist) {
      ordersfetched.add(Order.fromJsonreceivedlist(order
          // id: order['id'],
          // postid: order['post_id'],
          // userid: order['user_id'],
          // price: order['net_total_price'],
          // quantity: order['order_quantity'],
          // date: order['updated_at'],
          // status: order['order_processing'],
          // sender: order['name'],
          // name: order['productname'],
          ));
    }
    return ordersfetched;
  }

  factory Order.fromJsonreceivedlist(Map<String, dynamic> json) {
    // print("JSON: " + json.toString());
    return Order.receivedlist(
      id: json['id'],
      postid: json['post_id'],
      userid: json['user_id'],
      price: double.parse(json['net_total_price'].toString()),
      quantity: json['order_quantity'],
      date: json['updated_at'],
      status: json['order_status'],
      sender: json['name'],
      name: json['productname'],
    );
  }

  @override
  String toString() =>
      'Order {id: $id, name: $name, price: $price, quantity: $quantity}';
}
