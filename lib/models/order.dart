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

  Order.showReceived(
      {@required this.id,
      @required this.userid,
      @required this.postid,
      @required this.quantity,
      @required this.tax,
      @required this.net,
      @required this.price,
      @required this.status,
      @required this.address,
      @required this.town,
      @required this.phone,
      @required this.note,
      @required this.date,
      @required this.name,
      @required this.sender});

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

  Order.sentlist(
      {@required this.id,
      @required this.userid,
      @required this.postid,
      @required this.quantity,
      @required this.price,
      @required this.status,
      @required this.date,
      @required this.name,
      @required this.receiver});

  static List<Order> generateOrderReceivedList(List<dynamic> orderslist) {
    // print("orderslist: " + orderslist.toString());
    List<Order> ordersfetched = List<Order>();
    for (var order in orderslist) {
      ordersfetched.add(Order.fromJsonlist(order, true));
    }
    return ordersfetched;
  }

  static List<Order> generateOrderSentList(List<dynamic> orderslist) {
    print("orderslist: " + orderslist.toString());
    List<Order> ordersfetched = List<Order>();
    for (var order in orderslist) {
      ordersfetched.add(Order.fromJsonlist(order, false));
    }
    return ordersfetched;
  }

  factory Order.fromJsonlist(Map<String, dynamic> json, bool received) {
    if (received) {
      return Order.receivedlist(
        id: json['id'],
        postid: json['post_id'],
        userid: json['user_id'],
        price: double.parse(json['net_total_price'].toString()),
        quantity: json['order_quantity'],
        date: json['created_at'],
        status: json['order_status'],
        sender: json['name'],
        name: json['productname'],
      );
    }

    return Order.sentlist(
      id: json['id'],
      postid: json['post_id'],
      userid: json['user_id'],
      price: double.parse(json['net_total_price'].toString()),
      quantity: json['order_quantity'],
      date: json['created_at'],
      status: json['order_status'],
      receiver: json['vendorname'],
      name: json['productname'],
    );
  }

  factory Order.showReceivedFromJson(Map<String, dynamic> json) {
    print("order receieved show json " + json.toString());
    return Order.showReceived(
      id: json['id'],
      postid: json['post_id'],
      userid: json['user_id'],
      price: double.parse(json['productprice'].toString()),
      net: double.parse(json['net_total_price'].toString()),
      note: json['order_note'],
      address: json['address'],
      town: json['town'],
      phone: json['phonenum'],
      tax: 0.0,
      quantity: json['order_quantity'],
      date: json['created_at'],
      status: json['order_status'],
      sender: json['name'],
      name: json['productname'],
    );
  }

  // static String StatustoString(Status status) {
  //   String s;
  //   switch (status) {
  //     case Status.Processing:
  //       s = 'processing';
  //       break;
  //     case Status.Onhold:
  //       s = 'onhold';
  //       break;
  //     case Status.Shipping:
  //       s = 'shipping';
  //       break;
  //     case Status.PendingPayment:
  //       s = 'pending payment';
  //       break;
  //     case Status.Completed:
  //       s = 'completed';
  //       break;
  //     case Status.Delivered:
  //       s = 'delivered';
  //       break;
  //     case Status.Refunded:
  //       s = 'refunded';
  //       break;
  //     case Status.Failed:
  //       s = 'failed';
  //       break;
  //     default:
  //       s = 'processing';
  //   }
  //   return s;
  // }

  // static Status toStatus(String status) {
  //   Status s;
  //   switch (status) {
  //     case 'processing':
  //       s = Status.Processing;
  //       break;
  //     case 'onhold':
  //       s = Status.Onhold;
  //       break;
  //     case 'shipping':
  //       s = Status.Shipping;
  //       break;
  //     case 'pending payment':
  //       s = Status.PendingPayment;
  //       break;
  //     case 'completed':
  //       s = Status.Completed;
  //       break;
  //     case 'delivered':
  //       s = Status.Delivered;
  //       break;
  //     case 'refunded':
  //       s = Status.Refunded;
  //       break;
  //     case 'failed':
  //       s = Status.Failed;
  //       break;
  //     default:
  //       s = Status.Processing;
  //   }
  //   return s;
  // }

  @override
  String toString() =>
      'Order {id: $id, name: $name, price: $price, quantity: $quantity}';
}

enum Status {
  Processing,
  Onhold,
  Shipping,
  PendingPayment,
  Completed,
  Delivered,
  Refunded,
  Failed
}
