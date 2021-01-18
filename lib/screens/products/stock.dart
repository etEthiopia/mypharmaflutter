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
import 'package:mypharma/components/stock_product.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/screens/products/show_product.dart';
import 'package:mypharma/services/api_service.dart';
import 'package:mypharma/theme/colors.dart';

class Stock extends StatefulWidget {
  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> {
  @override
  Widget build(BuildContext context) {
    final apiService = RepositoryProvider.of<APIService>(context);
    return Scaffold(
      appBar: cleanAppBar(
          title: AppLocalizations.of(context).translate("stock_title")),
      drawer: UserDrawer(),
      backgroundColor: ThemeColor.background,
      body: BlocProvider<ProductBloc>(
        create: (context) => ProductBloc(apiService),
        child: StockList(),
      ),
    );
  }
}

class StockList extends StatefulWidget {
  @override
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
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
    _productBloc.add(MyStockFetched());
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
          return ErrorMessage(context, 'stock', state.error);
        }
      }
      if (state is MyStockLoaded) {
        return Scaffold(
          backgroundColor: ThemeColor.background1,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: ListView.builder(
                itemCount: state.productsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ShowProduct(
                                  id: state.productsList[index].id,
                                  isProduct: false,
                                )),
                      );
                    },
                    child: StockProduct(
                      id: state.productsList[index].id,
                      name: state.productsList[index].title,
                      image: state.productsList[index].image,
                      description: state.productsList[index].description,
                      price: state.productsList[index].price.toString(),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
    }));
  }
}
