import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/blocs/auth/bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    Widget _logoSection() {
      return Container(
          margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
          alignment: Alignment.topCenter,
          child: Image.asset(
            "assets/images/logo/logo100.png",
            width: 100.0,
          ));
    }

    Widget _loginBtn() {
      return SizedBox(
        width: double.infinity,
        child: Material(
          color: ThemeColor.primaryBtn,
          borderRadius: BorderRadius.circular(15.0),
          child: FlatButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                Text(
                  "Go Back",
                  style:
                      TextStyle(color: Colors.white, fontFamily: defaultFont),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _joinasphyBtn() {
      return SizedBox(
        width: double.infinity,
        child: Material(
          color: ThemeColor.darkBtn,
          borderRadius: BorderRadius.circular(15.0),
          child: FlatButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (Route<dynamic> route) => false);
            },
            child: Text(
              "Login / Register to take part",
              style: TextStyle(color: Colors.white, fontFamily: defaultFont),
            ),
          ),
        ),
      );
    }

    Widget _divider() {
      return Divider(color: ThemeColor.accent);
    }

    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return Scaffold(
          drawer: Drawer(child: UserDrawer()),
          backgroundColor: ThemeColor.background,
          appBar: cleanAppBar(title: "Settings"),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(flex: 3, child: _logoSection()),
                SwitchListTile(
                  value: ThemeColor.isDark,
                  title: Text(
                    "Dark Mode",
                    style: TextStyle(color: ThemeColor.contrastText),
                  ),
                  onChanged: (value) {
                    ThemeColor.isDark = value;
                    ThemeColor.ChangeTheme();
                  },
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: AlignmentDirectional.bottomEnd,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
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
    } else {
      return Scaffold(
        backgroundColor: ThemeColor.background,
        body: SafeArea(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: _logoSection(),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: <Widget>[
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
  }
}
