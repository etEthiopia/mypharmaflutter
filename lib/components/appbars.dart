import 'package:mypharma/theme/colors.dart';
import 'package:flutter/material.dart';

AppBar simpleAppBar({String title}) {
  return AppBar(
    backgroundColor: primary,
    title: Text(
      title,
      style: TextStyle(color: Colors.white),
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.search),
        color: Colors.white,
        onPressed: () {},
      )
    ],
  );
}

AppBar cleanAppBar({String title}) {
  return AppBar(
    backgroundColor: primary,
    title: Text(
      title,
      style: TextStyle(color: Colors.white),
    ),
  );
}

AppBar companyAppBar({String title}) {
  return AppBar(
    elevation: 0,
    backgroundColor: primary,
    centerTitle: true,
    title: Container(
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Icon(
          Icons.verified_user,
          color: Colors.white,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(color: Colors.white),
        ),
      ]),
    ),
    actions: <Widget>[
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.verified_user),
        color: primary,
      ),
      Padding(
        padding: EdgeInsets.only(right: 10),
      )
    ],
  );
}
