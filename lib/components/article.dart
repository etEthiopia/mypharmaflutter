import 'package:cached_network_image/cached_network_image.dart';
import 'package:mypharma/main.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';
import 'package:flutter/material.dart';

Widget article({String title, String content, String image, String time}) {
  return Container(
      margin: EdgeInsets.all(5),
      child: Hero(
          tag: title + time,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    offset: const Offset(0.0, 3.0),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              //descriptioin
              child: InkWell(
                  onTap: () {},
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
                                    color: darksecond,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              time,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )),
                    child: Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.maxFinite,
                            color: Colors.grey[50],
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 30, bottom: 5),
                            child: Text(
                              content,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 15, fontFamily: defaultFont),
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
                                  //     fit: BoxFit.cover,
                                  //     image: AssetImage(
                                  //       "${SERVER_IP_FILE}news/$image",
                                  //     ))
                                ),
                                child: loadimage(image)),
                          )
                        ],
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
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.thumb_up,
                                          color: dark,
                                        ),
                                        onPressed: () {},
                                      ),
                                      Text("15",
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
                  )))));
}

Widget _error(BuildContext context, String url, dynamic error) {
  print(error);
  return const Center(child: Icon(Icons.error));
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
