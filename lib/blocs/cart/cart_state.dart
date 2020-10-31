import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mypharma/models/models.dart';

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object> get props => [];
}

class CartInital extends CartState {}

class CartLoading extends CartState {}

class CartNotLoaded extends CartState {}

class CartNothingReceived extends CartState {}

class CartCounted extends CartState {
  CartCounted();
}

class CartLoaded extends CartState {
  final List<Cart> cartItems;

  CartLoaded({this.cartItems});

  @override
  List<Object> get props => [cartItems];
}

class CartUpdated extends CartState {
  final List<Cart> cartItems;

  CartUpdated({this.cartItems});

  @override
  List<Object> get props => [cartItems];
}

class CartAdded extends CartState {}

class CartNotAdded extends CartState {}

class CartFailure extends CartState {
  final String error;

  CartFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
