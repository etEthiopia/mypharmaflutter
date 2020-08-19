import 'package:cached_network_image/cached_network_image.dart';
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
  final int category;
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

  Widget _image() {
    return Container(
      height: 200,
      child: loadimage(widget.image),
    );
  }

  Widget _bottombar() {
    return Container(
      decoration: BoxDecoration(
          color: dark,
          border: Border.symmetric(vertical: BorderSide(color: light))),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                      color: extralight,
                    ),
                    onPressed: () {},
                  ),
                  Text("15",
                      style: TextStyle(
                          color: extralight,
                          fontSize: 15,
                          fontFamily: defaultFont))
                ],
              ),
            ],
          ),
          Row(children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.error,
                color: extralight,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.share,
                color: extralight,
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
            color: darksecond, fontSize: 20, fontFamily: defaultFont));
  }

  Widget _category() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text("Category: ",
                style: TextStyle(
                    color: light, fontSize: 10, fontFamily: defaultFont)),
            Text(widget.category.toString(),
                style: TextStyle(
                    color: primary, fontSize: 10, fontFamily: defaultFont)),
          ],
        ),
      ],
    );
  }

  Widget _time() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(widget.time,
            style: TextStyle(
                color: primary, fontSize: 10, fontFamily: defaultFont)),
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
            color: dark,
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
          style: TextStyle(fontSize: 10, color: dark, fontFamily: defaultFont),
        )),
      ],
    );
  }

  Widget _content() {
    return Container(
      color: Colors.grey[150],
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(widget.content,
          style: TextStyle(
              color: darksecond, fontSize: 15, fontFamily: defaultFont)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return Scaffold(
          backgroundColor: extralight,
          body: SafeArea(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                      color: Colors.grey[200],
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                                      _category(),
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
          backgroundColor: extralight,
          body: SafeArea(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    color: Colors.grey[200],
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                                            _category(),
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
