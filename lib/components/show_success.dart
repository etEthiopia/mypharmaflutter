import 'package:flutter/material.dart';
import 'package:mypharma/theme/colors.dart';

void showSucess(String message, var context) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: ThemeColor.darkBtn,
  ));
}
