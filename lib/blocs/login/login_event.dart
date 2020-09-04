import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInWithEmailButtonPressed extends LoginEvent {
  final String email;
  final String password;
  final bool remember;

  LoginInWithEmailButtonPressed({
    @required this.email,
    @required this.password,
    @required this.remember,
  });

  @override
  List<Object> get props => [email, password];
}
