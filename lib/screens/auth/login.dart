import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/auth/bloc.dart';
import 'package:mypharma/blocs/login/bloc.dart';
import 'package:mypharma/blocs/wishlist/bloc.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/services/services.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //_layout(authService: authService)
  @override
  Widget build(BuildContext context) {
    final apiService = RepositoryProvider.of<APIService>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      drawer: UserDrawer(),
      backgroundColor: ThemeColor.background,
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, apiService),
        child: SafeArea(
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _autoValidate = false;
  bool _remember = false;
  selected() {
    setState(() {
      _remember = !_remember;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _signin() async {
      if (_key.currentState.validate()) {
        _loginBloc.add(LoginInWithEmailButtonPressed(
            email: _emailController.text,
            password: _passwordController.text,
            remember: _remember));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
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

    Widget _sizedBox() {
      return SizedBox(
        height: 20.0,
      );
    }

    Widget _emailPrompt() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: ThemeColor.background.withOpacity(0.8),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: primary, width: 2, style: BorderStyle.solid)),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: TextFormField(
              style: TextStyle(color: ThemeColor.contrastText),
              decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context).translate("email_text"),
                  hintStyle: TextStyle(color: ThemeColor.extralightText),
                  icon: Icon(
                    Icons.mail,
                    color: dark,
                  ),
                  border: InputBorder.none,
                  isDense: true),
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: (value) {
                if (value.isEmpty) {
                  return "The email cannot be empty";
                } else {
                  Pattern pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                }
                return null;
              },
            ),
          ),
        ),
      );
    }

    Widget _passwordPrompt() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: ThemeColor.background.withOpacity(0.8),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: primary, width: 2, style: BorderStyle.solid)),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: TextFormField(
              obscureText: true,
              style: TextStyle(color: ThemeColor.contrastText),
              decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context).translate("password_text"),
                  hintStyle: TextStyle(color: ThemeColor.extralightText),
                  icon: Icon(
                    Icons.lock,
                    color: dark,
                  ),
                  border: InputBorder.none,
                  isDense: true),
              controller: _passwordController,
              validator: (value) {
                if (value.isEmpty) {
                  return "The password cannot be empty";
                } else if (value.length < 6) {
                  return "The password length must be at least six";
                }
                return null;
              },
            ),
          ),
        ),
      );
    }

    Widget _rememberme() {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              child: Checkbox(
                value: _remember,
                activeColor: dark,
                onChanged: (current) {
                  selected();
                },
              ),
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                selected();
              },
              child: Text(
                AppLocalizations.of(context).translate("remember_me_text"),
                style: TextStyle(
                    color: ThemeColor.darkText,
                    fontSize: 16,
                    fontFamily: defaultFont),
              ),
            )
          ],
        ),
      );
    }

    Widget _signinBtn() {
      return SizedBox(
        width: double.infinity,
        child: Material(
          elevation: 1,
          shadowColor: light,
          color: ThemeColor.darkBtn,
          borderRadius: BorderRadius.circular(15.0),
          child: FlatButton(
            onPressed: () {
              _signin();
            },
            child: Text(
              AppLocalizations.of(context).translate("sign_in_btn_text"),
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontFamily: defaultFont),
            ),
          ),
        ),
      );
    }

    Widget _forgotpassword() {
      return InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/forgotpassword');
          },
          child: Text(
            AppLocalizations.of(context).translate("forgot_password_text"),
            style: TextStyle(
                color: ThemeColor.darkText,
                decoration: TextDecoration.underline,
                fontFamily: defaultFont),
          ));
    }

    Widget _orText() {
      return Center(
        child: Text(
          AppLocalizations.of(context).translate("or_text"),
          style: TextStyle(
              color: ThemeColor.darksecondText, fontFamily: defaultFont),
        ),
      );
    }

    Widget _divider() {
      return Divider(color: ThemeColor.accent);
    }

    Widget _createaccountBtn() {
      return SizedBox(
        width: double.infinity,
        child: Material(
          color: ThemeColor.accent,
          borderRadius: BorderRadius.circular(15.0),
          child: FlatButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/registerphy');
            },
            child: Text(
              AppLocalizations.of(context).translate("create_account_btn_text"),
              style: TextStyle(color: Colors.white, fontFamily: defaultFont),
            ),
          ),
        ),
      );
    }

    Widget _feedBtn() {
      return SizedBox(
        width: double.infinity,
        child: Material(
          color: ThemeColor.extralightBtn.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15.0),
          child: InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/feed');
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                AppLocalizations.of(context).translate("see_whats_new_text"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ThemeColor.darkText,
                  fontFamily: defaultFont,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      if (state is LoginFailure) {
        showError(state.error, context);
      } else if (state is LoginSuccess) {
        final _wishlistBloc = BlocProvider.of<WishlistBloc>(context);
        _wishlistBloc.add(WishlistCount());
        Navigator.pushReplacementNamed(context, '/');
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state is LoginLoading) {
        return LoadingLogin(context);
      }
      Orientation orientation = MediaQuery.of(context).orientation;
      if (orientation == Orientation.portrait) {
        return Container(
          padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: <Widget>[
                  Form(
                    key: _key,
                    autovalidate: _autoValidate,
                    child: Column(children: <Widget>[
                      _logoSection(),
                      _sizedBox(),
                      _emailPrompt(),
                      _passwordPrompt(),
                      _sizedBox(),
                      _rememberme(),
                      _signinBtn(),
                      _sizedBox(),
                      _forgotpassword(),
                      _sizedBox(),
                      _orText(),
                      _divider(),
                      _createaccountBtn(),
                      _sizedBox(),
                      _feedBtn(),
                    ]),
                  ),
                ],
              )),
        );
      } else {
        return Container(
            child: SingleChildScrollView(
          reverse: true,
          child: Container(
            padding: EdgeInsets.only(top: 30.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: <Widget>[
                        _logoSection(),
                        _divider(),
                        _createaccountBtn(),
                        _sizedBox(),
                        _feedBtn(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Form(
                        key: _key,
                        autovalidate: _autoValidate,
                        child: Column(children: <Widget>[
                          _emailPrompt(),
                          _passwordPrompt(),
                          _sizedBox(),
                          _rememberme(),
                          _signinBtn(),
                          _sizedBox(),
                          _forgotpassword(),
                        ]),
                      )),
                ),
              ],
            ),
          ),
        ));
      }
    }));
  }
}
