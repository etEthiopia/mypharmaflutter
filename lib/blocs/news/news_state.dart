import 'package:equatable/equatable.dart';

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
  dynamic newsList;

  NewsLoaded(this.current, this.last, this.newsList);

  @override
  List<Object> get props => [current, last, newsList];
}

class NewsUpdated extends NewsState {}

class NewsNotLoaded extends NewsState {}

class NewsFailure extends NewsState {}
