import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/product/bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/page_end.dart';
import 'package:mypharma/components/product.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/screens/products/show_product.dart';
import 'package:mypharma/services/api_service.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class BrowseProduct extends StatefulWidget {
  //final isSearch;

  BrowseProduct({isSearch = false}) {
    Product.isSearch = isSearch;
  }
  @override
  _BrowseProductState createState() => _BrowseProductState();
}

class _BrowseProductState extends State<BrowseProduct> {
  @override
  Widget build(BuildContext context) {
    final apiService = RepositoryProvider.of<APIService>(context);
    return Scaffold(
      appBar: cleanAppBar(
          title: AppLocalizations.of(context).translate(
              Product.isSearch ? "search_title" : "browse_product_title")),
      backgroundColor: ThemeColor.background,
      drawer: UserDrawer(),
      body: BlocProvider<ProductBloc>(
        create: (context) => ProductBloc(apiService),
        child: BrowseProductList(),
      ),
    );
  }
}

class BrowseProductList extends StatefulWidget {
  @override
  _BrowseProductListState createState() => _BrowseProductListState();
}

class _BrowseProductListState extends State<BrowseProductList> {
  final TextEditingController _searchController = TextEditingController();
  bool catOrNot = false;

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
    final _productBloc = BlocProvider.of<ProductBloc>(context);
    if (Product.isSearch) {
      _productBloc.add(ProductGetReady());
    } else {
      _productBloc.add(MyProductFetched());
    }
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
        AppLocalizations.of(context).translate("category_filter_text"),
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
          color: ThemeColor.background2,
          elevation: 0.0,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: ThemeColor.background1,
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
                        _productBloc.add((ProductSearched(
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
              items: Category.categoryDropdowns,
              hint: _categoryText(size: 15),
              onChanged: (value) {
                _productBloc.add((ProductSearched(text: null, id: value)));
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
                !catOrNot ? "category_filter_text" : "search_product_text"),
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
          Category.categoryDropdowns.length != 0
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
      }
      if (state is ProductFailure) {
        if (state.error == 'Not Authorized') {
          return LoggedOutLoading(context);
        } else {
          return ErrorMessage(
              context,
              Product.isSearch ? "search_products" : "browse_products",
              state.error);
        }
      } else if (state is MyProductLoaded) {
        return Scaffold(
          backgroundColor: ThemeColor.background2,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  Product.isSearch
                      ? _searchBar()
                      : SizedBox(
                          height: 0,
                        ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: state.productsList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: col),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ShowProduct(
                                        id: state.productsList[index].id,
                                      )),
                            );
                          },
                          child: product(
                              id: state.productsList[index].id,
                              name: state.productsList[index].title,
                              image: state.productsList[index].image,
                              org: state.productsList[index].vendor,
                              price: state.productsList[index].price
                                  .toStringAsFixed(2),
                              context: this.context),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (state is ProductSearchLoaded) {
        return Scaffold(
          backgroundColor: ThemeColor.background2,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  _searchItems(),
                  Expanded(
                    child: GridView.builder(
                      itemCount: state.productsList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: col),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ShowProduct(
                                        id: state.productsList[index].id,
                                      )),
                            );
                          },
                          child: product(
                              id: state.productsList[index].id,
                              name: state.productsList[index].title,
                              image: state.productsList[index].image,
                              org: state.productsList[index].vendor,
                              price: state.productsList[index].price
                                  .toStringAsFixed(2),
                              context: this.context),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (state is ProductSearchReady) {
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
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/logo/logo200.png",
                          width: 200.0,
                        )),
                  ),
                ],
              ),
            ),
          ),
        );
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
      }
    }));
  }
}
