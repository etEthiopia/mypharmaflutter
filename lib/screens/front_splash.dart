import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mypharma/theme/colors.dart';

class FrontSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Container(
              //     margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
              //     alignment: Alignment.topCenter,
              //     child: Image.asset(
              //       "assets/images/logo/logo50.png",
              //       width: 100.0,
              //     )),
              // SizedBox(
              //   height: 50,
              // ),
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
