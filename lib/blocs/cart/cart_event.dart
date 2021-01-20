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

class CartAddBatch extends CartEvent {
  final List<int> postids;
  CartAddBatch({this.postids});
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

class CartCheckout extends CartEvent {}

class CartOrder extends CartEvent {
  final bool addressChange;
  final Address address;
  final String note;
  final String landmark;
  final String city;
  final String phone;
  final String payment;

  CartOrder(
      {this.addressChange,
      this.address,
      this.note,
      this.landmark,
      this.city,
      this.phone,
      this.payment});

  @override
  List<Object> get props =>
      [addressChange, address, note, landmark, city, phone];
}

class CartItemDelete extends CartEvent {
  final Cart cartItem;
  CartItemDelete({this.cartItem});
}
