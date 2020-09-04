import 'dart:convert';
import 'dart:io';

import 'package:mypharma/exceptions/exceptions.dart';
import 'package:mypharma/models/models.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

abstract class APIServiceSkel {
  Future<User> getCurrentUser();
  Future<User> signIn(String email, String password, bool remember);
  Future<User> signUp(
      {String name, String email, int profession, String password});
  Future<void> signOut();
  Future<List<dynamic>> fetchNews({int page = 1});
  Future<List<dynamic>> fetchMyProducts();
  Future<List<dynamic>> fetchReceivedOrders();
  Future<List<dynamic>> fetchSentOrders();
  Future<dynamic> fetchShowReceivedOrder();
  Future<bool> updateOrderStatus();
}

class APIService extends APIServiceSkel {
  static String token;
  static int id;

  @override
  Future<User> getCurrentUser() async {
    var str = await storage.read(key: "user");
    if (str != null) {
      var long = str.split(",,");

      if (long.length == 7) {
        if (long[0] == 't') {
          return User.fromData(str);
        }
      }
    }
    print("str is null");
    return null;
  }

  @override
  Future<User> signIn(String email, String password, bool remember) async {
    var res = await http
        .post("$SERVER_IP/login",
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(
                <String, String>{"email": email, "password": password}))
        .timeout(Duration(seconds: 20));
    if (res.statusCode == 200) {
      if (res.body != null) {
        if (json.decode(res.body)['sucess']) {
          await storage.write(
              key: "user",
              value: User.jsonToString(json.decode(res.body), remember));
          return User.fromJson(json.decode(res.body));
        } else {
          print('Wrong Email or Password');
          throw AuthException(message: 'Wrong Email or Password');
        }
      } else {
        print('Wrong credntials');
        throw AuthException(message: 'Wrong credntials');
      }
    } else {
      print('Connection Error');
      throw AuthException(message: 'Connection Error');
    }
  }

  @override
  Future<void> signOut() async {
    await storage.delete(key: "user");
    return null;
  }

  @override
  Future<User> signUp(
      {String name, String email, int profession, String password}) async {
    var res = await http
        .post("$SERVER_IP/register",
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "email": email,
              "password": password,
              "name": name,
              "profession": profession,
              "role": 5
            }))
        .timeout(Duration(seconds: 20));

    print("url: $SERVER_IP/register");
    print("email: $email");
    print("password: $password");
    print("name: $name");
    print("profession: $profession");
    print(json.decode(res.body)['sucess']);
    if (res.statusCode == 200) {
      if (res.body != null) {
        if (json.decode(res.body)['sucess']) {
          await storage.write(
              key: "user",
              value: User.jsonToString(json.decode(res.body), false));
          return User.fromJson(json.decode(res.body));
        } else {
          throw AuthException(message: 'Registeration Unsuccessful');
        }
      } else {
        throw AuthException(message: 'Registration Failed');
      }
    } else {
      print('Connection Error');
      throw AuthException(message: 'Connection Error');
    }
  }

  @override
  Future<List<dynamic>> fetchNews({int page = 1}) async {
    String news = "news";
    if (page != 1) {
      news += "?page=$page";
    }
    if (APIService.token != null) {
      try {
        var res = await http.get(
          "$SERVER_IP/$news",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        ).timeout(Duration(seconds: 20));

        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              int from = json.decode(res.body)['0']['news']['current_page'];
              int last = json.decode(res.body)['0']['news']['last_page'];
              if (from > last) {
                print("End of Feed");
                List<dynamic> result = [from, last];
                return result;
              } else {
                List<News> news = News.generateNewsList(
                    json.decode(res.body)['0']['news']['data']);

                List<dynamic> result = [from, last, news];
                return result;
              }
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw NewsException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw NewsException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw NewsException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw NewsException(message: 'Wrong Connection');
        }
      } on SocketException {
        print('Internet Error');
        throw NewsException(message: "Check Your Connection");
      }
    } else {
      throw NewsException(message: 'Not Authorized');
    }
  }

  @override
  Future<List<dynamic>> fetchMyProducts() async {
    String product = "products";

    if (APIService.token != null) {
      try {
        var res = await http.get(
          "$SERVER_IP/$product",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        ).timeout(Duration(seconds: 20));
        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              List<Product> products = Product.generateProductList(
                  json.decode(res.body)['0']['product']);

              return products;
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw ProductException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw ProductException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw ProductException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw ProductException(message: 'Wrong Connection');
        }
      } on SocketException {
        print('Internet Error');
        throw ProductException(message: "Check Your Connection");
      }
    } else {
      throw ProductException(message: 'Not Authorized');
    }
  }

  @override
  Future<List<dynamic>> fetchMyStock() async {
    String product = "stock";

    if (APIService.token != null) {
      try {
        var res = await http.get(
          "$SERVER_IP/$product/${APIService.id}",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        ).timeout(Duration(seconds: 20));
        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              List<Product> products = Product.generateStockList(
                  json.decode(res.body)['0']['product']);

              return products;
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw ProductException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw ProductException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw ProductException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw ProductException(message: 'Wrong Connection');
        }
      } on SocketException {
        print('Internet Error');
        throw ProductException(message: "Check Your Connection");
      }
    } else {
      throw ProductException(message: 'Not Authorized');
    }
  }

  @override
  Future<dynamic> showProduct({int id}) async {
    String product = "prodetail/$id";
    if (APIService.token != null) {
      try {
        var res = await http.get(
          "$SERVER_IP/$product",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        ).timeout(Duration(seconds: 20));
        print("JSON red code:  " + res.statusCode.toString());
        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              Product product =
                  Product.fromJsonDetial(json.decode(res.body)['0'][0]);
              print("product: " + product.toString());
              return product;
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw ProductException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw ProductException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw ProductException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw ProductException(message: 'Wrong Connection');
        }
      } on SocketException {
        print('Internet Error');
        throw ProductException(message: "Check Your Connection");
      }
    } else {
      throw ProductException(message: 'Not Authorized');
    }
  }

  @override
  Future<List<dynamic>> fetchReceivedOrders() async {
    String order = "customer-order";

    if (APIService.token != null) {
      try {
        var res = await http.get(
          "$SERVER_IP/$order",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        ).timeout(Duration(seconds: 20));
        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              List<Order> orders = Order.generateOrderReceivedList(
                  json.decode(res.body)['0']['order']);

              return orders;
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw ProductException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw ProductException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw ProductException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw ProductException(message: 'Wrong Connection');
        }
      } on SocketException {
        print('Internet Error');
        throw ProductException(message: "Check Your Connection");
      }
    } else {
      throw ProductException(message: 'Not Authorized');
    }
  }

  @override
  Future<List<dynamic>> fetchSentOrders({int page = 1}) async {
    String order = "orders";
    if (page != 1) {
      order += "?page=$page";
    }
    if (APIService.token != null) {
      try {
        var res = await http.get(
          "$SERVER_IP/$order",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        ).timeout(Duration(seconds: 20));
        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              int from = json.decode(res.body)['0']['order']['current_page'];
              int last = json.decode(res.body)['0']['order']['last_page'];
              if (from > last) {
                print("End of Order");
                List<dynamic> result = [from, last];
                return result;
              } else {
                if (json.decode(res.body)['0']['order']['data'].toString() ==
                    "[]") {
                  throw OrderException(message: "empty");
                }
                List<Order> orders = Order.generateOrderSentList(
                    json.decode(res.body)['0']['order']['data']);

                List<dynamic> result = [from, last, orders];
                return result;
              }
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw OrderException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw OrderException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw OrderException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw OrderException(message: 'Wrong Connection');
        }
      } on SocketException {
        print('Internet Error');
        throw OrderException(message: "Check Your Connection");
      }
    } else {
      throw ProductException(message: 'Not Authorized');
    }
  }

  @override
  Future<dynamic> fetchShowReceivedOrder({int postid, int id}) async {
    String order = "order-detail/$postid/order-id/$id";

    if (APIService.token != null) {
      try {
        var res = await http.get(
          "$SERVER_IP/$order",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        ).timeout(Duration(seconds: 20));

        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              Order order = Order.showReceivedFromJson(
                  json.decode(res.body)['0']['order']);

              return order;
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw OrderException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw OrderException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw OrderException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw OrderException(message: 'Wrong Connection');
        }
      } on SocketException {
        print('Internet Error');
        throw OrderException(message: "Check Your Connection");
      }
    } else {
      throw OrderException(message: 'Not Authorized');
    }
  }

  @override
  Future<bool> updateOrderStatus({int id, String status}) async {
    String order = "update-order-status/$id";

    if (APIService.token != null) {
      try {
        var res = await http
            .post("$SERVER_IP/$order",
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer ${APIService.token}'
                },
                body: jsonEncode(<String, String>{"order_status": status}))
            .timeout(Duration(seconds: 20));
        print("RS: $SERVER_IP/$order");

        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              return true;
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw OrderException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw OrderException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw OrderException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw OrderException(message: 'Wrong Connection');
        }
      } on SocketException {
        print('Internet Error');
        throw OrderException(message: "Check Your Connection");
      }
    } else {
      throw OrderException(message: 'Not Authorized');
    }
  }
}
