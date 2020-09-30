import 'package:cached_network_image/cached_network_image.dart';
import 'package:mypharma/screens/products/show_product.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:flutter/material.dart';

import '../main.dart';

Widget product(
    {int id,
    String name,
    String image,
    String org,
    String price,
    var context}) {
  return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.background1,
            offset: const Offset(3.0, 3.0),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Hero(
          tag: name + id.toString(),
          child: Material(
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                  child: GridTile(
                child: Container(
                    decoration: BoxDecoration(
                      color: ThemeColor.background1,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: loadimage(image)),
                footer: Container(
                  decoration: BoxDecoration(
                    color: ThemeColor.isDark ? Colors.black54 : Colors.white70,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),

                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  // child: Text(
                  //   name,
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(
                  //       fontSize: 15,
                  //       color: darksecond,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            color: ThemeColor.darksecondText,
                            fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          org != null
                              ? Text(
                                  org,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: ThemeColor.primaryText),
                                )
                              : Text(
                                  '',
                                  style: TextStyle(fontSize: 0),
                                ),
                          Text(
                            price + " ETB",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: ThemeColor.darksecondText),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
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
