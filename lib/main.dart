import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mypharma/blocs/auth/bloc.dart';
import 'package:mypharma/screens/my_app.dart';
import 'package:mypharma/services/services.dart';

const SERVER_IP = 'http://192.168.1.2/mypharma/public/api';
const SERVER_IP_FILE = 'http://192.168.1.2/mypharma/public/storage/';
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
            ],
            child: MyApp(),
          )));
}

