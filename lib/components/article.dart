import 'package:cached_network_image/cached_network_image.dart';
import 'package:mypharma/main.dart';
import 'package:mypharma/screens/posts/showarticle.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';
import 'package:flutter/material.dart';

Widget article(
    {String title,
    String content,
    String image,
    String time,
    String category,
    int id,
    var context}) {
  void showArticle() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ShowArticle(
                title: title,
                image: image,
                time: time,
                content: content,
                id: id,
                category: category,
              )),
    );
  }

  return Container(
    margin: EdgeInsets.all(5),
    child: Hero(
        tag: id,
        child: Container(
            decoration: BoxDecoration(
              color: ThemeColor.background,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: ThemeColor.background1,
                  offset: const Offset(0.0, 3.0),
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            //descriptioin
            child: InkWell(
                onTap: () {
                  showArticle();
                },
                child: GridTile(
                  header: Container(
                      child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 7.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: ThemeColor.darksecondText,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showArticle();
                            },
                            child: Text(
                              time,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: ThemeColor.primaryText,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                  child: InkWell(
                    onTap: () {
                      showArticle();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.maxFinite,
                            color: ThemeColor.background3,
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 30, bottom: 5),
                            child: Text(
                              content,
                              maxLines: 3,
                              style: TextStyle(
                                  color: ThemeColor.contrastText,
                                  fontSize: 15,
                                  fontFamily: defaultFont),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                  // image: DecorationImage(
                                ),
                                child: loadimage(image)),
                          )
                        ],
                      ),
                    ),
                  ),
                  footer: Container(
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Category  ",
                                        style: TextStyle(
                                            color: dark,
                                            fontSize: 8,
                                            fontFamily: defaultFont)),
                                    Text(category,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: dark,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            fontFamily: defaultFont))
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {},
                              color: darksecond,
                            ),
                          ],
                        ),
                      )),
                )))),
  );
}

Widget _error(BuildContext context, String url, dynamic error) {
  print(error);
  return const Center(
      child: Icon(
    Icons.error,
  ));
}

Widget _progress(BuildContext context, String url, dynamic downloadProgress) {
  return Center(
      child: CircularProgressIndicator(value: downloadProgress.progress));
}

Widget loadimage(String image) {
  return CachedNetworkImage(
    imageUrl: '${SERVER_IP_FILE}news/$image',
    progressIndicatorBuilder: _progress,
    errorWidget: _error,
  );
}
