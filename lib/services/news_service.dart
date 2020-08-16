import 'dart:convert';

import 'package:mypharma/main.dart';
import 'package:mypharma/models/models.dart';
import 'package:http/http.dart' as http;

abstract class NewsServiceSkel {
  Future<List<dynamic>> fetchNews({int page = 1});
}

class NewsService extends NewsServiceSkel {
  @override
  Future<List<dynamic>> fetchNews({int page = 1}) async {
    String news = "news";
    if (page != 1) {
      news += "?page=$page";
    }

    var res = await http.post(
      "$SERVER_IP/$news",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 20));

    if (res.statusCode == 200) {
      if (res.body != null) {
        if (json.decode(res.body)['sucess']) {
          //print(json.decode(res.body)['0']['news']['data']);
          List<News> news =
              News.generateNewsList(json.decode(res.body)['0']['news']['data']);
          int from = json.decode(res.body)['0']['news']['from'];
          int last = json.decode(res.body)['0']['news']['last_page'];
          List<dynamic> result = [news, from, last];
          return result;
        } else {
          print('Wrong Request');
          throw Exception();
        }
      } else {
        print('Wrong Question');
        throw Exception();
      }
    } else {
      print('Wrong Connection');
      throw Exception();
    }
  }
}
