import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mypharma/models/models.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

class WishlistInital extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistNotLoaded extends WishlistState {}

class WishlistNothingReceived extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<Wishlist> wishlist;

  WishlistLoaded({this.wishlist});

  @override
  List<Object> get props => [wishlist];
}

class WishlistAdded extends WishlistState {}

class WishlistNotAdded extends WishlistState {}

class WishlistFailure extends WishlistState {
  final String error;

  WishlistFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
