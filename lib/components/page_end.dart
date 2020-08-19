import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

PageEnd(context, page) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            height: 60,
          ),
          Text(
            "Feed has ended",
            textAlign: TextAlign.end,
            style:
                TextStyle(color: dark, fontSize: 25, fontFamily: defaultFont),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: dark,
              borderRadius: BorderRadius.circular(15.0),
              child: FlatButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/$page');
                },
                child: Text(
                  "Go Back",
                  style:
                      TextStyle(color: Colors.white, fontFamily: defaultFont),
                ),
              ),
            ),
          )
        ],
      ));
}
