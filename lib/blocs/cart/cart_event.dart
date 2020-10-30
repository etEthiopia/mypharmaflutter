import 'package:equatable/equatable.dart';
import 'package:mypharma/models/models.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartEvent {}

class CartAdd extends CartEvent {
  final int postid;

  CartAdd({this.postid});
}

class CartCount extends CartEvent {
  CartCount();
}

class CartItemUpdate extends CartEvent {
  final Cart cartItem;
  final bool increase;
  CartItemUpdate({this.cartItem, this.increase});
}

class CartFetched extends CartEvent {}

class CartItemDelete extends CartEvent {
  final Cart cartItem;
  CartItemDelete({this.cartItem});
}
