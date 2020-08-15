
import 'package:equatable/equatable.dart';

//import '../../models/models.dart';

abstract class InternetEvent extends Equatable {
  const InternetEvent();

  @override
  List<Object> get props => [];
}

class CheckInternet extends InternetEvent {}
