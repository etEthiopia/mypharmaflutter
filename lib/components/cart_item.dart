import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/cart/bloc.dart';
import 'package:mypharma/main.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';
import 'package:flutter/material.dart';

class CartItem extends StatefulWidget {
  CartItem(
      {Key key,
      this.id,
      this.name,
      String udate,
      this.picture,
      this.price,
      this.amount,
      this.prodId,
      this.context})
      : super(key: key) {
    if (udate.length > 12) {
      if (udate.substring(0, 4) == DateTime.now().year.toString() &&
          udate.substring(5, 7) == DateTime.now().month.toString() &&
          udate.substring(8, 10) == DateTime.now().day.toString()) {
        this.date = udate.substring(11);
      } else {
        this.date = udate;
      }
    } else {
      this.date = udate;
    }
  }

  @override
  _CartItemState createState() => _CartItemState();

  final int id;
  final String name;
  String date;
  String picture;
  final double price;
  final int prodId;
  final int amount;
  final dynamic context;
}

class _CartItemState extends State<CartItem> {
  var _cartBloc;

  @override
  void initState() {
    setState(() {
      _cartBloc = BlocProvider.of<CartBloc>(context);
    });
    super.initState();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeColor.background,
          title: Text(
              AppLocalizations.of(context)
                  .translate("confirmation_dialog_title"),
              style: TextStyle(
                color: ThemeColor.contrastText,
              )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    AppLocalizations.of(context)
                        .translate("confirmation_dialog_text12"),
                    style: TextStyle(
                      color: ThemeColor.contrastText,
                    )),
                Text(
                    AppLocalizations.of(context)
                        .translate("confirmation_dialog_text2"),
                    style: TextStyle(
                      color: ThemeColor.contrastText,
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: ThemeColor.background,
              child: Text(
                AppLocalizations.of(context).translate("cancel_btn_text"),
                style: TextStyle(color: ThemeColor.primaryText),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: ThemeColor.background,
              child: Text(
                AppLocalizations.of(context).translate("yes_btn_text"),
                style: TextStyle(color: ThemeColor.darkText),
              ),
              onPressed: () {
                //final _cartBloc = BlocProvider.of<CartBloc>(context);
                _cartBloc.add(CartItemDelete(
                    cartItem: Cart(
                  id: widget.id,
                  postId: widget.prodId,
                  quantity: widget.amount,
                  date: "",
                  name: "",
                  price: widget.price,
                )));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: ThemeColor.background3,
          offset: const Offset(3.0, 3.0),
          blurRadius: 5.0,
          spreadRadius: 2.0,
        ),
      ], color: ThemeColor.card, borderRadius: BorderRadius.circular(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: <Widget>[
                Container(
                  height: 60,
                  width: 60,
                  child: loadimage(widget.picture),
                  decoration: BoxDecoration(
                      //color: Colors.green,
                      borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
                ),
                // Container(
                //     height: 60,
                //     width: 60,
                //     decoration: BoxDecoration(
                //         //color: Colors.green,
                //         image: DecorationImage(
                //             fit: BoxFit.cover,
                //             image: AssetImage(
                //               "assets/images/logo/logo50.png",
                //             )),
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(5),
                //         )),
                //     child: Text("")),
                Container(
                  child: Text(
                    "${widget.date}",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ThemeColor.darkText,
                        fontSize: 10,
                        fontFamily: defaultFont),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${widget.name}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ThemeColor.darksecondText,
                        fontSize: 17,
                        fontFamily: defaultFont),
                  ),
                  Divider(
                    color: ThemeColor.background1,
                    height: 10,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 25,
                          ),
                        ),
                        onTap: () {
                          _showMyDialog();
                        },
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate("price_text"),
                                  style: TextStyle(
                                      color: ThemeColor.darkText,
                                      fontSize: 10,
                                      fontFamily: defaultFont),
                                ),
                                Text(
                                  "${widget.price / double.parse(widget.amount.toString())} ${AppLocalizations.of(context).translate("etb_text")}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: ThemeColor.darksecondText,
                                      fontSize: 14,
                                      fontFamily: defaultFont),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate("total_text"),
                                  style: TextStyle(
                                      color: ThemeColor.darkText,
                                      fontSize: 10,
                                      fontFamily: defaultFont),
                                ),
                                Text(
                                  "${widget.price} ${AppLocalizations.of(context).translate("etb_text")}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: ThemeColor.darksecondText,
                                      fontSize: 14,
                                      fontFamily: defaultFont),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Icon(
                  Icons.arrow_drop_up,
                  size: 30,
                  color: ThemeColor.contrastText,
                ),
                onTap: () {
                  //final _cartBloc = BlocProvider.of<CartBloc>(context);
                  print("increase");

                  _cartBloc.add(CartItemUpdate(
                      cartItem: Cart(
                        id: widget.id,
                        postId: widget.prodId,
                        quantity: widget.amount,
                        date: "",
                        name: "",
                        price: widget.price,
                      ),
                      increase: true));
                },
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "${widget.amount}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: ThemeColor.darksecondText,
                    fontSize: 17,
                    fontFamily: defaultFont),
              ),
              SizedBox(
                height: 5,
              ),
              InkWell(
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 30,
                  color: ThemeColor.contrastText,
                ),
                onTap: () {
                  print("decrease");
                  //final _cartBloc = BlocProvider.of<CartBloc>(context);
                  _cartBloc.add(CartItemUpdate(
                      cartItem: Cart(
                        id: widget.id,
                        postId: widget.prodId,
                        quantity: widget.amount,
                        date: "",
                        name: "",
                        price: widget.price,
                      ),
                      increase: false));
                },
              ),
            ],
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
