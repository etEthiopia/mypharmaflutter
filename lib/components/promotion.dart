import 'package:cached_network_image/cached_network_image.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/screens/products/show_product.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:flutter/material.dart';

import '../main.dart';

Widget promotion(
    {int id,
    String title,
    String description,
    String image,
    String profileimg,
    String author,
    String authorname,
    var context}) {
  return Container(
      margin: EdgeInsets.only(right: 5),
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
          tag: title + id.toString(),
          child: Material(
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                  child: GridTile(
                header: Container(
                  decoration: BoxDecoration(
                    color: ThemeColor.isDark ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),

                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10, bottom: 5),
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
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ThemeColor.darksecondText,
                            fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          author == '1'
                              ? Text(
                                  AppLocalizations.of(context)
                                      .translate("by_admin"),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: ThemeColor.primaryText),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                        ],
                      )
                    ],
                  ),
                ),
                child: Container(
                    padding: EdgeInsets.all(5),
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
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          color: ThemeColor.darksecondText,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).translate("read_more"),
                        textAlign: TextAlign.end,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            color: ThemeColor.primaryText,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              )))));
}

Widget _error(BuildContext context, String url, dynamic error) {
  print(error);
  return const Center(
      child: Icon(
    Icons.error,
    color: Colors.blueAccent,
  ));
}

Widget _progress(BuildContext context, String url, dynamic downloadProgress) {
  return Center(
      child: CircularProgressIndicator(value: downloadProgress.progress));
}

Widget loadimage(String image) {
  return CachedNetworkImage(
    imageUrl: '${SERVER_IP_FILE}news/$image',
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    ),
    progressIndicatorBuilder: _progress,
    errorWidget: _error,
  );
}
