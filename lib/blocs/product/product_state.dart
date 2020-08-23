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
  final List<String> productsList;

  MyProductLoaded({this.productsList});

  @override
  List<Object> get props => [productsList];
}

class ProductAllLoaded extends ProductState {}

class ProductUpdated extends ProductState {}

class ProductNotLoaded extends ProductState {}

class ProductFailure extends ProductState {
  final String error;

  ProductFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
