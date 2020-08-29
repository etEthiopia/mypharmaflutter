import 'package:flutter/material.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

Widget order({
  int id,
  int quantity,
  double price,
  String status,
  String date,
  String name,
  String vender,
}) {
  return Container(
    height: 110,
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: extralight.withOpacity(0.5),
            offset: const Offset(0.0, 3.0),
            blurRadius: 3.0,
            spreadRadius: 1.5,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: dark, fontSize: 15, fontFamily: defaultFont),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                vender,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: primary, fontSize: 15, fontFamily: defaultFont),
              ),
              Divider(
                height: 5,
                color: extralight,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: dark, fontSize: 12, fontFamily: defaultFont),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text("Quantity: ",
                            style: TextStyle(
                                color: light,
                                fontSize: 10,
                                fontFamily: defaultFont)),
                        Text(
                          quantity.toString(),
                          style: TextStyle(
                              color: darksecond,
                              fontSize: 12,
                              fontFamily: defaultFont),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Status",
                            style: TextStyle(
                                color: light,
                                fontSize: 10,
                                fontFamily: defaultFont)),
                        Text(
                          status,
                          style: TextStyle(
                              color: darksecond,
                              fontSize: 15,
                              fontFamily: defaultFont),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      price.toString() + " ETB",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: primary,
                          fontSize: 15,
                          fontFamily: defaultFont),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        VerticalDivider(
          width: 5,
          color: extralight,
        ),
        Container(
          padding: EdgeInsets.only(left: 5),
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
                      Icons.view_headline,
                      color: dark,
                      size: 13,
                    )),
              ),
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
        ),
      ],
    ),
  );
}
