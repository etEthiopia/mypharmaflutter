import 'package:flutter/material.dart';
import 'package:mypharma/models/models.dart';

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
  bool selected;
  String orderGroup;
  String receiver;
  String sender;
  int groupTotal;
  Vendor vendor;

  Order.showReceived({
    @required this.id,
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
    @required this.orderGroup,
    @required this.name,
    @required this.selected,
    @required this.sender,
    @required this.vendor,
  });

  Order.receivedlist(
      {@required this.id,
      @required this.userid,
      @required this.postid,
      @required this.quantity,
      @required this.price,
      @required this.status,
      @required this.date,
      @required this.orderGroup,
      @required this.name,
      @required this.selected,
      @required this.groupTotal,
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

  static Map<Order, List<Order>> generateOrderReceivedList(
      List<dynamic> orderslist, List<dynamic> mainlist) {
    final Map<Order, List<Order>> sortedOutList = {};
    List<Order> orders = List<Order>();
    List<Order> bigups = List<Order>();
    for (var order in orderslist) {
      orders.add(Order.fromJsonlist(order, true));
    }
    //print("TOTAL_ORDERS: " + orders.toString());
    for (var order in mainlist) {
      bigups.add(Order.titlesFromJson(order, true));
    }
    //print("MAIN_ORDERS: " + bigups.toString());

    for (Order bg in bigups) {
      sortedOutList[bg] = [];
    }

    for (Order or in orders) {
      for (Order main in sortedOutList.keys) {
        if (main.orderGroup == or.orderGroup) {
          main.price += or.price;
          sortedOutList[main].add(or);
        }
      }
    }

    return sortedOutList;
  }

  static List<Order> generateOrderSentList(List<dynamic> orderslist) {
    List<Order> ordersfetched = List<Order>();
    for (var order in orderslist) {
      ordersfetched.add(Order.fromJsonlist(order, false));
    }
    return ordersfetched;
  }

  factory Order.titlesFromJson(Map<String, dynamic> json, bool received) {
    if (received) {
      return Order.receivedlist(
          id: int.parse(json['id'].toString()),
          postid: int.parse(json['post_id'].toString()),
          userid: int.parse(json['user_id'].toString()),
          price: 0,
          orderGroup: json['order_group_id'].toString(),
          quantity: int.parse(json['order_quantity'].toString()),
          groupTotal: int.parse(json['grp_total'].toString()),
          date: json['created_at'],
          status: json['order_status'],
          sender: json['vendorname'],
          name: json['productname'],
          selected: false);
    }
    return Order.sentlist(
      id: int.parse(json['id'].toString()),
      postid: int.parse(json['post_id'].toString()),
      userid: int.parse(json['user_id'].toString()),
      price: double.parse(json['net_total_price'].toString()),
      quantity: int.parse(json['order_quantity'].toString()),
      date: json['created_at'],
      status: json['order_status'],
      receiver: json['vendorname'],
      name: json['productname'],
    );
  }

  factory Order.fromJsonlist(Map<String, dynamic> json, bool received) {
    if (received) {
      return Order.receivedlist(
          id: int.parse(json['id'].toString()),
          postid: int.parse(json['post_id'].toString()),
          userid: int.parse(json['user_id'].toString()),
          price: double.parse(json['net_total_price'].toString()),
          orderGroup: json['order_group_id'].toString(),
          quantity: int.parse(json['order_quantity'].toString()),
          date: json['created_at'],
          status: json['order_status'],
          sender: json['name'],
          groupTotal: 0,
          name: json['productname'],
          selected: false);
    }

    return Order.sentlist(
      id: int.parse(json['id'].toString()),
      postid: int.parse(json['post_id'].toString()),
      userid: int.parse(json['user_id'].toString()),
      price: double.parse(json['net_total_price'].toString()),
      quantity: int.parse(json['order_quantity'].toString()),
      date: json['created_at'],
      status: json['order_status'],
      receiver: json['vendorname'],
      name: json['productname'],
    );
  }

  factory Order.showReceivedFromJson(Map<String, dynamic> json) {
    return Order.showReceived(
        id: int.parse(json['id'].toString()),
        postid: int.parse(json['post_id'].toString()),
        userid: int.parse(json['user_id'].toString()),
        price: double.parse(json['productprice'].toString()),
        net: double.parse(json['net_total_price'].toString()),
        note: json['order_note'],
        address: json['address'],
        town: json['town'],
        phone: json['phonenum'],
        orderGroup: json['order_group_id'].toString(),
        tax: json['tax_total'] != null
            ? double.parse(json['tax_total'].toString())
            : 0.0,
        selected: false,
        quantity: int.parse(json['order_quantity'].toString()),
        date: json['created_at'],
        status: json['order_status'],
        sender: json['vendorname'],
        name: json['productname'],
        vendor: json['proowner']);
  }

  static Map<Order, List<Order>> sortOutReceivedOrders(
      List<Order> orders, List<Order> bigups) {
    Map<Order, List<Order>> sortedOutList;
    for (Order bg in bigups) {
      sortedOutList[bg] = [];
    }

    for (Order or in orders) {
      for (Order main in sortedOutList.keys) {
        if (main.orderGroup == or.orderGroup) {
          main.price += or.price;
          sortedOutList[main].add(or);
        }
      }
    }

    return sortedOutList;
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
