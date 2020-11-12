import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mypharma/models/models.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInital extends ProductState {}

class ProductLoading extends ProductState {}

class MyProductLoaded extends ProductState {
  // final int current;
  // final int last;
  final List<Product> productsList;

  MyProductLoaded({this.productsList});

  @override
  List<Object> get props => [productsList];
}

class MyStockLoaded extends ProductState {
  // final int current;
  // final int last;
  final List<Product> productsList;

  MyStockLoaded({this.productsList});

  @override
  List<Object> get props => [productsList];
}

class ProductLoaded extends ProductState {
  final Product product;

  ProductLoaded({this.product});

  @override
  List<Object> get props => [product];
}

class ProductSearchLoading extends ProductState {}

class ProductSearchLoaded extends ProductState {
  final List<Product> productsList;

  ProductSearchLoaded({this.productsList});

  @override
  List<Object> get props => [productsList];
}

class ProductSearchEmpty extends ProductState {}

class ProductSearchReady extends ProductState {}

class ProductAllLoaded extends ProductState {}

class ProductUpdated extends ProductState {}

class ProductNotLoaded extends ProductState {}

class ProductFailure extends ProductState {
  final String error;

  ProductFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
