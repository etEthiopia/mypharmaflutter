import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/blocs/auth/auth_bloc.dart';
import 'package:mypharma/blocs/auth/auth_state.dart';
import 'package:mypharma/screens/auth/joinus.dart';
import 'package:mypharma/screens/auth/login.dart';
import 'package:mypharma/screens/auth/registerphy.dart';
import 'package:mypharma/screens/front_splash.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyPharma',
      routes: {
        '/login': (context) => Login(),
        '/joinus': (context) => JoinUs(),
        '/registerphy': (context) => RegisterPhy(),
      },
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return FrontSplash();
          }
          if (state is AuthAuthenticated) {
            // show home page
            return JoinUs();
          }
          // otherwise show login page
          return Login();
        },
      ),
    );
  }
}
