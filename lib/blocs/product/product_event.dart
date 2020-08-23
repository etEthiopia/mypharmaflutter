import 'package:equatable/equatable.dart';
import 'package:mypharma/models/models.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class MyProductFetched extends ProductEvent {
  MyProductFetched();
}

class NewsBacked extends ProductEvent {}
