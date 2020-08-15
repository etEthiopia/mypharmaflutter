// lib/blocs/auth/Auth_event.dart
import 'package:mypharma/models/user.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

//import '../../models/models.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Fired just after the app is launched
class AppLoaded extends AuthEvent {}

// Fired when a user has successfully logged in
class UserLoggedIn extends AuthEvent {
  final User user;

  UserLoggedIn({@required this.user});

  @override
  List<Object> get props => [user];
}

// Fired when a user has successfully signed up
class UserRegistered extends AuthEvent {
  final User user;

  UserRegistered({@required this.user});

  @override
  List<Object> get props => [user];
}

// Fired when the user has logged out
class UserLoggedOut extends AuthEvent {}
