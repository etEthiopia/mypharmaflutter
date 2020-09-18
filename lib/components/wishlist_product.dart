import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mypharma/main.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class WishlistProduct extends StatefulWidget {
  WishlistProduct(
      {Key key,
      this.id,
      this.image,
      this.name,
      this.slug,
      this.quantity,
      this.vendor,
      this.postid})
      : super(key: key);

  @override
  _WishlistProductState createState() => _WishlistProductState();
  final int id;
  final String image;
  final String name;
  final String slug;
  final int quantity;
  final int vendor;
  final int postid;
  bool selected = false;
}

class _WishlistProductState extends State<WishlistProduct> {
  selected() {
    setState(() {
      widget.selected = !widget.selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey[300],
          offset: const Offset(3.0, 3.0),
          blurRadius: 5.0,
          spreadRadius: 2.0,
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 60,
                  width: 60,
                  child: loadimage(widget.image),
                  decoration: BoxDecoration(
                      //color: Colors.green,
                      borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
                ),
                Text(
                  "Qty: ${widget.quantity}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: dark, fontSize: 15, fontFamily: defaultFont),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${widget.name}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: dark, fontSize: 17, fontFamily: defaultFont),
                  ),
                  Divider(
                    color: Colors.grey[300],
                    height: 10,
                  ),
                  Text(
                    "From: ${widget.vendor} Company",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: darksecond,
                        fontSize: 12,
                        fontFamily: defaultFont),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
          VerticalDivider(
            width: 5,
            color: extralight,
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: new BoxDecoration(
                        border: Border.all(color: dark),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: dark,
                        size: 13,
                      )),
                ),
                Expanded(
                    child: Container(
                  width: 20,
                  child: Checkbox(
                    value: widget.selected,
                    activeColor: dark,
                    onChanged: (current) {
                      selected();
                    },
                  ),
                )),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: new BoxDecoration(
                        border: Border.all(color: dark),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete,
                        color: dark,
                        size: 13,
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
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
  int x = Random().nextInt(1);
  String xls;
  if (x == 0) {
    xls = '2020051709054556487.jpg';
  } else {
    xls = '2020052114332425361.jpg';
  }
  return CachedNetworkImage(
    imageUrl: '${SERVER_IP_FILE}news/$xls',
    progressIndicatorBuilder: _progress,
    errorWidget: _error,
  );
}
