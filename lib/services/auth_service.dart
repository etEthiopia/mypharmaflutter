import 'dart:convert';

import 'package:mypharma/exceptions/exceptions.dart';
import 'package:mypharma/models/models.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

abstract class AuthServiceSkel {
  Future<User> getCurrentUser();
  Future<User> signIn(String email, String password);
}

class AuthService extends AuthServiceSkel {
  @override
  Future<User> getCurrentUser() async {
    var str = await storage.read(key: "user_token");

    if (str != null) {
      var jwt = str.split(".");

      if (jwt.length == 3) {
        return User(user_token: str);
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
    if (res.statusCode == 200) {
      if (res.body != null) {
        await storage.write(key: "jwt", value: json.decode(res.body)['token']);
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
}
