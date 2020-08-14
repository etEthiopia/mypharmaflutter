import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../../models/models.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthNotAuthenticated extends AuthState {}

class Registered extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated({@required this.user});

  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
