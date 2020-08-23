import 'package:flutter/material.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';

class NewProducts extends StatefulWidget {
  @override
  _NewProductsState createState() => _NewProductsState();
}

class _NewProductsState extends State<NewProducts> {
  int col = 0;
  void _colFix(bool por) {
    if (por) {
      setState(() {
        col = 2;
      });
    } else {
      setState(() {
        col = 4;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      _colFix(true);
    } else {
      _colFix(false);
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: simpleAppBar(title: "New Products"),
      drawer: UserDrawer(),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0), child: Text("")
            // GridView.builder(
            //   itemCount: newproductsList.length,
            //   gridDelegate:
            //       SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: col),
            //   itemBuilder: (BuildContext context, int index) {
            //     return product(
            //       name: newproductsList[index]["name"],
            //       image: newproductsList[index]["image"],
            //       org: newproductsList[index]["org"],
            //       price: newproductsList[index]["price"],
            //     );
            //   },
            // ),
            ),
      ),
    );
  }
}
