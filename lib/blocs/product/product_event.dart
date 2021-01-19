import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class MyProductFetched extends ProductEvent {}

class ProductGetReady extends ProductEvent {}

class ProductSearched extends ProductEvent {
  final String text;
  final int id;

  ProductSearched({this.text, this.id});
}

class MedsInfoFetched extends ProductEvent {}

class MyStockFetched extends ProductEvent {}

class NewsBacked extends ProductEvent {}

class ProductDetailFetched extends ProductEvent {
  final int id;

  ProductDetailFetched({this.id});
}

class VendorFetched extends ProductEvent {
  final int id;

  VendorFetched({this.id});
}

class MedInfoDetailFetched extends ProductEvent {
  final int id;

  MedInfoDetailFetched({this.id});
}
