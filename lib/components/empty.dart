import 'package:flutter/material.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

Widget empty(context, route) {
  return Container(
      padding: EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 10),
      child: MediaQuery.of(context).orientation == Orientation.portrait
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/figures/nothing.png',
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: light,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "You don't have anything",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: dark, fontSize: 25, fontFamily: defaultFont),
                ),
              ],
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: Image.asset('assets/images/figures/nothing.png'),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: light,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "You don't have anything",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: dark, fontSize: 25, fontFamily: defaultFont),
                ),
              ],
            ));
}
