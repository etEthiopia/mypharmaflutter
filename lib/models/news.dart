import 'package:flutter/material.dart';

class News {
  int id;
  String title;
  String description;
  String date;
  String image;
  int category;

  News(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.category,
      @required this.date,
      @required this.image});

  static List<News> generateNewsList(List<dynamic> newslist) {
    List<News> newsfetched = List<News>();

    for (var news in newslist) {
      // print(
      //   News(
      //         id: news['id'],
      //         title: news['title'],
      //         description: news['description'],
      //         category: news['category'],
      //         date: news['date'],
      //         image: news['image'])
      //     .toString());
      newsfetched.add(News(
          id: news['id'],
          title: news['title'],
          description: news['description'],
          category: news['category'],
          date: news['date'],
          image: news['image']));
    }
    return newsfetched;
  }

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      date: json['date'],
      image: json['image'],
    );
  }

  @override
  String toString() =>
      'News {id: $id, title: $title, description: $description, image: $image}';
}