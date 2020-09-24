import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mypharma/main.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class StockProduct extends StatefulWidget {
  StockProduct({
    Key key,
    this.id,
    this.image,
    this.name,
    this.description,
    this.price,
  }) : super(key: key);

  @override
  _StockProductState createState() => _StockProductState();
  final int id;
  final String image;
  final String name;
  final String description;
  final String price;
}

class _StockProductState extends State<StockProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: ThemeColor.background3,
          offset: const Offset(3.0, 3.0),
          blurRadius: 5.0,
          spreadRadius: 2.0,
        ),
      ], color: ThemeColor.background, borderRadius: BorderRadius.circular(10)),
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
                  "${widget.price} ETB",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: ThemeColor.darkText,
                      fontSize: 15,
                      fontFamily: defaultFont),
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
                        color: ThemeColor.darkText,
                        fontSize: 17,
                        fontFamily: defaultFont),
                  ),
                  Divider(
                    color: Colors.grey[300],
                    height: 10,
                  ),
                  Text(
                    "${widget.description}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ThemeColor.darksecondText,
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
            color: ThemeColor.extralightBtn,
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: new BoxDecoration(
                        border: Border.all(color: ThemeColor.darkText),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: ThemeColor.darkText,
                        size: 13,
                      )),
                ),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: new BoxDecoration(
                        border: Border.all(color: ThemeColor.darkText),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete,
                        color: ThemeColor.darkText,
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
  return CachedNetworkImage(
    imageUrl: '${SERVER_IP_FILE}news/$image',
    progressIndicatorBuilder: _progress,
    errorWidget: _error,
  );
}
