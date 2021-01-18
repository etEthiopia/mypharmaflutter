import 'package:flutter/material.dart';

class Promo {
  int id;
  String title;
  String description;
  String profileimg;
  String authorname;
  String author;
  String image;
  int viewer;

  Promo(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.authorname,
      @required this.author,
      @required this.profileimg,
      @required this.viewer,
      @required this.image});

  static List<Promo> generatePromoList(List<dynamic> newslist) {
    List<Promo> newsfetched = List<Promo>();

    for (var news in newslist) {
      newsfetched.add(Promo(
          id: news['id'],
          title: news['title'],
          description: news['descriptioin'],
          authorname: news['name'],
          profileimg: news['profileimg'],
          author: news['author'].toString(),
          viewer: news['viewer'],
          image: news['thumb']));
    }
    return newsfetched;
  }

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
        id: json['id'],
        title: json['title'],
        description: json['descriptioin'],
        authorname: json['name'],
        profileimg: json['profileimg'],
        author: json['author'].toString(),
        viewer: json['viewer'],
        image: json['thumb']);
  }

  @override
  String toString() =>
      'Promo {id: $id, title: $title, description: $description, image: $image}';
}
