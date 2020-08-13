import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mypharma/blocs/auth/auth_bloc.dart';
import 'package:mypharma/blocs/auth/auth_event.dart';
import 'package:mypharma/blocs/auth_form/form_bloc.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/screens/auth/joinus.dart';
import 'package:mypharma/screens/auth/login.dart';
import 'package:mypharma/screens/auth/registerphy.dart';
import 'package:mypharma/screens/my_app.dart';
import 'package:mypharma/services/auth_service.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

const SERVER_IP = 'http://192.168.1.3/mypharma/public/api';
final storage = FlutterSecureStorage();
AuthService authService = AuthService();

void main() {
  runApp(
      // Injects the Authentication service
      RepositoryProvider<AuthService>(
          create: (context) {
            return AuthService();
          },
          // Injects the Authentication BLoC
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (context) {
                  final authService =
                      RepositoryProvider.of<AuthService>(context);
                  return AuthBloc(authService)..add(AppLoaded());
                },
              ),
              BlocProvider<AuthFormBloc>(
                create: (BuildContext context) => AuthFormBloc(),
              )
            ],
            child: MyApp(),
          )));
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'MyPharma',
//         debugShowCheckedModeBanner: false,
//         routes: {
//           '/': (context) => MyHomePage(
//                 title: 'UI',
//               ),
//           '/login': (context) => Login(),
//           '/joinus': (context) => JoinUs(),
//           '/registerphy': (context) => RegisterPhy(),
//         }
//         //home: MyHomePage(title: 'Flutter Demo Home Page'),
//         );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Widget _sizedbox() {
//     return SizedBox(
//       height: 10.0,
//     );
//   }

//   Widget _menuBtn(String title, String route) {
//     return SizedBox(
//       width: double.infinity,
//       child: Material(
//         color: primary,
//         borderRadius: BorderRadius.circular(15.0),
//         child: FlatButton(
//           onPressed: () {
//             Navigator.pushNamed(context, '/$route');
//           },
//           child: Text(
//             "$title",
//             style: TextStyle(color: Colors.white, fontFamily: defaultFont),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primary,
//         title: Text(widget.title),
//       ),
//       drawer: pharmacyDrawer(),
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[_sizedbox(), _menuBtn("Login", "login")],
//         ),
//       ),
//     );
//   }
// }
