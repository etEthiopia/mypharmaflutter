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
    print("str is null");
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
    print(json.decode(res.body)['sucess']);
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
  Future<int> signUp(
      {String name, String email, String profession, String password}) {
    return null;
  }
}
