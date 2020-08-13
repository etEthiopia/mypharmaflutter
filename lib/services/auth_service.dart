import 'dart:convert';

import 'package:mypharma/exceptions/exceptions.dart';
import 'package:mypharma/models/models.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

abstract class AuthServiceSkel {
  Future<User> getCurrentUser();
  Future<User> signIn(String email, String password);
  Future<int> signUp(
      {String name, String email, String profession, String password});
  Future<void> signOut();
}

class AuthService extends AuthServiceSkel {
  @override
  Future<User> getCurrentUser() async {
    var str = await storage.read(key: "user");
    if (str != null) {
      var long = str.split(",,");

      if (long.length == 6) {
        return User.fromData(str);
      }
    }
    return null;
  }

  @override
  Future<User> signIn(String email, String password) async {
    var res = await http.post("$SERVER_IP/login",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{"email": email, "password": password}));
    print("url: $SERVER_IP/login");
    print("email: $email");
    print("password: $password");
    if (res.statusCode == 200) {
      if (res.body != null) {
        await storage.write(
            key: "user", value: jsonToString(json.decode(res.body)));
        return User.fromJson(json.decode(res.body));
      } else {
        print('Wrong credntials');
        throw AuthException(message: 'Wrong credntials');
      }
    } else {
      print('Wrong username or password');
      throw AuthException(message: 'Wrong username or password');
    }
  }

  @override
  Future<void> signOut() async {
    await storage.delete(key: "user");
    return null;
  }

  @override
  Future<int> signUp(
      {String name, String email, String profession, String password}) {
    return null;
  }

  String jsonToString(var json) {
    String token = json['token'];
    String id = json['user']['id'];
    String name = json['user']['name'];
    String email = json['user']['email'];
    String role = json['user']['role'];
    String profileimg = json['user']['profileimg'];

    return token +
        ",," +
        id +
        ",," +
        name +
        ",," +
        email +
        ",," +
        role +
        ",," +
        profileimg;
  }
}
