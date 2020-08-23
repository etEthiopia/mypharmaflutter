import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/blocs/auth/bloc.dart';
import 'package:mypharma/components/page_end.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/screens/auth/joinus.dart';
import 'package:mypharma/screens/auth/login.dart';
import 'package:mypharma/screens/auth/registerphy.dart';
import 'package:mypharma/screens/front_splash.dart';
import 'package:mypharma/screens/posts/feed.dart';
import 'package:mypharma/screens/products/stock.dart';

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
        '/feed': (context) => Feed(),
        '/stock': (context) => Stock(),
      },
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return FrontSplash();
          }
          if (state is AuthAuthenticated) {
            // show home page
            if (state.user.role == Role.importer) {
              return Stock();
            } else {
              return Feed();
            }
          }
          // otherwise show login page
          return Login();
        },
      ),
    );
  }
}
