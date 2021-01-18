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
  Future<List<dynamic>> fetchMyStock();
  Future<List<dynamic>> fetchWishlist();
  Future<bool> addtoWishList();
  Future<int> countWishList();
  Future<bool> deleteWish(int id);
  Future<dynamic> showProduct({int id});
  Future<List<dynamic>> fetchCart();
  Future<int> countCartItems();
  Future<bool> addToCart({int postid});
  Future<bool> deleteCartItem(int id);
  Future<bool> updateCartItem(int id, bool increase);
  Future<Address> toCheckOut();
  Future<bool> order();
  Future<List<dynamic>> searchProducts(String text);
  Future<List<dynamic>> searchProductsByCat(int id);
  Future<List<dynamic>> fetchCategories();
  Future<List<dynamic>> fetchMedsInfo();
  Future<dynamic> showMedInfo({int id});
  Future<Datta> showDashboard();
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
              message: "Sorry, We couldn't get a response from our server");
        }
      } else if (e is AuthException) {
        throw AuthException(message: e.message);
      } else {
        print('Connection Error');
        throw AuthException(
            message: "Sorry, We couldn't get a response from our server");
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
              message: "Sorry, We couldn't get a response from our server");
        }
      } else {
        print('Connection Error');
        throw AuthException(
            message: "Sorry, We couldn't get a response from our server");
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
      print(e.toString());
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
              message: "Sorry, We couldn't get a response from our server");
        }
      } else {
        print('Connection Error');
        throw NewsException(
            message: "Sorry, We couldn't get a response from our server");
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
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw ProductException(message: 'Not Authorized');
        } else if (e is ProductException) {
          throw ProductException(message: e.message);
        } else {
          print('Connection Error');
          throw ProductException(
              message: "Sorry, We couldn't get a response from our server");
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
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw ProductException(message: 'Not Authorized');
        } else if (e is ProductException) {
          throw ProductException(message: e.message);
        } else {
          print('Connection Error');
          throw ProductException(
              message: "Sorry, We couldn't get a response from our server");
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
        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              Product product =
                  Product.fromJsonDetial(json.decode(res.body)['0']);
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
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw ProductException(message: 'Not Authorized');
        } else if (e is ProductException) {
          throw ProductException(message: e.message);
        } else {
          print('Connection Error ' + e.toString());
          throw ProductException(
              message: "Sorry, We couldn't get a response from our server");
        }
      }
    } else {
      throw ProductException(message: 'Not Authorized');
    }
  }

  @override
  Future<List<dynamic>> fetchReceivedOrders({int page = 1}) async {
    String order = "customer-order";
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
              print("from $from : last $last");
              if (from > last) {
                print("End of Order");
                List<dynamic> result = [from, last];
                return result;
              } else {
                if (json.decode(res.body)['0']['order']['data'].toString() ==
                    "[]") {
                  throw OrderException(message: "empty");
                }

                Map<Order, List<Order>> orders =
                    Order.generateOrderReceivedList(
                        json.decode(res.body)['0']['total_order'],
                        json.decode(res.body)['0']['order']['data']);

                List<dynamic> result = [from, last, orders];

                return result;
                // List<Order> orders = Order.generateOrderReceivedList(
                //     json.decode(res.body)['0']['order']);

                // return orders;
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
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw OrderException(message: 'Not Authorized');
        } else if (e is OrderException) {
          throw OrderException(message: e.message);
        } else {
          print('Connection Error:  ${e.toString()}');
          throw OrderException(
              message: "Sorry, We couldn't get a response from our server");
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
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw OrderException(message: 'Not Authorized');
        } else if (e is OrderException) {
          throw OrderException(message: e.message);
        } else {
          print('Connection Error');
          throw OrderException(
              message: "Sorry, We couldn't get a response from our server");
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
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw OrderException(message: 'Not Authorized');
        } else if (e is OrderException) {
          throw OrderException(message: e.message);
        } else {
          print('Connection Errror $e');
          throw OrderException(
              message: "Sorry, We couldn't get a response from our server");
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
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw OrderException(message: 'Not Authorized');
        } else if (e is OrderException) {
          throw OrderException(message: e.message);
        } else {
          print('Connection Error');
          throw OrderException(
              message: "Sorry, We couldn't get a response from our server");
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
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw WishlistException(message: 'Not Authorized');
        } else if (e is WishlistException) {
          throw WishlistException(message: e.message);
        } else {
          print('Connection Error');
          throw WishlistException(
              message: "Sorry, We couldn't get a response from our server");
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
          } else if (e is FormatException) {
            throw WishlistException(message: 'Not Authorized');
          } else if (e is WishlistException) {
            throw WishlistException(message: e.message);
          } else {
            print('Connection Error');
            throw WishlistException(
                message: "Sorry, We couldn't get a response from our server");
          }
        } else {
          print('Connection Error');
          throw WishlistException(
              message: "Sorry, We couldn't get a response from our server");
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
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw WishlistException(message: 'Not Authorized');
        } else if (e is WishlistException) {
          throw WishlistException(message: e.message);
        } else {
          print('Connection Error');
          throw WishlistException(
              message: "Sorry, We couldn't get a response from our server $e");
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
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw WishlistException(message: 'Not Authorized');
        } else if (e is WishlistException) {
          throw WishlistException(message: e.message);
        } else {
          print('Connection Error');
          throw WishlistException(
              message: "Sorry, We couldn't get a response from our server $e");
        }
      }
    } else {
      throw WishlistException(message: 'Not Authorized');
    }
  }

  @override
  Future<List<dynamic>> fetchCart() async {
    String cart = "cart";

    if (APIService.token != null) {
      try {
        var res = await http.get(
          "$SERVER_IP/$cart",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        );
        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              //print(json.decode(res.body)['0']['cartitem']);
              List<Cart> cart = Cart.generatecartlistList(
                  json.decode(res.body)['0']['cartitem'],
                  json.decode(res.body)['0']['allTotal']);

              List<dynamic> result = cart;
              return result;
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw CartException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw CartException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw CartException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw CartException(message: 'Wrong Connection');
        }
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw CartException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw CartException(message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw CartException(
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw CartException(message: 'Not Authorized');
        } else if (e is CartException) {
          throw CartException(message: e.message);
        } else {
          print('Connection Error');
          throw CartException(
              message: "Sorry, We couldn't get a response from our server");
        }
      }
    } else {
      throw CartException(message: 'Not Authorized');
    }
  }

  @override
  Future<int> countCartItems() async {
    String cart = "cart/count";
    if (APIService.token != null) {
      try {
        var res = await http.get(
          "$SERVER_IP/$cart",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        ).timeout(Duration(seconds: 20));
        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              Cart.count = json.decode(res.body)['count'];
              return json.decode(res.body)['count'];
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw CartException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw CartException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw CartException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw CartException(message: 'Wrong Connection');
        }
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw CartException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw CartException(message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw CartException(
                message:
                    "Sorry, We couldn't get a response from our server $e");
          }
        } else if (e is FormatException) {
          throw CartException(message: 'Not Authorized');
        } else if (e is CartException) {
          throw CartException(message: e.message);
        } else {
          print('Connection Error');
          throw CartException(
              message: "Sorry, We couldn't get a response from our server $e");
        }
      }
    } else {
      throw CartException(message: 'Not Authorized');
    }
  }

  @override
  Future<bool> addToCart({int postid}) async {
    String cart = "cart/add";
    if (APIService.token != null) {
      try {
        var res = await http.post(
          "$SERVER_IP/$cart/$postid",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        ).timeout(Duration(seconds: 20));
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
                throw CartException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw CartException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw CartException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw CartException(message: 'Wrong Connection');
        }
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw CartException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw CartException(message: "Sorry, We couldn't reach the server");
          } else if (e is FormatException) {
            throw CartException(message: 'Not Authorized');
          } else if (e is CartException) {
            throw CartException(message: e.message);
          } else {
            print('Connection Error');
            throw CartException(
                message: "Sorry, We couldn't get a response from our server");
          }
        } else {
          print('Connection Error');
          throw CartException(
              message: "Sorry, We couldn't get a response from our server");
        }
      }
    } else {
      throw CartException(message: 'Not Authorized');
    }
  }

  @override
  Future<bool> deleteCartItem(int id) async {
    String cart = "cart";
    if (APIService.token != null) {
      try {
        var res = await http.delete(
          "$SERVER_IP/$cart/$id",
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
                throw CartException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw CartException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw CartException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw CartException(message: 'Wrong Connection');
        }
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw CartException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw CartException(message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw CartException(
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw CartException(message: 'Not Authorized');
        } else if (e is CartException) {
          throw CartException(message: e.message);
        } else {
          print('Connection Error');
          throw CartException(
              message: "Sorry, We couldn't get a response from our server $e");
        }
      }
    } else {
      throw CartException(message: 'Not Authorized');
    }
  }

  @override
  Future<bool> updateCartItem(int id, bool increase) async {
    String cart = "cart/";
    if (increase) {
      cart += "increament";
    } else {
      cart += "decreament";
    }
    if (APIService.token != null) {
      try {
        var res = await http.put(
          "$SERVER_IP/$cart/$id",
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
                throw CartException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw CartException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw CartException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw CartException(message: 'Wrong Connection');
        }
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw CartException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw CartException(message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw CartException(
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw CartException(message: 'Not Authorized');
        } else if (e is CartException) {
          throw CartException(message: e.message);
        } else {
          print('Connection Error');
          throw CartException(
              message: "Sorry, We couldn't get a response from our server $e");
        }
      }
    } else {
      throw CartException(message: 'Not Authorized');
    }
  }

  @override
  Future<Address> toCheckOut() async {
    String cart = "cart/checkout";

    if (APIService.token != null) {
      try {
        var res = await http.get(
          "$SERVER_IP/$cart",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        );
        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              //print(json.decode(res.body)['0']['cartitem']);

              Cart.allTotal = double.parse(
                  (json.decode(res.body)['0']['allTotal']).toString());

              Address address =
                  Address.fromJson(json.decode(res.body)['0']['address']);

              return address;
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw CartException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw CartException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw CartException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection');
          throw CartException(message: 'Wrong Connection');
        }
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw CartException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw CartException(message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw CartException(
                message: "Sorry, We couldn't get a response from our server ");
          }
        } else if (e is FormatException) {
          throw CartException(message: 'Not Authorized');
        } else if (e is CartException) {
          throw CartException(message: e.message);
        } else {
          print('Connection Errorr ' + e.toString());
          throw CartException(
              message: "Sorry, We couldn't get a response from our server ");
        }
      }
    } else {
      throw CartException(message: 'Not Authorized');
    }
  }

  @override
  Future<bool> order(
      {bool addressChange,
      Address address,
      String note,
      String landmark,
      String city,
      String phone}) async {
    if (APIService.token != null) {
      try {
        var res = await http
            .post("$SERVER_IP/cart/checkout",
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer ${APIService.token}'
                },
                body: jsonEncode(<String, dynamic>{
                  "newaddch": addressChange.toString().toUpperCase(),
                  "order_note": note,
                  "newlandmark": landmark,
                  "newcity": city,
                  "newnumber": phone,
                  "address": address.address1,
                  "town": address.city,
                  "phonenum": address.phone,
                  "vueradio": "Cash on Delivery"
                }))
            .timeout(Duration(seconds: 20));

        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              Cart.allTotal = 0.0;
              Cart.count = 0;
              return true;
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw CartException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw CartException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw CartException(message: 'Wrong Question');
          }
        } else {
          print(res.body);
          print('Wrong Connection');
          throw CartException(
              message: 'Wrong Connection ' + res.statusCode.toString());
        }
      } catch (e) {
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw CartException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw CartException(message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw CartException(
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw CartException(message: 'Not Authorized');
        } else if (e is CartException) {
          throw CartException(message: e.message);
        } else {
          print('Connection Error');
          throw CartException(
              message: "Sorry, We couldn't get a response from our server $e");
        }
      }
    } else {
      throw CartException(message: 'Not Authorized');
    }
  }

  @override
  Future<List<dynamic>> searchProductsByCat(int id) async {
    String product = "search_by_cat";

    if (APIService.token != null) {
      try {
        var res = await http.get(
          "$SERVER_IP/$product/$id",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${APIService.token}'
          },
        ).timeout(Duration(seconds: 20));
        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              List<Product> products =
                  Product.generateProductList(json.decode(res.body)['0']);

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
          print('Wrong Connection ' + res.statusCode.toString());
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
            print('Connection Error ' + e.message);
            throw ProductException(
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw ProductException(message: 'Not Authorized');
        } else if (e is ProductException) {
          throw ProductException(message: e.message);
        } else {
          print('Connection Error ' + e.toString());
          throw ProductException(
              message: "Sorry, We couldn't get a response from our server");
        }
      }
    } else {
      throw ProductException(message: 'Not Authorized');
    }
  }

  @override
  Future<List<dynamic>> searchProducts(String text) async {
    String product = "search";

    if (APIService.token != null) {
      try {
        var res = await http
            .post("$SERVER_IP/$product",
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer ${APIService.token}'
                },
                body: jsonEncode(<String, dynamic>{"searchbyal": text}))
            .timeout(Duration(seconds: 20));
        if (res.statusCode == 200) {
          if (res.body != null) {
            if (json.decode(res.body)['sucess']) {
              List<Product> products =
                  Product.generateProductList(json.decode(res.body)['0']);

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
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw ProductException(message: 'Not Authorized');
        } else if (e is ProductException) {
          throw ProductException(message: e.message);
        } else {
          print('Connection Error');
          throw ProductException(
              message: "Sorry, We couldn't get a response from our server");
        }
      }
    } else {
      throw ProductException(message: 'Not Authorized');
    }
  }

  @override
  Future<List<dynamic>> fetchCategories() async {
    String product = "categories";

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
              List<Category> products =
                  Category.generateCateogryList(json.decode(res.body)['0']);
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
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw ProductException(message: 'Not Authorized');
        } else if (e is ProductException) {
          throw ProductException(message: e.message);
        } else {
          print('Connection Error');
          throw ProductException(
              message: "Sorry, We couldn't get a response from our server");
        }
      }
    } else {
      throw ProductException(message: 'Not Authorized');
    }
  }

  @override
  Future<List<dynamic>> fetchMedsInfo() async {
    String product = "medsinfo";

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
              List<MedicalInfo> products = MedicalInfo.generateMedsList(
                  json.decode(res.body)['0']['info']);
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
            print('Connection Errorr ' + e.message);
            throw ProductException(
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw ProductException(message: 'Not Authorized');
        } else if (e is ProductException) {
          throw ProductException(message: e.message);
        } else {
          print('Connection Errorr ' + e.toString());
          throw ProductException(
              message: "Sorry, We couldn't get a response from our server");
        }
      }
    } else {
      throw ProductException(message: 'Not Authorized');
    }
  }

  @override
  Future<dynamic> showMedInfo({int id}) async {
    String product = "medsinfo/show/$id";
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
              MedicalInfo product =
                  MedicalInfo.fromJson(json.decode(res.body)['0']);
              print("des: " + product.description);
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
          print('Wrong Connection: ' + res.statusCode.toString());
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
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is FormatException) {
          throw ProductException(message: 'Not Authorized');
        } else if (e is ProductException) {
          throw ProductException(message: e.message);
        } else {
          print('Connection Error ' + e.toString());
          throw ProductException(
              message: "Sorry, We couldn't get a response from our server");
        }
      }
    } else {
      throw ProductException(message: 'Not Authorized');
    }
  }

  @override
  Future<Datta> showDashboard() async {
    String product = "home/dashboard";
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
              Datta dashboard = Datta.fromJson(json.decode(res.body)['0']);
              return dashboard;
            } else {
              if (json
                  .decode(res.body)['message']
                  .toString()
                  .contains('oken')) {
                print(json.decode(res.body)['message']);
                throw DashboardException(message: 'Not Authorized');
              }
              print('Wrong Request');
              throw DashboardException(message: 'Wrong Request');
            }
          } else {
            print('Wrong Question');
            throw DashboardException(message: 'Wrong Question');
          }
        } else {
          print('Wrong Connection: ' + res.statusCode.toString());
          throw DashboardException(message: 'Wrong Connection');
        }
      } catch (e) {
        //throw DashboardException(message: "Error $e");
        if (e is SocketException) {
          if (e.toString().contains("Network is unreachable")) {
            print('Internet Error');
            throw DashboardException(message: "Check Your Connection");
          } else if (e.toString().contains("Connection refused")) {
            print('Error from Server');
            throw DashboardException(
                message: "Sorry, We couldn't reach the server");
          } else {
            print('Connection Error');
            throw DashboardException(
                message: "Sorry, We couldn't get a response from our server");
          }
        } else if (e is DashboardException) {
          throw DashboardException(message: e.message);
        } else {
          print('Connection Error ' + e.toString());
          throw DashboardException(
              message: "Sorry, We couldn't get a response from our server");
        }
      }
    } else {
      throw DashboardException(message: 'Not Authorized');
    }
  }
}
