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

class OrderShowReceived extends OrderEvent {
  final int postid;
  final int id;

  OrderShowReceived({this.postid, this.id});
}

class OrderStatusChangeOrdered extends OrderEvent {
  final String status;
  final int id;

  OrderStatusChangeOrdered({this.status, this.id});
}

class OrderBacked extends OrderEvent {}
