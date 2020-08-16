import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/blocs/auth/bloc.dart';
import 'package:mypharma/blocs/register/bloc.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/services/services.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class RegisterPhy extends StatefulWidget {
  @override
  _RegisterPhyState createState() => _RegisterPhyState();
}

class _RegisterPhyState extends State<RegisterPhy> {
  @override
  Widget build(BuildContext context) {
    final authService = RepositoryProvider.of<AuthService>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      drawer: UserDrawer(),
      body: BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(authBloc, authService),
        child: SafeArea(
          child: _RegisterForm(),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _casswordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  bool _autoValidate = false;
  int _selectedProfession = 0;

  @override
  Widget build(BuildContext context) {
    final _registerBloc = BlocProvider.of<RegisterBloc>(context);

    _register() {
      if (_key.currentState.validate()) {
        _registerBloc.add(RegisterPressed(
            name: _fullnameController.text,
            profession: _selectedProfession,
            email: _emailController.text,
            password: _passwordController.text));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    List<String> _professionList = [
      "Doctor",
      "Health Worker",
      "Nurse",
      "Pharmacist",
      "Others",
    ];

    List<DropdownMenuItem<dynamic>> professions = [
      DropdownMenuItem(
        value: 0,
        child: Text(
          "Doctor",
          style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
        ),
      ),
      DropdownMenuItem(
        value: 1,
        child: Text(
          "Health Worker",
          style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
        ),
      ),
      DropdownMenuItem(
        value: 2,
        child: Text(
          "Nurse",
          style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
        ),
      ),
      DropdownMenuItem(
        value: 3,
        child: Text(
          "Pharmacist",
          style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
        ),
      ),
      DropdownMenuItem(
        value: 4,
        child: Text(
          "Others",
          style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
        ),
      ),
    ];

    Widget _professionText() {
      return Text(
        "Profession",
        style: TextStyle(color: dark, fontSize: 10, fontFamily: defaultFont),
      );
    }

    Widget _professionPrompt() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _professionText(),
            DropdownButtonFormField(
              style: TextStyle(color: dark, fontFamily: defaultFont),
              items: professions,
              hint: Text("Profession"),
              value: _selectedProfession,
              onChanged: (value) {
                setState(() {
                  _selectedProfession = value;
                });
              },
              isExpanded: true,
            ),
          ],
        ),
      );
    }

    Widget _logoSection() {
      return Container(
          margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
          alignment: Alignment.topCenter,
          child: Image.asset(
            "assets/images/logo/logo50.png",
            width: 50.0,
          ));
    }

    Widget _registerText() {
      return Text(
        "Sign Up & Stay Connected",
        style: TextStyle(color: dark, fontSize: 20, fontFamily: defaultFont),
      );
    }

    Widget _fullnamePrompt() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: Colors.white.withOpacity(0.8),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: primary, width: 2, style: BorderStyle.solid)),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Full Name",
                  icon: Icon(
                    Icons.person,
                    color: dark,
                  ),
                  border: InputBorder.none,
                  isDense: true),
              keyboardType: TextInputType.text,
              controller: _fullnameController,
              validator: (value) {
                if (value.isEmpty) {
                  return "Full Name cannot be empty";
                } else if (value.length > 25) {
                  return "Full Name length must be < 25";
                } else if (value.length < 3) {
                  return "Full Name length must be > 2";
                }
                return null;
              },
            ),
          ),
        ),
      );
    }

    Widget _smallSizedBox() {
      return SizedBox(
        height: 5,
      );
    }

    Widget _emailPrompt() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: Colors.white.withOpacity(0.0),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: primary, width: 2, style: BorderStyle.solid)),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Email",
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
          color: Colors.white.withOpacity(0.0),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: primary, width: 2, style: BorderStyle.solid)),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Password",
                  icon: Icon(
                    Icons.lock,
                    color: dark,
                  ),
                  border: InputBorder.none,
                  isDense: true),
              keyboardType: TextInputType.text,
              controller: _passwordController,
              validator: (value) {
                if (value.isEmpty) {
                  if (value.isEmpty) {
                    return "The password cannot be empty";
                  } else if (value.length < 6) {
                    return "The password length must be at least six";
                  }
                }
                return null;
              },
            ),
          ),
        ),
      );
    }

    Widget _cpasswordPrompt() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: Colors.white.withOpacity(0.0),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: primary, width: 2, style: BorderStyle.solid)),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Confirm Password",
                  icon: Icon(
                    Icons.lock,
                    color: dark,
                  ),
                  border: InputBorder.none,
                  isDense: true),
              keyboardType: TextInputType.text,
              controller: _casswordController,
              validator: (value) {
                if (value.isEmpty) {
                  return "please confirm password";
                } else if (value != _passwordController.text) {
                  return "passwords doesn't match";
                }
                //   return null;

                return null;
              },
            ),
          ),
        ),
      );
    }

    Widget _divider() {
      return Divider(color: accent);
    }

    Widget _backlogin() {
      return InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            "Back to Login",
            style: TextStyle(
                color: dark,
                decoration: TextDecoration.underline,
                fontFamily: defaultFont),
          ));
    }

    Widget _layout(bool por) {
      if (por) {
        return Column(children: <Widget>[
          _logoSection(),
          _smallSizedBox(),
          _registerText(),
          _smallSizedBox(),
          _fullnamePrompt(),
          _smallSizedBox(),
          _emailPrompt(),
          _smallSizedBox(),
          _passwordPrompt(),
          _smallSizedBox(),
          _cpasswordPrompt(),
          _smallSizedBox(),
          // _occupationPrompt(),
          _professionPrompt(),
        ]);
      }
      return Column(children: <Widget>[
        Row(
          children: <Widget>[_backlogin()],
        ),
        _registerText(),
        Row(
          children: <Widget>[
            Expanded(child: _fullnamePrompt()),
            Expanded(child: _emailPrompt()),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(child: _passwordPrompt()),
            Expanded(child: _cpasswordPrompt()),
          ],
        ),
        _professionPrompt(),
      ]);
    }

    return BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
      if (state is RegisterFailure) {
        showError(state.error, context);
      }
    }, child:
            BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      if (state is RegisterLoading) {
        return LoadingRegister(context);
      }

      Orientation orientation = MediaQuery.of(context).orientation;
      bool por;
      if (orientation == Orientation.portrait) {
        por = true;
      } else {
        por = false;
      }

      return Scaffold(
          body: SafeArea(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Form(
                          key: _key,
                          autovalidate: _autoValidate,
                          child: _layout(por)),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              width: double.infinity,
                              child: Material(
                                elevation: 1,
                                shadowColor: light,
                                color: dark,
                                borderRadius: BorderRadius.circular(15.0),
                                child: FlatButton(
                                  onPressed: () {
                                    _register();
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: defaultFont),
                                  ),
                                ),
                              ),
                            ),
                            por ? _divider() : SizedBox(),
                            por ? _backlogin() : SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  )))));
    }));
  }
}
