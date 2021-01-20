import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/product/bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/med_product.dart';
import 'package:mypharma/components/page_end.dart';
import 'package:mypharma/components/product.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/components/stock_product.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/screens/products/show_product.dart';
import 'package:mypharma/services/api_service.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class MedsInfo extends StatefulWidget {
  @override
  _MedsInfo createState() => _MedsInfo();
}

class _MedsInfo extends State<MedsInfo> {
  @override
  Widget build(BuildContext context) {
    final apiService = RepositoryProvider.of<APIService>(context);
    return Scaffold(
      appBar: cleanAppBar(
          title: AppLocalizations.of(context).translate("meds_info_title")),
      drawer: UserDrawer(),
      backgroundColor: ThemeColor.background,
      body: BlocProvider<ProductBloc>(
        create: (context) => ProductBloc(apiService),
        child: MedsInfoList(),
      ),
    );
  }
}

class MedsInfoList extends StatefulWidget {
  @override
  _MedsInfoListState createState() => _MedsInfoListState();
}

class _MedsInfoListState extends State<MedsInfoList> {
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

  final TextEditingController _searchController = TextEditingController();
  bool catOrNot = false;

  @override
  void initState() {
    final _productBloc = BlocProvider.of<ProductBloc>(context);
    _productBloc.add(MedsInfoFetched());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _productBloc = BlocProvider.of<ProductBloc>(context);

    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      _colFix(true);
    } else {
      _colFix(false);
    }

    Widget _categoryText({double size = 10}) {
      return Text(
        AppLocalizations.of(context).translate("brand_filter_text"),
        style: TextStyle(
            color: ThemeColor.darkText,
            fontSize: size,
            fontFamily: defaultFont),
      );
    }

    Widget _searchBar() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: ThemeColor.background1,
          elevation: 0.0,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: ThemeColor.background3,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4.0),
                      child: TextFormField(
                        style: TextStyle(color: ThemeColor.contrastText),
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate("search_product_text"),
                            hintStyle:
                                TextStyle(color: ThemeColor.extralightText),
                            border: InputBorder.none,
                            isDense: true),
                        keyboardType: TextInputType.name,
                        controller: _searchController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Type some hints";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    color: ThemeColor.primaryBtn,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _productBloc.add((MedsInfoSearched(
                            text: _searchController.text, id: 0)));
                      },
                    ),
                  )
                ],
              )),
        ),
      );
    }

    Widget _categoryPrompt() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _categoryText(),
            DropdownButtonFormField(
              dropdownColor: ThemeColor.background3,
              style: TextStyle(color: dark, fontFamily: defaultFont),
              items: Brand.brandDropdowns,
              hint: _categoryText(size: 15),
              onChanged: (value) {
                _productBloc.add((MedsInfoSearched(text: null, id: value)));
              },
              isExpanded: true,
            ),
          ],
        ),
      );
    }

    Widget _switchSearch() {
      return Container(
        padding: EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            setState(() {
              catOrNot = !catOrNot;
            });
            //Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            AppLocalizations.of(context).translate(
                !catOrNot ? "brand_filter_text" : "search_product_text"),
            style: TextStyle(
                color: ThemeColor.darkText,
                decoration: TextDecoration.underline,
                fontFamily: defaultFont),
          ),
        ),
      );
    }

    Widget _searchItems() {
      return Column(
        children: [
          catOrNot ? _categoryPrompt() : _searchBar(),
          Brand.brandDropdowns.length != 0
              ? _switchSearch()
              : SizedBox(height: 0)
        ],
      );
    }

    return BlocListener<ProductBloc, ProductState>(listener: (context, state) {
      if (state is ProductFailure) {
        showError(state.error, context);
      }

      // ignore: missing_return
    }, child: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
      if (state is ProductLoading || state is ProductInital) {
        return LoadingLogin(context);
      } else if (state is ProductFailure) {
        if (state.error == 'Not Authorized') {
          return LoggedOutLoading(context);
        } else {
          return ErrorMessage(context, 'stock', state.error);
        }
      } else if (state is ProductSearchEmpty) {
        return Scaffold(
          backgroundColor: ThemeColor.background2,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  _searchItems(),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
                      alignment: Alignment.topCenter,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate("search_no_result"),
                        style: TextStyle(
                            fontSize: 20,
                            color: ThemeColor.contrastText,
                            fontFamily: defaultFont),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (state is ProductSearchLoading) {
        return Scaffold(
          backgroundColor: ThemeColor.background2,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  _searchBar(),
                  Expanded(
                    child: LoadingLogin(context),
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (state is MedsInfoLoaded) {
        return Scaffold(
          backgroundColor: ThemeColor.background1,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  _searchItems(),
                  Expanded(
                    child: GridView.builder(
                      itemCount: state.medsList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: col),
                      itemBuilder: (BuildContext context, int index) {
                        return medProduct(
                            id: state.medsList[index].id,
                            title: state.medsList[index].title,
                            description: state.medsList[index].description,
                            context: this.context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }));
  }
}
