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
      if (state is MedsInfoLoaded) {
        return Scaffold(
          backgroundColor: ThemeColor.background1,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
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
          ),
        );
      }
    }));
  }
}
