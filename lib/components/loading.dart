import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mypharma/blocs/auth/bloc.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

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

NoInternet(context, from) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        Text(
          "Please, Check your Connection",
          textAlign: TextAlign.center,
          style: TextStyle(color: dark, fontSize: 25, fontFamily: defaultFont),
        ),
        SizedBox(
          width: double.infinity,
          child: Material(
            color: dark,
            borderRadius: BorderRadius.circular(15.0),
            child: FlatButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/$from');
              },
              child: Text(
                "Retry",
                style: TextStyle(color: Colors.white, fontFamily: defaultFont),
              ),
            ),
          ),
        ),
      ],
    ),
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

LoggedOutLoading(context) {
  final _authBloc = BlocProvider.of<AuthBloc>(context);
  return BlocListener<AuthBloc, AuthState>(listener: (context, state) {
    if (state is AuthFailure) {
      showError(state.error, context);
    }
  }, child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
    _authBloc.add(UserLoggedOut());
    return LoadingLogin(context);
  }));
}
