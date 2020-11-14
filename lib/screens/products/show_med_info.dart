import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/blocs/cart/bloc.dart';
import 'package:mypharma/blocs/product/bloc.dart';
import 'package:mypharma/blocs/wishlist/bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/components/show_success.dart';
import 'package:mypharma/main.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/services/services.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

import '../../app_localizations.dart';

class ShowMedInfo extends StatefulWidget {
  ShowMedInfo({Key key, this.id}) : super(key: key);

  @override
  _ShowMedInfoState createState() => _ShowMedInfoState();
  final int id;
}

class _ShowMedInfoState extends State<ShowMedInfo> {
  @override
  Widget build(BuildContext context) {
    final apiService = RepositoryProvider.of<APIService>(context);
    return Scaffold(
        //AppLocalizations.of(context).translate("browse_product_title")
        appBar: simpleAppBar(
            title:
                AppLocalizations.of(context).translate("show_product_title")),
        drawer: UserDrawer(),
        backgroundColor: ThemeColor.background,
        body: BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(apiService),
            child: _ShowMedInfoDetail(
              id: widget.id,
            )));
  }
}

class _ShowMedInfoDetail extends StatefulWidget {
  final int id;
  int current = 0;

  _ShowMedInfoDetail({Key key, this.id}) : super(key: key);
  @override
  _ShowMedInfoDetailState createState() => _ShowMedInfoDetailState();
}

class _ShowMedInfoDetailState extends State<_ShowMedInfoDetail> {
  var _productBloc;
  List<Widget> imageSliders;
  List<String> imgList;

  @override
  void initState() {
    _productBloc = BlocProvider.of<ProductBloc>(context);
    _productBloc.add(MedInfoDetailFetched(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _productBloc = BlocProvider.of<ProductBloc>(context);
    return BlocListener<ProductBloc, ProductState>(listener: (context, state) {
      if (state is ProductFailure) {
        showError(state.error, context);
      }
    }, child: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
      if (state is ProductLoading) {
        return LoadingLogin(context);
      } else if (state is ProductFailure) {
        if (state.error == 'Not Authorized') {
          return LoggedOutLoading(context);
        } else {
          return ErrorMessage(context, 'show_product', state.error);
        }
      } else if (state is MedLoaded) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Title",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: defaultFont,
                            color: ThemeColor.primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(state.product.title,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: ThemeColor.darksecondText,
                              fontSize: 17,
                              fontFamily: defaultFont)),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
                ExpansionTile(
                  title: Text(
                    "Description",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: defaultFont,
                        color: ThemeColor.primaryText,
                        fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    ListTile(
                        title: Text(state.product.description ?? '-',
                            style: TextStyle(
                                color: ThemeColor.darksecondText,
                                fontSize: 17,
                                fontFamily: defaultFont)))
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Indications",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: defaultFont,
                        color: ThemeColor.primaryText,
                        fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    ListTile(
                        title: Text(state.product.indications ?? '-',
                            style: TextStyle(
                                color: ThemeColor.darksecondText,
                                fontSize: 17,
                                fontFamily: defaultFont)))
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Cautions",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: defaultFont,
                        color: ThemeColor.primaryText,
                        fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    ListTile(
                        title: Text(state.product.cautions ?? '-',
                            style: TextStyle(
                                color: ThemeColor.darksecondText,
                                fontSize: 17,
                                fontFamily: defaultFont)))
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Drug Interactions",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: defaultFont,
                        color: ThemeColor.primaryText,
                        fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    ListTile(
                        title: Text(state.product.drugInteractions ?? '-',
                            style: TextStyle(
                                color: ThemeColor.darksecondText,
                                fontSize: 17,
                                fontFamily: defaultFont)))
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Contradictions",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: defaultFont,
                        color: ThemeColor.primaryText,
                        fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    ListTile(
                        title: Text(state.product.contradictions ?? '-',
                            style: TextStyle(
                                color: ThemeColor.darksecondText,
                                fontSize: 17,
                                fontFamily: defaultFont)))
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Side Effects",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: defaultFont,
                        color: ThemeColor.primaryText,
                        fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    ListTile(
                        title: Text(state.product.sideEffects ?? '-',
                            style: TextStyle(
                                color: ThemeColor.darksecondText,
                                fontSize: 17,
                                fontFamily: defaultFont)))
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Dose Adminstrations",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: defaultFont,
                        color: ThemeColor.primaryText,
                        fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    ListTile(
                        title: Text(state.product.doseAdminstrations ?? '-',
                            style: TextStyle(
                                color: ThemeColor.darksecondText,
                                fontSize: 17,
                                fontFamily: defaultFont)))
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Storage",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: defaultFont,
                        color: ThemeColor.primaryText,
                        fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    ListTile(
                        title: Text(state.product.storage ?? '-',
                            style: TextStyle(
                                color: ThemeColor.darksecondText,
                                fontSize: 17,
                                fontFamily: defaultFont)))
                  ],
                ),
              ],
            ),
          ),
        );
      } else {
        return LoadingLogin(context);
      }
    }));
  }
}
