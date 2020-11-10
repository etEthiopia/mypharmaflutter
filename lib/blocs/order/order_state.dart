import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mypharma/models/models.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInital extends OrderState {}

class OrderLoading extends OrderState {}

class OrderNothingReceived extends OrderState {}

class OrderReceivedLoaded extends OrderState {
  final List<Order> receivedList;
  final int current;
  final int last;

  OrderReceivedLoaded({this.current, this.last, this.receivedList});

  @override
  List<Object> get props => [receivedList];
}

class OrderNothingSent extends OrderState {}

class OrderSentLoaded extends OrderState {
  final List<Order> sentList;
  final int current;
  final int last;

  OrderSentLoaded({this.current, this.last, this.sentList});

  @override
  List<Object> get props => [sentList];
}

class OrderRShow extends OrderState {
  final Order receivedOrder;

  OrderRShow({
    this.receivedOrder,
  });

  @override
  List<Object> get props => [receivedOrder];
}

class OrderStatusChanged extends OrderState {}

class OrderStatusNotChanged extends OrderState {}

class OrderAllLoaded extends OrderState {}

class OrderUpdated extends OrderState {}

class OrderNotLoaded extends OrderState {}

class OrderFailure extends OrderState {
  final String error;

  OrderFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
