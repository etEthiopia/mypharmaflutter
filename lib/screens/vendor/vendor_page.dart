import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/blocs/cart/bloc.dart';
import 'package:mypharma/blocs/product/bloc.dart';
import 'package:mypharma/blocs/wishlist/bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/product.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/components/show_success.dart';
import 'package:mypharma/main.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/screens/products/show_product.dart';
import 'package:mypharma/services/services.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_localizations.dart';

class VendorPage extends StatefulWidget {
  VendorPage({Key key, this.id}) : super(key: key);

  @override
  _VendorPageState createState() => _VendorPageState();
  final int id;
}

class _VendorPageState extends State<VendorPage> {
  @override
  Widget build(BuildContext context) {
    final apiService = RepositoryProvider.of<APIService>(context);
    return Scaffold(
        appBar: cleanAppBar(
            title: AppLocalizations.of(context).translate("vendor_title")),
        backgroundColor: ThemeColor.background,
        body: BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(apiService),
            child: VendorPageDetail(id: widget.id)));
  }
}

class VendorPageDetail extends StatefulWidget {
  final int id;

  VendorPageDetail({Key key, this.id}) : super(key: key);
  @override
  _VendorPageDetailState createState() => _VendorPageDetailState();
}

class _VendorPageDetailState extends State<VendorPageDetail> {
  var _productBloc;
  List<Widget> imageSliders;
  List<String> imgList;
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
  void initState() {
    _productBloc = BlocProvider.of<ProductBloc>(context);
    _productBloc.add(VendorFetched(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      _colFix(true);
    } else {
      _colFix(false);
    }
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductFailure) {
          showError(state.error, context);
        }
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return LoadingLogin(context);
          } else if (state is ProductFailure) {
            if (state.error == 'Not Authorized') {
              return LoggedOutLoading(context);
            } else {
              return ErrorMessage(context, 'home', state.error);
            }
          } else if (state is VendorLoaded) {
            Widget _errorIcon(BuildContext context, String url, dynamic error) {
              print(error);
              return Container(
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage('assets/images/logo/logo100.png'),
                  ));
            }

            Widget _smallsizedBox() {
              return SizedBox(height: 10);
            }

            Widget _xsmallsizedBox() {
              return SizedBox(height: 5);
            }

            Widget _xsmallvsizedBox() {
              return SizedBox(width: 5);
            }

            Widget _smallvsizedBox() {
              return SizedBox(width: 20);
            }

            Widget _progress(
                BuildContext context, String url, dynamic downloadProgress) {
              return Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress));
            }

            Widget _compnameText() {
              return Text(
                state.vendor.name,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white, fontSize: 20, fontFamily: defaultFont),
              );
            }

            Widget _loadicon(String image) {
              String url = '${SERVER_IP_FILE}news/$image';
              if (image == '') {
                url = 'assets/images/logo/logo100.png';
              }
              return CachedNetworkImage(
                imageUrl: url,
                progressIndicatorBuilder: _progress,
                errorWidget: _errorIcon,
                imageBuilder: (context, imageProvider) => Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              );
            }

            Widget _icon() {
              return SizedBox(
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(child: _loadicon(state.vendor.icon))),
              );
            }

            Widget _about() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    state.vendor.description,
                    style: TextStyle(
                        color: ThemeColor.darksecondText,
                        fontSize: 17,
                        fontFamily: defaultFont),
                  )
                ],
              );
            }

            Widget _phone() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.phone,
                    size: 17,
                    color: ThemeColor.primaryText,
                  ),
                  _xsmallvsizedBox(),
                  Text(state.vendor.address.phone + "  ",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: ThemeColor.primaryText,
                          fontSize: 15,
                          fontFamily: defaultFont)),
                  InkWell(
                    onTap: () {
                      launch("tel://${state.vendor.address.phone}");
                    },
                    child: Text(
                      "CALL NOW",
                      style: TextStyle(
                          color: ThemeColor.primaryText,
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontFamily: defaultFont),
                    ),
                  ),
                ],
              );
            }

            Widget _address() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context).translate("address_text"),
                      style: TextStyle(
                          color: ThemeColor.lightText,
                          fontSize: 13,
                          fontFamily: defaultFont)),
                  Text(
                    state.vendor.address.address1 +
                        (state.vendor.address.address2 != '-'
                            ? (", " + state.vendor.address.address2)
                            : "") +
                        "\n" +
                        state.vendor.address.city +
                        ", " +
                        state.vendor.address.state,
                    style: TextStyle(
                        color: ThemeColor.darksecondText,
                        fontSize: 16,
                        fontFamily: defaultFont),
                    textAlign: TextAlign.center,
                  )
                ],
              );
            }

            Widget _details() {
              return Container(
                  margin: EdgeInsets.all(20),
                  child: Column(children: <Widget>[
                    _about(),
                    _smallsizedBox(),
                    _phone(),
                    _smallsizedBox(),
                    _address(),
                    _smallsizedBox(),
                  ]));
            }

            return SafeArea(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      color: ThemeColor.primaryBtn,
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        children: <Widget>[
                          _icon(),
                          _xsmallsizedBox(),
                          _compnameText(),
                          _xsmallsizedBox(),
                        ],
                      ),
                    ),
                    _details(),
                    _smallsizedBox(),
                    Text(
                      AppLocalizations.of(context)
                          .translate("browse_product_title"),
                      style:
                          TextStyle(fontSize: 17, color: ThemeColor.darkText),
                      textAlign: TextAlign.center,
                    ),
                    _xsmallsizedBox(),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        child: GridView.builder(
                          itemCount: state.vendor.products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: col),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ShowProduct(
                                            id: state.vendor.products[index].id,
                                          )),
                                );
                              },
                              child: product(
                                  id: state.vendor.products[index].id,
                                  name: state.vendor.products[index].title,
                                  image: state.vendor.products[index].image,
                                  org: state.vendor.products[index].vendor,
                                  price: state.vendor.products[index].price
                                      .toString(),
                                  context: this.context),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return LoadingLogin(context);
          }
        },
      ),
    );
  }
}
