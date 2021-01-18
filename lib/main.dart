import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mypharma/blocs/auth/bloc.dart';
import 'package:mypharma/blocs/wishlist/bloc.dart';
import 'package:mypharma/blocs/wishlist/wishlist_bloc.dart';
import 'package:mypharma/screens/my_app.dart';
import 'package:mypharma/services/services.dart';
import 'blocs/cart/bloc.dart';

const IP = 'http://192.168.1.3/mypharma/';
const SERVER_IP = IP + 'api';
const SERVER_IP_FILE = IP + 'public/storage/';
final storage = FlutterSecureStorage();
APIService apiService = APIService();

void main() {
  runApp(Phoenix(
    child:
        // Injects the Authentication serviceaaaaaaavvrrty
        RepositoryProvider<APIService>(
            create: (context) {
              return APIService();
            },
            // Injects the Authentication BLoC
            child: MultiBlocProvider(
              providers: [
                BlocProvider<AuthBloc>(
                  create: (context) {
                    final apiService =
                        RepositoryProvider.of<APIService>(context);
                    return AuthBloc(apiService)..add(AppLoaded());
                  },
                ),
                BlocProvider<WishlistBloc>(
                  create: (context) {
                    final apiService =
                        RepositoryProvider.of<APIService>(context);
                    return WishlistBloc(apiService);
                  },
                ),
                BlocProvider<CartBloc>(
                  create: (context) {
                    final apiService =
                        RepositoryProvider.of<APIService>(context);
                    return CartBloc(apiService);
                  },
                ),
              ],
              child: MyApp(),
            )),
  ));
}
