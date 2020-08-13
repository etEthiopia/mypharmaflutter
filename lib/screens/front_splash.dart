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
              SpinKitFadingCube(
                size: MediaQuery.of(context).orientation == Orientation.portrait
                    ? 100
                    : 50,
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? primary : dark,
                    ),
                  );
                },
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "MyPharma",
                style: TextStyle(color: dark, fontSize: 35),
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
