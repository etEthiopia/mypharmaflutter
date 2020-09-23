import 'dart:convert';
import 'dart:io';

import 'package:mypharma/exceptions/exceptions.dart';
import 'package:mypharma/exceptions/wishlist_excepton.dart';
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
  Future<List<dynamic>> fetchWishlist();
  Future<bool> addtoWishList();
  Future<int> countWishList();
  Future<bool> deleteWish(int id);
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
    return null;
  }

  @override
  Future<User> signIn(String email, String password, bool remember) async {
    try {
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
    } catch (e) {
      if (e is SocketException) {
        if (e.toString().contains("Network is unreachable")) {
          print('Internet Error');
          throw AuthException(message: "Check Your Connection");
        } else if (e.toString().contains("Connection refused")) {
          print('Error from Server');
          throw AuthException(message: "Sorry, We couldn't reach the server");
        } else {
          print('Connection Error');
          throw AuthException(
              message: "Sorry, Something is wrong with the connection");
        }
      } else {
        print('Connection Error');
        throw AuthException(
            message: "Sorry, Something is wrong with the connection");
      }
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
    try {
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
    } catch (e) {
      if (e is SocketException) {
        if (e.toString().contains("Network is unreachable")) {
          print('Internet Error');
          throw AuthException(message: "Check Your Connection");
        } else if (e.toString().contains("Connection refused")) {
          print('Error from Server');
          throw AuthException(message: "Sorry, We couldn't reach the server");
        } else {
          print('Connection Error');
          throw AuthException(
              message: "Sorry, Something is wrong with the connection");
        }
      } else {
        print('Connection Error');
        throw AuthException(
            message: "Sorry, Something is wrong with the connection");
      }
    }
  }

  @override
  Future<List<dynamic>> fetchNews({int page = 1}) async {
    String news = "news";
    if (page != 1) {
      news += "?page=$page";
    }

    try {
      var res = await http.get(
        "$SERVER_IP/$news",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
            if (json.decode(res.body)['message'].toString().contains('oken')) {
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
    } catch (e) {
      if (e is SocketException) {
        if (e.toString().contains("Network is unreachable")) {
          print('Internet Error');
          throw NewsException(message: "Check Your Connection");
        } else if (e.toString().contains("Connection refused")) {
          print('Error from Server');
          throw NewsException(message: "Sorry, We couldn't reach the server");
        } else {
          print('Connection Error');
          throw NewsException(
              message: "Sorry, Something is wrong with the connection");
        }
      } else {
        print('Connection Error');
        throw NewsException(
            message: "Sorry, Something is wrong with the connection");
      }
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
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw ProductException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw ProductException(
                message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw ProductException(
                message: "Sorry, Something is wrong with the connection");
          }
        } else {
          print('Connection Error');
          throw ProductException(
              message: "Sorry, Something is wrong with the connection");
        }
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
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw ProductException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw ProductException(
                message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw ProductException(
                message: "Sorry, Something is wrong with the connection");
          }
        } else {
          print('Connection Error');
          throw ProductException(
              message: "Sorry, Something is wrong with the connection");
        }
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
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw ProductException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw ProductException(
                message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw ProductException(
                message: "Sorry, Something is wrong with the connection");
          }
        } else {
          print('Connection Error');
          throw ProductException(
              message: "Sorry, Something is wrong with the connection");
        }
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
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw OrderException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw OrderException(
                message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw OrderException(
                message: "Sorry, Something is wrong with the connection");
          }
        } else {
          print('Connection Error');
          throw OrderException(
              message: "Sorry, Something is wrong with the connection");
        }
      }
    } else {
      throw OrderException(message: 'Not Authorized');
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
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw OrderException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw OrderException(
                message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw OrderException(
                message: "Sorry, Something is wrong with the connection");
          }
        } else {
          print('Connection Error');
          throw OrderException(
              message: "Sorry, Something is wrong with the connection");
        }
      }
    } else {
      throw OrderException(message: 'Not Authorized');
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
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw OrderException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw OrderException(
                message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw OrderException(
                message: "Sorry, Something is wrong with the connection");
          }
        } else {
          print('Connection Error');
          throw OrderException(
              message: "Sorry, Something is wrong with the connection");
        }
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
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw OrderException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw OrderException(
                message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw OrderException(
                message: "Sorry, Something is wrong with the connection");
          }
        } else {
          print('Connection Error');
          throw OrderException(
              message: "Sorry, Something is wrong with the connection");
        }
      }
    } else {
      throw OrderException(message: 'Not Authorized');
    }
  }

  @override
  Future<List<dynamic>> fetchWishlist() async {
    String wishlist = "wishlist";

    if (APIService.token != null) {
      try {
        var res = await http.get(
          "$SERVER_IP/$wishlist",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        );
        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              List<Wishlist> wishlist = Wishlist.generateWishlistList(
                  json.decode(res.body)['0']['wishlist']);

              List<dynamic> result = wishlist;
              return result;
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw WishlistException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw WishlistException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw WishlistException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw WishlistException(message: 'Wrong Connection');
        }
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw WishlistException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw WishlistException(
                message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw WishlistException(
                message: "Sorry, Something is wrong with the connection");
          }
        } else {
          print('Connection Error');
          throw WishlistException(
              message: "Sorry, Something is wrong with the connection");
        }
      }
    } else {
      throw WishlistException(message: 'Not Authorized');
    }
  }

  @override
  Future<bool> addtoWishList(
      {int postid,
      String slug,
      String name,
      int vendorId,
      int quantity}) async {
    String wishlist = "wishlist";
    if (APIService.token != null) {
      try {
        var res = await http
            .post("$SERVER_IP/$wishlist",
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer ${APIService.token}'
                },
                body: jsonEncode(<String, dynamic>{
                  "post_id": postid,
                  "vendor_id": vendorId,
                  "quantity": 1,
                  "name": name,
                  "slug": "Buy $name another time."
                }))
            .timeout(Duration(seconds: 20));

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
                throw WishlistException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw WishlistException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw WishlistException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw WishlistException(message: 'Wrong Connection');
        }
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw WishlistException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw WishlistException(
                message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw WishlistException(
                message: "Sorry, Something is wrong with the connection");
          }
        } else {
          print('Connection Error');
          throw WishlistException(
              message: "Sorry, Something is wrong with the connection");
        }
      }
    } else {
      throw WishlistException(message: 'Not Authorized');
    }
  }

  @override
  Future<int> countWishList() async {
    String wishlist = "wishlist/count";
    if (APIService.token != null) {
      try {
        var res = await http.get(
          "$SERVER_IP/$wishlist",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        ).timeout(Duration(seconds: 20));
        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              return json.decode(res.body)['count']['wishlist'];
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw WishlistException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw WishlistException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw WishlistException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw WishlistException(message: 'Wrong Connection');
        }
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw WishlistException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw WishlistException(
                message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw WishlistException(
                message: "Sorry, Something is wrong with the connection");
          }
        } else {
          print('Connection Error');
          throw WishlistException(
              message: "Sorry, Something is wrong with the connection $e");
        }
      }
    } else {
      throw WishlistException(message: 'Not Authorized');
    }
  }

  @override
  Future<bool> deleteWish(int id) async {
    String wishlist = "wishlist";
    if (APIService.token != null) {
      try {
        var res = await http.delete(
          "$SERVER_IP/$wishlist/$id",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        ).timeout(Duration(seconds: 10));
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
                throw WishlistException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw WishlistException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw WishlistException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw WishlistException(message: 'Wrong Connection');
        }
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw WishlistException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw WishlistException(
                message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw WishlistException(
                message: "Sorry, Something is wrong with the connection");
          }
        } else {
          print('Connection Error');
          throw WishlistException(
              message: "Sorry, Something is wrong with the connection $e");
        }
      }
    } else {
      throw WishlistException(message: 'Not Authorized');
    }
  }
}
