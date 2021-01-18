import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/order/bloc.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/screens/orders/order_detail.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class OrderColCard extends StatefulWidget {
  OrderColCard({Key key, this.received, this.o, this.page}) : super(key: key);

  @override
  _OrderColCardState createState() => _OrderColCardState();

  final Order o;
  final int page;
  final bool received;
}

class _OrderColCardState extends State<OrderColCard> {
  selected() {
    setState(() {
      widget.o.selected = !widget.o.selected;
    });
  }

  var _orderBloc;

  @override
  void initState() {
    _orderBloc = BlocProvider.of<OrderBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("clicked");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => OrderDetail(
                      postid: widget.o.postid,
                      id: widget.o.id,
                      selectedCategory: widget.o.status,
                    ))).then((value) {
          print("SELECTED CATEGORY: " + value.toString());

          if (value != null) {
            _orderBloc.add(OrderReceivedFetched(page: widget.page));
          }
          return true;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: ThemeColor.background3,
                offset: const Offset(0.0, 3.0),
                blurRadius: 3.0,
                spreadRadius: 1.5,
              ),
            ],
            color: ThemeColor.card,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.o.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ThemeColor.darkText,
                        fontSize: 15,
                        fontFamily: defaultFont),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.o.price.toStringAsFixed(2) +
                            " " +
                            AppLocalizations.of(context).translate("etb_text"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ThemeColor.primaryText,
                            fontSize: 15,
                            fontFamily: defaultFont),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              print("clicked");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          OrderDetail(
                                            postid: widget.o.postid,
                                            id: widget.o.id,
                                            selectedCategory: widget.o.status,
                                          ))).then((value) {
                                print("SELECTED CATEGORY: " + value.toString());
                                if (value != null) {
                                  _orderBloc.add(
                                      OrderReceivedFetched(page: widget.page));
                                }

                                return true;
                              });
                            },
                            child: Text(
                              "INVOICE >>",
                              style: TextStyle(
                                  color: ThemeColor.darksecondText,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: defaultFont),
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    height: 5,
                    color: ThemeColor.extralightText,
                  ),
                  Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                              AppLocalizations.of(context)
                                      .translate("quantity_text") +
                                  ": ",
                              style: TextStyle(
                                  color: ThemeColor.lightText,
                                  fontSize: 12,
                                  fontFamily: defaultFont)),
                          Text(
                            widget.o.quantity.toString(),
                            style: TextStyle(
                                color: ThemeColor.darksecondText,
                                fontSize: 12,
                                fontFamily: defaultFont),
                          )
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    AppLocalizations.of(context)
                                        .translate("status_text"),
                                    style: TextStyle(
                                        color: ThemeColor.lightText,
                                        fontSize: 10,
                                        fontFamily: defaultFont)),
                                Text(
                                  widget.o.status,
                                  style: TextStyle(
                                      color: ThemeColor.darksecondText,
                                      fontSize: 15,
                                      fontFamily: defaultFont),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            !widget.received
                ? VerticalDivider(
                    width: 5,
                    color: extralight,
                  )
                : Container(),
            Container(
                padding: EdgeInsets.only(left: 5),
                child: !widget.received
                    ? Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: new BoxDecoration(
                                  border:
                                      Border.all(color: ThemeColor.darkText),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.view_headline,
                                  color: ThemeColor.darkText,
                                  size: 13,
                                )),
                          ),
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: new BoxDecoration(
                                  border:
                                      Border.all(color: ThemeColor.darkText),
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
                                  border:
                                      Border.all(color: ThemeColor.darkText),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: ThemeColor.darkText,
                                  size: 13,
                                )),
                          ),
                        ],
                      )
                    : Container(
                        // width: 20,
                        // child: Checkbox(
                        //   value: widget.o.selected,
                        //   activeColor: dark,
                        //   onChanged: (current) {
                        //     selected();
                        //   },
                        // ),
                        )),
          ],
        ),
      ),
    );
  }
}
