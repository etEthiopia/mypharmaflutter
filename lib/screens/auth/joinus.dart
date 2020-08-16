import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/blocs/auth/bloc.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class JoinUs extends StatefulWidget {
  @override
  _JoinUsState createState() => _JoinUsState();
}

class _JoinUsState extends State<JoinUs> {
  @override
  Widget build(BuildContext context) {
    Widget _introSection() {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              width: double.infinity,
              color: Colors.black.withOpacity(0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Stay Connected",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: defaultFont),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Join us and stay connected. Make the Ethiopian pharmaceutical Industry efficent and safe, whilst being very benefited yourself",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: defaultFont),
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            )
          ],
        ),
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/section/blueserum.jpg',
                ))),
      );
    }

    Widget _joinusSection() {
      return Row(
        children: <Widget>[
          Container(
            child: Container(
              height: double.maxFinite,
              width: 5,
              color: dark,
              child: Text(""),
            ),
          ),
          SizedBox(
            width: 30.0,
          ),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Text(
                  "Join Us",
                  style: TextStyle(
                      color: darksecond, fontSize: 30, fontFamily: defaultFont),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna wirl aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisinuli.",
                  style: TextStyle(fontSize: 15, fontFamily: defaultFont),
                  overflow: TextOverflow.visible,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
              ],
            ),
          )
        ],
      );
    }

    Widget _loginBtn() {
      return SizedBox(
        width: double.infinity,
        child: Material(
          color: primary,
          borderRadius: BorderRadius.circular(15.0),
          child: FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text(
              "Login if you have an account",
              style: TextStyle(color: Colors.white, fontFamily: defaultFont),
            ),
          ),
        ),
      );
    }

    Widget _joinasphyBtn() {
      return SizedBox(
        width: double.infinity,
        child: Material(
          color: dark,
          borderRadius: BorderRadius.circular(15.0),
          child: FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, '/registerphy');
            },
            child: Text(
              "Join as a Physician",
              style: TextStyle(color: Colors.white, fontFamily: defaultFont),
            ),
          ),
        ),
      );
    }

    Widget _divider() {
      return Divider(color: accent);
    }

    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Scaffold(
              drawer: Drawer(child: UserDrawer()),
              body: SafeArea(
                child: Column(
                  children: <Widget>[
                    Expanded(flex: 3, child: _introSection()),
                    Expanded(
                      flex: 3,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 30.0),
                          child: _joinusSection()),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: AlignmentDirectional.bottomEnd,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            _joinasphyBtn(),
                            _divider(),
                            _loginBtn(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        }
      });
    } else {
      return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Scaffold(
            body: SafeArea(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: _introSection(),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: _joinusSection(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _joinasphyBtn(),
                          _divider(),
                          _loginBtn(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      });
    }
  }
}
