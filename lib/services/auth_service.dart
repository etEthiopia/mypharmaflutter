import 'dart:convert';

import 'package:mypharma/exceptions/exceptions.dart';
import 'package:mypharma/models/models.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

abstract class AuthServiceSkel {
  Future<User> getCurrentUser();
  Future<User> signIn(String email, String password);
  Future<User> signUp(
      {String name, String email, int profession, String password});
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
}
