import 'package:cached_network_image/cached_network_image.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/screens/products/show_med_info.dart';
import 'package:mypharma/screens/products/show_product.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:mypharma/theme/font.dart';

Widget medProduct({int id, String title, String description, var context}) {
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
          tag: title + id.toString(),
          child: Material(
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                  child: GridTile(
                child: Container(
                    decoration: BoxDecoration(
                      color: ThemeColor.background2,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            ThemeColor.isDark ? Colors.black54 : Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                color: ThemeColor.darksecondText,
                                fontWeight: FontWeight.bold),
                          ),
                          description != null
                              ? Text(
                                  description,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ThemeColor.primaryText),
                                )
                              : Text(
                                  '',
                                  style: TextStyle(fontSize: 0),
                                ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(
                                width: double.infinity,
                                child: Material(
                                  elevation: 1,
                                  shadowColor: ThemeColor.light,
                                  color: ThemeColor.darkBtn,
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => ShowMedInfo(
                                                  id: id,
                                                )),
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate("read_more"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontFamily: defaultFont),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              )))));
}
