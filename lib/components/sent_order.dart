import 'package:flutter/material.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class SentOrderCard extends StatefulWidget {
  SentOrderCard({
    Key key,
    this.o,
  }) : super(key: key);

  @override
  _SentOrderCardState createState() => _SentOrderCardState();

  Order o;
}

class _SentOrderCardState extends State<SentOrderCard> {
  selected() {
    setState(() {
      widget.o.selected = !widget.o.selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
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
                  widget.o.name == ""
                      ? (widget.o.groupTotal.toString() + " Items")
                      : widget.o.name,
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
                Text(
                  widget.o.receiver,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: ThemeColor.primaryText,
                      fontSize: 15,
                      fontFamily: defaultFont),
                ),
                Divider(
                  height: 5,
                  color: ThemeColor.extralightText,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.o.date,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ThemeColor.darkText,
                            fontSize: 12,
                            fontFamily: defaultFont),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Text(
                              AppLocalizations.of(context)
                                      .translate("quantity_text") +
                                  ": ",
                              style: TextStyle(
                                  color: ThemeColor.lightText,
                                  fontSize: 10,
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
                    ),
                    Expanded(
                      child: Text(
                        widget.o.price.toString() +
                            " " +
                            AppLocalizations.of(context).translate("etb_text"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ThemeColor.primaryText,
                            fontSize: 15,
                            fontFamily: defaultFont),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
