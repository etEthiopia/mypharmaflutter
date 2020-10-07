import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/auth/bloc.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class SignInUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthFailure) {
        showError(state.error, context);
      }
    }, child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthNotAuthenticated) {
        return SizedBox(
          width: double.infinity,
          child: Material(
            color: ThemeColor.extralight,
            child: FlatButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    color: ThemeColor.darkText,
                    size: 20,
                  ),
                  Text(
                    //"Login/Register for a full experience!",
                    AppLocalizations.of(context)
                        .translate("login_/_register_btn_text"),
                    style: TextStyle(
                        color: ThemeColor.darkText, fontFamily: defaultFont),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    }));
  }
}
