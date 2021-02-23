import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mypharma/main.dart';

class ShowArticle extends StatefulWidget {
  final String title;
  final String image;
  final String content;
  final String time;
  final String category;
  final int id;

  const ShowArticle(
      {Key key,
      this.title,
      this.image,
      this.content,
      this.time,
      this.category,
      this.id})
      : super(key: key);

  @override
  _ShowArticleState createState() => _ShowArticleState();
}

class _ShowArticleState extends State<ShowArticle> {
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

  Widget _bottombar() {
    return Container(
      decoration: BoxDecoration(
          color: ThemeColor.darkBtn,
          border: Border.symmetric(
              vertical: BorderSide(color: ThemeColor.lightBtn))),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[Expanded(child: _category())],
            ),
          ),
          Row(children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.error,
                color: ThemeColor.extralightText,
              ),
              onPressed: () {},
            ),
          ]),
        ],
      ),
    );
  }

  Widget _sizedBox() {
    return SizedBox(
      height: 10,
    );
  }

  Widget _title() {
    return Text(widget.title,
        style: TextStyle(
            color: ThemeColor.darksecondText,
            fontSize: 20,
            fontFamily: defaultFont));
  }

  Widget _category() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Category: ",
            style: TextStyle(
                color: ThemeColor.lightText,
                fontSize: 10,
                fontFamily: defaultFont)),
        Text(widget.category.toString() + "asdfasfsadfafpp",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: ThemeColor.primaryText,
                fontSize: 15,
                fontFamily: defaultFont)),
      ],
    );
  }

  Widget _time() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(widget.time,
            style: TextStyle(
                color: ThemeColor.primaryText,
                fontSize: 10,
                fontFamily: defaultFont)),
      ],
    );
  }

  Widget _suggestEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          child: Icon(
            Icons.edit,
            color: ThemeColor.darkText,
            size: 10,
          ),
        ),
        InkWell(
          child: SizedBox(
            width: 5,
          ),
        ),
        InkWell(
            child: Text(
          "Contribute on the Content",
          style: TextStyle(
              fontSize: 10,
              color: ThemeColor.darkText,
              fontFamily: defaultFont),
        )),
      ],
    );
  }

  Widget _content() {
    return Container(
      color: ThemeColor.background2,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(widget.content,
          style: TextStyle(
              color: ThemeColor.darksecondText,
              fontSize: 15,
              fontFamily: defaultFont)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return Scaffold(
          backgroundColor: ThemeColor.extralight,
          appBar: cleanAppBar(
            title: widget.title,
          ),
          body: SafeArea(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                                    margin: EdgeInsets.all(20),
                                    child: ListView(children: <Widget>[
                                      _title(),
                                      _time(),
                                      _sizedBox(),
                                      _content(),
                                      _suggestEdit()
                                    ]))),
                            _bottombar(),
                          ],
                        ),
                      )))));
    } else {
      return Scaffold(
          backgroundColor: ThemeColor.extralight,
          body: SafeArea(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                                            _time(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _bottombar()
                            ],
                          )),
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.all(20),
                                child: ListView(children: <Widget>[
                                  _content(),
                                  _suggestEdit()
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
