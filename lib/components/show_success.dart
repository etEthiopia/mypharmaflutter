import 'package:flutter/material.dart';

void showSucess(String message, var context) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.green,
  ));
}
