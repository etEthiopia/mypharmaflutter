import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mypharma/theme/colors.dart';

LoadingLogin(context) {
  return SpinKitFadingCube(
    size: MediaQuery.of(context).orientation == Orientation.portrait ? 100 : 50,
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? primary : dark,
        ),
      );
    },
  );
}

LoadingRegister(context) {
  return SpinKitFadingCube(
    size: MediaQuery.of(context).orientation == Orientation.portrait ? 100 : 50,
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? primary : dark,
        ),
      );
    },
  );
}
