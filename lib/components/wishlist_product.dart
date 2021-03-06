import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/cart/bloc.dart';
import 'package:mypharma/blocs/wishlist/bloc.dart';
import 'package:mypharma/components/show_success.dart';
import 'package:mypharma/main.dart';
import 'package:mypharma/models/wishlist.dart';
import 'package:mypharma/screens/products/show_product.dart';
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
      this.postid,
      this.context,
      this.vendorname,
      this.isSelected})
      : super(key: key);

  @override
  _WishlistProductState createState() => _WishlistProductState();
  //Wishlist item;
  final int id;
  final String image;
  final String name;
  final String slug;
  final int quantity;
  final int vendor;
  final int postid;
  final dynamic context;
  final String vendorname;
  final ValueChanged<bool> isSelected;
}

class _WishlistProductState extends State<WishlistProduct> {
  bool selected = false;
  selectedChanged() {
    setState(() {
      widget.isSelected(!this.selected);
      this.selected = !this.selected;
    });
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
                final _wishlistBloc = BlocProvider.of<WishlistBloc>(context);
                _wishlistBloc.add(WishlistDelete(id: widget.id));
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
      ], color: ThemeColor.card, borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 60,
                  width: 60,
                  child: InkWell(
                    child: loadimage(widget.image),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ShowProduct(
                                  id: widget.postid,
                                  isProduct: false,
                                )),
                      );
                    },
                  ),
                  decoration: BoxDecoration(
                      //color: Colors.green,
                      borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
                ),
                // Text(
                //   AppLocalizations.of(context)
                //           .translate("quantity_short_text") +
                //       ": ${widget.quantity}",
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                //   style: TextStyle(
                //       color: ThemeColor.darkText,
                //       fontSize: 15,
                //       fontFamily: defaultFont),
                // ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ShowProduct(
                                  id: widget.postid,
                                  isProduct: false,
                                )),
                      );
                    },
                    child: Text(
                      "${widget.name}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: ThemeColor.darkText,
                          fontSize: 17,
                          fontFamily: defaultFont),
                    ),
                  ),
                  Divider(
                    color: ThemeColor.background1,
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context).translate("from_text") +
                        ": ${widget.vendorname}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ThemeColor.darksecondText,
                        fontSize: 12,
                        fontFamily: defaultFont),
                  ),
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
                  child: InkWell(
                      onTap: () {
                        final _cartBloc = BlocProvider.of<CartBloc>(context);

                        _cartBloc.add(CartAdd(postid: widget.postid));
                        // Navigator.of(context).pop();

                        showSucess("Wishlist has been added to cart", context);
                        // Future.delayed(Duration(seconds: 3));
                        // Navigator.pushReplacementNamed(
                        //     context, 'my_cart');
                      },
                      child: Icon(
                        Icons.shopping_cart,
                        color: ThemeColor.darkText,
                        size: 19,
                      )

                      // Container(
                      //     padding: const EdgeInsets.all(5.0),
                      //     decoration: new BoxDecoration(
                      //       border: Border.all(color: ThemeColor.darkText),
                      //       shape: BoxShape.circle,
                      //     ),
                      //     child: Icon(
                      //       Icons.shopping_cart,
                      //       color: ThemeColor.darkText,
                      //       size: 14,
                      //     )),
                      ),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  width: 20,
                  child: Checkbox(
                    value: this.selected,
                    activeColor: ThemeColor.dark,
                    onChanged: (current) {
                      selectedChanged();
                    },
                  ),
                )),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _showMyDialog();
                    },
                    child: Icon(
                      Icons.delete,
                      color: ThemeColor.darkText,
                      size: 19,
                    ),
                  ),
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
    progressIndicatorBuilder: _progress,
    errorWidget: _error,
  );
}
