import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class OrderReceivedFetched extends OrderEvent {}

class OrderSentFetched extends OrderEvent {}

class OrderBacked extends OrderEvent {}
