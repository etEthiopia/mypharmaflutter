import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class BrowseProduct extends StatefulWidget {
  @override
  _BrowseProductState createState() => _BrowseProductState();
}

class _BrowseProductState extends State<BrowseProduct> {
  @override
  Widget build(BuildContext context) {
    final apiService = RepositoryProvider.of<APIService>(context);
    return Scaffold(
      appBar: simpleAppBar(title: 'Browse Products'),
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
    _productBloc.add(MyProductFetched());
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
          return ErrorMessage(context, 'browse_products', state.error);
        }
      }
      if (state is MyProductLoaded) {
        return Scaffold(
          backgroundColor: ThemeColor.background2,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
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
