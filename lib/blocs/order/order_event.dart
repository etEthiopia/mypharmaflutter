import 'package:equatable/equatable.dart';
import 'package:mypharma/models/models.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class OrderReceivedFetched extends OrderEvent {
  final int page;

  OrderReceivedFetched({this.page = 1});
}

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

class DashboardFetched extends OrderEvent {
  DashboardFetched();
}

class OrderBacked extends OrderEvent {}
