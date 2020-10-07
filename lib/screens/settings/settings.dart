import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mypharma/app_localizations.dart';
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
  String lang;

  @override
  void initState() {
    setState(() {
      thememode = ThemeColor.isDark;
    });
    AppLocalizations.getCurrentLangAndTheme().then((value) => setState(() {
          lang = value.toString();
        }));
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
            AppLocalizations.of(context).translate("confirmation_dialog_title"),
            style: TextStyle(color: ThemeColor.contrastText),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)
                      .translate("restart_confirmation_dialog_text"),
                  style: TextStyle(color: ThemeColor.contrastText),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                AppLocalizations.of(context)
                    .translate("restart_later_btn_text"),
                style: TextStyle(color: ThemeColor.primaryText),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                AppLocalizations.of(context)
                    .translate("restart_restart_btn_text"),
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
      if (this.lang != lang + "_" + country) {
        Locale locale = Locale(lang, country);
        await AppLocalizations.storelang(locale);
        _showMyDialog();
      }
    }

    Widget _thememode() {
      return SwitchListTile(
        value: thememode,
        title: Text(
          AppLocalizations.of(context).translate("dark_mode_text"),
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

    Widget _goBackBtn() {
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
                  AppLocalizations.of(context).translate("go_back_btn_text"),
                  style:
                      TextStyle(color: Colors.white, fontFamily: defaultFont),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _loginOrRegister() {
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
              AppLocalizations.of(context)
                  .translate("login_/_register_btn_text"),
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
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 17, bottom: 5),
              child: Text(
                AppLocalizations.of(context).translate("choose_lang_text"),
                style: TextStyle(color: ThemeColor.contrastText, fontSize: 16),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: this.lang != null
                          ? (this.lang == "am_ET"
                              ? ThemeColor.primaryBtn
                              : ThemeColor.background)
                          : ThemeColor.background,
                      child: FlatButton(
                        onPressed: () {
                          changeLang("am", "ET");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 17,
                                margin: EdgeInsets.only(right: 5),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/images/langs/et.png",
                                )),
                            Text(
                              "አማርኛ",
                              style: TextStyle(
                                  color: this.lang != null
                                      ? (this.lang == "am_ET"
                                          ? Colors.white
                                          : ThemeColor.contrastText)
                                      : ThemeColor.contrastText,
                                  fontFamily: defaultFont),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: this.lang != null
                          ? (this.lang == "en_US"
                              ? ThemeColor.primaryBtn
                              : ThemeColor.background)
                          : ThemeColor.background,
                      child: FlatButton(
                        onPressed: () {
                          changeLang("en", "US");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 5),
                                height: 17,
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/images/langs/uk.png",
                                )),
                            Text(
                              "English",
                              style: TextStyle(
                                  color: this.lang != null
                                      ? (this.lang == "en_US"
                                          ? Colors.white
                                          : ThemeColor.contrastText)
                                      : ThemeColor.contrastText,
                                  fontFamily: defaultFont),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
          appBar: cleanAppBar(
              title: AppLocalizations.of(context).translate("settings_title")),
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
                        _loginOrRegister(),
                        _divider(),
                        _goBackBtn(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
    } else {
      return Scaffold(
        drawer: Drawer(child: UserDrawer()),
        backgroundColor: ThemeColor.background,
        appBar: cleanAppBar(
            title: AppLocalizations.of(context).translate("settings_title")),
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _thememode(),
                        _chooseLang(),
                        _loginOrRegister(),
                        _divider(),
                        _goBackBtn(),
                      ],
                    ),
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
