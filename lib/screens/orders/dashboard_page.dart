import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/order/bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/main.dart';
import 'package:mypharma/theme/colors.dart';

class DashBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: simpleAppBar(
            title: AppLocalizations.of(context).translate("dashboard")),
        backgroundColor: ThemeColor.background,
        drawer: UserDrawer(),
        body: BlocProvider<OrderBloc>(
            create: (context) => OrderBloc(apiService),
            //create: (context) => NewsBloc(_newsService),
            child: DashBoardPage()));
  }
}

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  var _orderBloc;

  @override
  void initState() {
    _orderBloc = BlocProvider.of<OrderBloc>(context);
    _orderBloc.add(DashboardFetched());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(listener: (context, state) {
      if (state is OrderFailure) {
        showError(state.error, context);
      }
    }, child: BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      if (state is OrderLoading) {
        return LoadingLogin(context);
      } else if (state is OrderFailure) {
        if (state.error == 'Not Authorized') {
          return LoggedOutLoading(context);
        } else {
          return ErrorMessage(context, 'order_sent', state.error);
        }
      } else if (state is DashboardLoaded) {
        return Scaffold(
            appBar: simpleAppBar(
                title: AppLocalizations.of(context).translate("dashboard")),
            backgroundColor: ThemeColor.background,
            drawer: UserDrawer(),
            body: BlocProvider<OrderBloc>(
                create: (context) => OrderBloc(apiService),

                //create: (context) => NewsBloc(_newsService),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/logo/logo100.png",
                                width: 100.0,
                              ),
                              state.dashboard.user < 4
                                  ? Text(state.dashboard.totalCustomerOrders
                                          .toString() +
                                      " " +
                                      AppLocalizations.of(context)
                                          .translate("your_received_orders"))
                                  : SizedBox(
                                      height: 0,
                                    ),
                              state.dashboard.user > 2
                                  ? Text(
                                      state.dashboard.totalMyOrders.toString() +
                                          " " +
                                          AppLocalizations.of(context)
                                              .translate("your_sent_orders"))
                                  : SizedBox(
                                      height: 0,
                                    ),
                            ],
                          ),
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        Container(
                          child: Text(state.dashboard.visits.toString() +
                              " " +
                              AppLocalizations.of(context)
                                  .translate("visited_user")),
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        state.dashboard.user < 4
                            ? Column(
                                children: [
                                  Text(
                                      "customerProcessingOrders ${state.dashboard.customerProcessingOrders}"),
                                  Text(
                                      "customerDeliveredgOrders ${state.dashboard.customerDeliveredgOrders}"),
                                  Text(
                                      "customerOnholdOrders ${state.dashboard.customerOnholdOrders}"),
                                  Text(
                                      "customerFailedOrders ${state.dashboard.customerFailedOrders}"),
                                  Text(
                                      "customerShippingOrders ${state.dashboard.customerShippingOrders}"),
                                ],
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        state.dashboard.user > 2
                            ? Column(
                                children: [
                                  Text(
                                      "myProcessingOrders ${state.dashboard.myProcessingOrders}"),
                                  Text(
                                      "myOndeliveredOrders ${state.dashboard.myOndeliveredOrders}"),
                                  Text(
                                      "myOnholdOrders ${state.dashboard.myOnholdOrders}"),
                                  Text(
                                      "myFailedOrders ${state.dashboard.myFailedOrders}"),
                                  Text(
                                      "myShippingOrders ${state.dashboard.myShippingOrders}"),
                                ],
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )));
      }
    }));
  }
}
