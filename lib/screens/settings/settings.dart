import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mypharma/app_localizations.dart';
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
  bool thememode;

  @override
  void initState() {
    setState(() {
      thememode = ThemeColor.isDark;
    });
    super.initState();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeColor.background3,
          title: Text(
            'Confirmation',
            style: TextStyle(color: ThemeColor.contrastText),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Please Restart the App to see the Changes!',
                  style: TextStyle(color: ThemeColor.contrastText),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'LATER',
                style: TextStyle(color: ThemeColor.primaryText),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'RESTART',
                style: TextStyle(color: ThemeColor.darkText),
              ),
              onPressed: () {
                Phoenix.rebirth(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    changeLang(String lang, String country) async {
      Locale locale = Locale(lang, country);
      await AppLocalizations.storelang(locale);
      _showMyDialog();
    }

    Widget _thememode() {
      return SwitchListTile(
        value: thememode,
        title: Text(
          "Dark Mode",
          style: TextStyle(color: ThemeColor.contrastText),
        ),
        onChanged: (value) {
          ThemeColor.ChangeTheme(value);
          setState(() {
            thememode = value;
          });
          _showMyDialog();
        },
      );
    }

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

    Widget _chooseLang() {
      return Container(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Material(
                color: ThemeColor.primaryBtn,
                child: FlatButton(
                  onPressed: () {
                    changeLang("am", "ET");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      Text(
                        "አማርኛ",
                        style: TextStyle(
                            color: Colors.white, fontFamily: defaultFont),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Material(
                color: ThemeColor.primaryBtn,
                child: FlatButton(
                  onPressed: () {
                    changeLang("en", "US");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      Text(
                        "English",
                        style: TextStyle(
                            color: Colors.white, fontFamily: defaultFont),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
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
                _thememode(),
                _chooseLang(),
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
                      _thememode(),
                      _chooseLang(),
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
