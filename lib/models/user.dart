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
  String user_token;
  var payload;
  String is_representative;

  User({@required this.user_token}) {
    final parts = user_token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final ppayload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(ppayload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    payload = payloadMap;
    name = payload['name'];
    email = payload['email'];
    print(this.toString());

    // id = user['id'];
    // name = user['name'];
    // email = user['email'];
    // email_verified_at = user['email_verified_at'];
    // created_at = user['created_at'];
    // updated_at = user['updated_at'];
    // role = _numberToRole(user['role']);
    // profileimg = user['profileimg'];
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
    return User(user_token: json['user_token']);
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
