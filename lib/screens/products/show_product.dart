import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/blocs/product/bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/main.dart';
import 'package:mypharma/services/services.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class ShowProduct extends StatefulWidget {
  ShowProduct({Key key, this.id}) : super(key: key);

  @override
  _ShowProductState createState() => _ShowProductState();
  final int id;
}

class _ShowProductState extends State<ShowProduct> {
  @override
  Widget build(BuildContext context) {
    final apiService = RepositoryProvider.of<APIService>(context);
    return Scaffold(
        appBar: simpleAppBar(title: "Order Detail"),
        drawer: UserDrawer(),
        body: BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(apiService),
            child: ShowProductDetail(
              id: widget.id,
            )));
  }
}

class ShowProductDetail extends StatefulWidget {
  final int id;
  int current = 0;

  ShowProductDetail({Key key, this.id}) : super(key: key);
  @override
  _ShowProductDetailState createState() => _ShowProductDetailState();
}

class _ShowProductDetailState extends State<ShowProductDetail> {
  var _productBloc;
  List<Widget> imageSliders;
  List<String> imgList;

  @override
  void initState() {
    _productBloc = BlocProvider.of<ProductBloc>(context);
    _productBloc.add(ProductDetailFetched(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    _productBloc = BlocProvider.of<ProductBloc>(context);
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductFailure) {
          showError(state.error, context);
        }
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          print("STATE: " + state.toString());
          if (state is ProductLoading) {
            return LoadingLogin(context);
          } else if (state is ProductFailure) {
            if (state.error == 'Not Authorized') {
              return LoggedOutLoading(context);
            } else if (state.error == 'Check Your Connection') {
              return NoInternet(context, 'show_product');
            } else {
              return ErrorMessage(context, 'show_product', state.error);
            }
          } else if (state is ProductLoaded) {
            Widget _error(BuildContext context, String url, dynamic error) {
              print(error);
              return const Center(child: Icon(Icons.error));
            }

            Widget _progress(
                BuildContext context, String url, dynamic downloadProgress) {
              return Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress));
            }

            Widget loadimage(String image) {
              return CachedNetworkImage(
                imageUrl: '${SERVER_IP_FILE}news/$image',
                progressIndicatorBuilder: _progress,
                errorWidget: _error,
              );
            }

            Widget _image() {
              return SizedBox(
                width: 150,
                height: 150,
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(child: loadimage(state.product.image))),
              );
            }

            Widget _porname() {
              return Text(state.product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: defaultFont));
            }

            Widget _category() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Category",
                      style: TextStyle(
                          color: extralight,
                          fontSize: 10,
                          fontFamily: defaultFont)),
                  Text("Pill",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: defaultFont))
                ],
              );
            }

            Widget _country() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Country",
                      style: TextStyle(
                          color: extralight,
                          fontSize: 10,
                          fontFamily: defaultFont)),
                  Text("Switzerland",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: defaultFont))
                ],
              );
            }

            Widget _org(bool por) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Provider",
                      style: TextStyle(
                          color: por ? extralight : primary,
                          fontSize: 10,
                          fontFamily: defaultFont)),
                  Text(state.product.vendor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: por ? Colors.white : darksecond,
                          fontSize: 15,
                          fontFamily: defaultFont))
                ],
              );
            }

            Widget _titlebar(por) {
              if (por) {
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _porname(),
                        SizedBox(
                          height: 5,
                        ),
                        _category(),
                        _country(),
                      ],
                    ),
                  ),
                );
              }
              return Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _category(),
                      _country(),
                    ],
                  ),
                ),
              );
            }

            Widget _action() {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: Material(
                          color: dark,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15)),
                          child: FlatButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: defaultFont),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: Material(
                          color: darksecond,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          child: FlatButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  "Add to Wishlist",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: defaultFont),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            Widget _details(por) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: por == true ? 0 : 10,
                                ),
                                por == true ? Text("") : _org(por),
                                SizedBox(
                                  height: por == true ? 0 : 10,
                                ),
                                Text("Product Name",
                                    style: TextStyle(
                                        color: light,
                                        fontSize: 10,
                                        fontFamily: defaultFont)),
                                Text(state.product.title,
                                    style: TextStyle(
                                        color: darksecond,
                                        fontSize: 20,
                                        fontFamily: defaultFont))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Generic Name",
                                    style: TextStyle(
                                        color: light,
                                        fontSize: 10,
                                        fontFamily: defaultFont)),
                                Text("Allergy Reliever",
                                    style: TextStyle(
                                        color: darksecond,
                                        fontSize: 15,
                                        fontFamily: defaultFont))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Batch Number",
                                        style: TextStyle(
                                            color: light,
                                            fontSize: 10,
                                            fontFamily: defaultFont)),
                                    Text(state.product.batchNo,
                                        style: TextStyle(
                                            color: darksecond,
                                            fontSize: 15,
                                            fontFamily: defaultFont))
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text("Single's Price",
                                          style: TextStyle(
                                              color: light,
                                              fontSize: 10,
                                              fontFamily: defaultFont)),
                                      Text("${state.product.price}ETB",
                                          style: TextStyle(
                                              color: darksecond,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              fontFamily: defaultFont))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Manufacured Date",
                                        style: TextStyle(
                                            color: light,
                                            fontSize: 10,
                                            fontFamily: defaultFont)),
                                    Text("01/02/2019",
                                        style: TextStyle(
                                            color: darksecond,
                                            fontSize: 15,
                                            fontFamily: defaultFont))
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Expire Date",
                                        style: TextStyle(
                                            color: light,
                                            fontSize: 10,
                                            fontFamily: defaultFont)),
                                    Text("01/02/2022",
                                        style: TextStyle(
                                            color: darksecond,
                                            fontSize: 15,
                                            fontFamily: defaultFont))
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Manufacurer Company",
                                    style: TextStyle(
                                        color: light,
                                        fontSize: 10,
                                        fontFamily: defaultFont)),
                                Text("Johnson & Johnson Pacific",
                                    style: TextStyle(
                                        color: darksecond,
                                        fontSize: 15,
                                        fontFamily: defaultFont))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Description",
                                    style: TextStyle(
                                        color: light,
                                        fontSize: 10,
                                        fontFamily: defaultFont)),
                                Container(
                                  height: 100,
                                  width: double.maxFinite,
                                  color: Colors.grey[100],
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: SingleChildScrollView(
                                    child: Text(state.product.description,
                                        style: TextStyle(
                                            color: darksecond,
                                            fontSize: 15,
                                            fontFamily: defaultFont)),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
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
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: dark,
                                      fontFamily: defaultFont),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      por
                          ? SizedBox(
                              height: 0,
                            )
                          : _action()
                    ],
                  ),
                ),
              );
            }

            if (orientation == Orientation.portrait) {
              return Container(
                  color: Colors.grey[300],
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: primary,
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    _image(),
                                    _titlebar(true),
                                  ],
                                ),
                              ),
                              Container(
                                child: _org(true),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    color: dark,
                                    border: Border.symmetric(
                                        vertical: BorderSide(color: light))),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                              ),
                            ],
                          ),
                        ),
                        _details(true),
                        _action()
                      ],
                    ),
                  ));
            } else {
              return Container(
                  color: Colors.grey[300],
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: primary,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _image(),
                              _titlebar(false),
                            ],
                          ),
                        ),
                        _details(false),
                      ],
                    ),
                  ));
            }
          }
        },
      ),
    );
  }
}
