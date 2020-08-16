import 'package:equatable/equatable.dart';
import 'package:mypharma/models/models.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class NewsFetched extends NewsEvent {
  final int page;

  NewsFetched({this.page = 1});
}

class NewsBacked extends NewsEvent {}
