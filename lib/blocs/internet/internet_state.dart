import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class InternetState extends Equatable {
  const InternetState();

  @override
  List<Object> get props => [];
}

class InternetInitial extends InternetState {}

class InternetChecking extends InternetState {}

class NotConnected extends InternetState {}

class Connected extends InternetState {}

class InternetFailure extends InternetState {
  final String error;

  InternetFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
