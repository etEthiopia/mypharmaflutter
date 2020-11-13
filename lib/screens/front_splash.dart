import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mypharma/theme/colors.dart';

class FrontSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "MyPharma",
                style: TextStyle(color: dark, fontSize: 40),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Stay Connected!",
                style: TextStyle(color: primary, fontSize: 20),
              ),
            ],
          )),
    );
  }
}
