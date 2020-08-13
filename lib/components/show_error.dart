import 'package:flutter/material.dart';

void _showError(String error, var context) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(error),
    backgroundColor: Theme.of(context).errorColor,
  ));
}
