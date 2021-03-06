import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mypharma/models/models.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInital extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final int current;
  final int last;
  final List<News> newsList;
  final List<Promo> promos;

  NewsLoaded({this.last, this.current, this.newsList, this.promos});

  @override
  List<Object> get props => [current, last, newsList, promos];
}

class NewsAllLoaded extends NewsState {}

class NewsUpdated extends NewsState {}

class NewsNotLoaded extends NewsState {}

class NewsFailure extends NewsState {
  final String error;

  NewsFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
