import 'package:flutter/material.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class OrderCard extends StatefulWidget {
  OrderCard({
    Key key,
    this.received,
    this.o,
  }) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();

  Order o;

  final bool received;
  bool expanded = false;
}

class _OrderCardState extends State<OrderCard> {
  selected() {
    setState(() {
      widget.o.selected = !widget.o.selected;
    });
  }

  String generatename() {
    bool por = false;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      por = true;
    }
    String name;
    int ln = 0;

    if (por) {
      ln = 15;
    } else {
      ln = 35;
    }
    if (widget.o.name.length <= ln) {
      name = widget.o.name +
          " & " +
          (widget.o.groupTotal - 1).toString() +
          " " +
          AppLocalizations.of(context).translate("more");
    } else {
      name = widget.o.name.substring(0, ln - 5) +
          "..."
              " & " +
          (widget.o.groupTotal - 1).toString() +
          " " +
          AppLocalizations.of(context).translate("more");
    }

    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                Row(
                  children: [
                    Text(
                      widget.o.groupTotal > 1 ? generatename() : widget.o.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: ThemeColor.darkText,
                          fontSize: 15,
                          fontFamily: defaultFont),
                    ),
                    InkWell(
                        child: widget.expanded
                            ? Icon(
                                Icons.arrow_drop_up,
                                color: ThemeColor.darkText,
                              )
                            : Icon(
                                Icons.arrow_drop_down,
                                color: ThemeColor.darkText,
                              ),
                        onTap: () {
                          setState(() {
                            widget.expanded = !widget.expanded;
                          });
                        }),
                  ],
                ),
                Text(
                  widget.received ? widget.o.sender : widget.o.receiver,
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
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.o.date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: ThemeColor.darkText,
                              fontSize: 12,
                              fontFamily: defaultFont),
                        ),
                        Text(
                          widget.o.price.toString() +
                              " " +
                              AppLocalizations.of(context)
                                  .translate("etb_text"),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: ThemeColor.primaryText,
                              fontSize: 15,
                              fontFamily: defaultFont),
                        ),
                      ],
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
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
                                border: Border.all(color: ThemeColor.darkText),
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
    );
  }
}
