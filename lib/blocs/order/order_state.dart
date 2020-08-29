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

class OrderReceivedLoaded extends OrderState {
  final List<Order> receivedList;

  OrderReceivedLoaded({this.receivedList});

  @override
  List<Object> get props => [receivedList];
}

class OrderAllLoaded extends OrderState {}

class OrderUpdated extends OrderState {}

class OrderNotLoaded extends OrderState {}

class OrderFailure extends OrderState {
  final String error;

  OrderFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
