import 'package:flutter/material.dart';
import 'dart:convert';

class User {
  int id;
  String name;
  String email;
  String email_verified_at;
  String created_at;
  String updated_at;
  Role role;
  String profileimg;
  String profession;
  String user_activation_key;
  String status;
  String token;
  bool remember;
  var payload;
  String is_representative;

  User({@required this.token, dynamic user}) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }
    // print("part0: ${parts[0]}");
    // print("part1: ${parts[1]}");
    // print("part2: ${parts[2]}");

    final ppayload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(ppayload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    payload = payloadMap;

    // Map userp = user;
    // print(userp.keys);

    id = user['id'];
    name = user['name'];
    email = user['email'];
    //email_verified_at = user['email_verified_at'];
    // created_at = user['created_at'];
    // updated_at = user['updated_at'];
    role = _numberToRole(user['role']);
    profileimg = user['profileimg'];
    // user_activation_key = user['user_activation_key'];
    // is_representative = user['is_representative'];
  }

  Role _numberToRole(int roleint) {
    Role x;
    switch (roleint) {
      case 1:
        x = Role.admin;
        break;
      case 2:
        x = Role.importer;
        break;
      case 3:
        x = Role.wholeseller;
        break;
      case 4:
        x = Role.pharmacist;
        break;
      case 5:
        x = Role.phyisican;
        break;
    }
    if (x == null) {
      throw Exception('role unknown');
    }
    return x;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(token: json['token'], user: json['user']);
  }

  factory User.fromData(String data) {
    List<dynamic> dict = data.split(',,');

    return User(token: dict[1], user: <String, dynamic>{
      "id": int.parse(dict[2]),
      "name": dict[3],
      "email": dict[4],
      "role": int.parse(dict[5]),
      "profileimg": dict[6]
    });
  }

  static String jsonToString(var json, bool remember) {
    String token = json['token'];
    String id = json['user']['id'].toString();
    String name = json['user']['name'];
    String email = json['user']['email'];
    String role = json['user']['role'].toString();
    var pi = json['user']['profileimg'];
    String rememberme = 'f';
    if (remember != null) {
      if (remember) {
        rememberme = 't';
      }
    }
    String profileimg = "null";
    if (pi != null) {
      profileimg = pi.toString();
    }

    return rememberme +
        ",," +
        token +
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

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  @override
  String toString() => 'User { name: $name, email: $email, role: $role}';
}

enum Role { admin, importer, wholeseller, pharmacist, phyisican }
