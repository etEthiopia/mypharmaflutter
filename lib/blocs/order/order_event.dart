import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class OrderReceivedFetched extends OrderEvent {}

class OrderSentFetched extends OrderEvent {
  final int page;

  OrderSentFetched({this.page = 1});
}

class OrderBacked extends OrderEvent {}
