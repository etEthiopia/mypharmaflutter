import 'package:equatable/equatable.dart';
import 'package:mypharma/models/models.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class WishlistInitial extends WishlistEvent {}

class WishlistAdd extends WishlistEvent {
  final Wishlist newwish;

  WishlistAdd({this.newwish});
}

class WishlistCount extends WishlistEvent {
  final int count;
  WishlistCount({this.count = 0});
}

class WishlistFetched extends WishlistEvent {}

class WishlistDelete extends WishlistEvent {
  final int id;
  WishlistDelete({this.id});
}
