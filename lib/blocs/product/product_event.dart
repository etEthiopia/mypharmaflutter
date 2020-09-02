import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class MyProductFetched extends ProductEvent {}

class MyStockFetched extends ProductEvent {}

class NewsBacked extends ProductEvent {}

class ProductDetailFetched extends ProductEvent {
  final int id;

  ProductDetailFetched({this.id});
}
