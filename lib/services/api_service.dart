import 'dart:convert';
import 'dart:io';

import 'package:mypharma/exceptions/exceptions.dart';
import 'package:mypharma/models/models.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

abstract class APIServiceSkel {
  Future<User> getCurrentUser();
  Future<User> signIn(String email, String password);
  Future<User> signUp(
      {String name, String email, int profession, String password});
  Future<void> signOut();
  Future<List<dynamic>> fetchNews({int page = 1});
  Future<List<dynamic>> fetchMyProducts();
  Future<List<dynamic>> fetchReceivedOrders();
  Future<List<dynamic>> fetchSentOrders();
}

class APIService extends APIServiceSkel {
  static String token;

  @override
  Future<User> getCurrentUser() async {
    var str = await storage.read(key: "user");
    if (str != null) {
      var long = str.split(",,");

      if (long.length == 6) {
        return User.fromData(str);
      }
    }
    print("str is null");
    return null;
  }

  @override
  Future<User> signIn(String email, String password) async {
    var res = await http
        .post("$SERVER_IP/login",
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(
                <String, String>{"email": email, "password": password}))
        .timeout(Duration(seconds: 20));
    // print("url: $SERVER_IP/login");
    // print("email: $email");
    // print("password: $password");
    // print(json.decode(res.body)['sucess']);
    if (res.statusCode == 200) {
      if (res.body != null) {
        if (json.decode(res.body)['sucess']) {
          await storage.write(
              key: "user", value: User.jsonToString(json.decode(res.body)));
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
              key: "user", value: User.jsonToString(json.decode(res.body)));
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
  Future<List<dynamic>> fetchSentOrders() async {
    String order = "orders";

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
              print(json.decode(res.body)['0']['order']);
              List<Order> orders = Order.generateOrderSentList(
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
}
