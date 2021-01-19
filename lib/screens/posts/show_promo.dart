import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mypharma/main.dart';

import '../../app_localizations.dart';

class ShowPromo extends StatefulWidget {
  final String title;
  final String image;
  final String content;
  final String author;
  final int id;

  const ShowPromo(
      {Key key, this.title, this.image, this.author, this.content, this.id})
      : super(key: key);

  @override
  _ShowPromoState createState() => _ShowPromoState();
}

class _ShowPromoState extends State<ShowPromo> {
  double padd = 10;

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

  Widget _image() {
    return Container(
      height: 200,
      child: loadimage(widget.image),
    );
  }

  Widget _sizedBox() {
    return SizedBox(
      height: 10,
    );
  }

  Widget _title() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      color: ThemeColor.darksecondBtn,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.title,
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontFamily: defaultFont)),
          Text(
              AppLocalizations.of(context).translate("by_text") +
                  " " +
                  widget.author,
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: ThemeColor.extralightText,
                  fontSize: 17,
                  fontFamily: defaultFont)),
        ],
      ),
    );
  }

  Widget _content() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          color: ThemeColor.background2,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(widget.content,
              style: TextStyle(
                  color: ThemeColor.darksecondText,
                  fontSize: 15,
                  fontFamily: defaultFont)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return Scaffold(
          appBar: cleanAppBar(title: widget.title),
          backgroundColor: ThemeColor.extralight,
          body: SafeArea(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  child: Material(
                      color: ThemeColor.background2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ThemeColor.background,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[_image()],
                              ),
                            ),
                            Expanded(
                                child: Container(
                                    child: ListView(children: <Widget>[
                              _title(),
                              _sizedBox(),
                              _content(),
                            ]))),
                          ],
                        ),
                      )))));
    } else {
      return Scaffold(
          appBar: cleanAppBar(title: widget.title),
          backgroundColor: ThemeColor.extralight,
          body: SafeArea(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Material(
                    color: ThemeColor.background2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeColor.background,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    _image(),
                                    _sizedBox(),
                                    SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            _title(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.all(20),
                                child: ListView(children: <Widget>[
                                  _content(),
                                ])),
                          )
                          // Expanded(child: _content()),
                          // _bottombar(),
                        ],
                      ),
                    ),
                  ))));
    }
  }
}
