import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/order/bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/promotion.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/main.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/screens/posts/show_promo.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';

class DashBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: cleanAppBar(
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
  int touchedIndex;

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
          return ErrorMessage(context, 'home', state.error);
        }
      } else if (state is DashboardLoaded) {
        return Scaffold(
            backgroundColor: ThemeColor.background,
            drawer: UserDrawer(),
            body: BlocProvider<OrderBloc>(
                create: (context) => OrderBloc(apiService),

                //create: (context) => NewsBloc(_newsService),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ThemeColor.lightBtn,
                                  offset: const Offset(0.0, 1.5),
                                  blurRadius: 1.0,
                                  spreadRadius: 0.5,
                                ),
                              ],
                              color: ThemeColor.primaryBtn,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/logo/logo100.png",
                                color: Colors.white,
                                width: 75.0,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              state.dashboard.user < 4
                                  ? Text(
                                      state.dashboard.totalCustomerOrders
                                              .toString() +
                                          " " +
                                          AppLocalizations.of(context)
                                              .translate(
                                                  "your_received_orders"),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    )
                                  : SizedBox(
                                      height: 0,
                                    ),
                              state.dashboard.user > 2
                                  ? Text(
                                      state.dashboard.totalMyOrders.toString() +
                                          " " +
                                          AppLocalizations.of(context)
                                              .translate("your_sent_orders"),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    )
                                  : SizedBox(
                                      height: 0,
                                    ),
                            ],
                          ),
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                        ),
                        state.dashboard.visits != null
                            ? Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: ThemeColor.extralightBtn,
                                        offset: const Offset(0.0, 1.0),
                                        blurRadius: 1.0,
                                        spreadRadius: 0.5,
                                      ),
                                    ],
                                    color: ThemeColor.lightBtn,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.people_sharp,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      state.dashboard.visits.toString() +
                                          " " +
                                          AppLocalizations.of(context)
                                              .translate("visited_user"),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        state.dashboard.user < 4
                            ? Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: ThemeColor.background2,
                                        offset: const Offset(0.0, 1.0),
                                        blurRadius: 1.0,
                                        spreadRadius: 0.5,
                                      ),
                                    ],
                                    color: ThemeColor.background1,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 15),
                                child: Column(
                                  children: [
                                    PieChart(
                                      PieChartData(
                                          pieTouchData: PieTouchData(
                                              touchCallback:
                                                  (pieTouchResponse) {
                                            setState(() {
                                              if (pieTouchResponse.touchInput
                                                      is FlLongPressEnd ||
                                                  pieTouchResponse.touchInput
                                                      is FlPanEnd) {
                                                touchedIndex = -1;
                                              } else {
                                                touchedIndex = pieTouchResponse
                                                    .touchedSectionIndex;
                                              }
                                            });
                                          }),
                                          borderData: FlBorderData(
                                            show: false,
                                          ),
                                          sectionsSpace: 0,
                                          centerSpaceRadius: 40,
                                          sections: showingReceivedSections(
                                              state.dashboard)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context).translate(
                                          "order_received_screen_title"),
                                      style: TextStyle(
                                          color: ThemeColor.contrastText,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                "00",
                                                style: TextStyle(
                                                    color: Color(0xff0293ee)),
                                              ),
                                              color: Color(0xff0293ee),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Proccessing",
                                                style: TextStyle(
                                                    color: ThemeColor
                                                        .contrastText))
                                          ],
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                "00",
                                                style: TextStyle(
                                                    color: Color(0xfff8b250)),
                                              ),
                                              color: Color(0xfff8b250),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Delivered",
                                                style: TextStyle(
                                                    color: ThemeColor
                                                        .contrastText))
                                          ],
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                "00",
                                                style: TextStyle(
                                                    color: Color(0xff13d38e)),
                                              ),
                                              color: Color(0xff13d38e),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Onhold",
                                                style: TextStyle(
                                                    color: ThemeColor
                                                        .contrastText)),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                "00",
                                                style: TextStyle(
                                                    color: Color(0xff845bef)),
                                              ),
                                              color: Color(0xff845bef),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Failed",
                                                style: TextStyle(
                                                    color: ThemeColor
                                                        .contrastText))
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                "00",
                                                style: TextStyle(
                                                    color: Color(0xffd60000)),
                                              ),
                                              color: Color(0xffd60000),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Shipping",
                                                style: TextStyle(
                                                    color: ThemeColor
                                                        .contrastText))
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        state.dashboard.user > 2
                            ? Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: ThemeColor.background2,
                                        offset: const Offset(0.0, 1.0),
                                        blurRadius: 1.0,
                                        spreadRadius: 0.5,
                                      ),
                                    ],
                                    color: ThemeColor.background1,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 15),
                                child: Column(
                                  children: [
                                    PieChart(
                                      PieChartData(
                                          pieTouchData: PieTouchData(
                                              touchCallback:
                                                  (pieTouchResponse) {
                                            setState(() {
                                              if (pieTouchResponse.touchInput
                                                      is FlLongPressEnd ||
                                                  pieTouchResponse.touchInput
                                                      is FlPanEnd) {
                                                touchedIndex = -1;
                                              } else {
                                                touchedIndex = pieTouchResponse
                                                    .touchedSectionIndex;
                                              }
                                            });
                                          }),
                                          borderData: FlBorderData(
                                            show: false,
                                          ),
                                          sectionsSpace: 0,
                                          centerSpaceRadius: 40,
                                          sections: showingOrderedSections(
                                              state.dashboard)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate("order_sent_screen_title"),
                                      style: TextStyle(
                                          color: ThemeColor.contrastText,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                "00",
                                                style: TextStyle(
                                                    color: Color(0xff0293ee)),
                                              ),
                                              color: Color(0xff0293ee),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Proccessing",
                                                style: TextStyle(
                                                    color: ThemeColor
                                                        .contrastText))
                                          ],
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                "00",
                                                style: TextStyle(
                                                    color: Color(0xfff8b250)),
                                              ),
                                              color: Color(0xfff8b250),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Delivered",
                                                style: TextStyle(
                                                    color: ThemeColor
                                                        .contrastText))
                                          ],
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                "00",
                                                style: TextStyle(
                                                    color: Color(0xff13d38e)),
                                              ),
                                              color: Color(0xff13d38e),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Onhold",
                                                style: TextStyle(
                                                    color: ThemeColor
                                                        .contrastText)),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                "00",
                                                style: TextStyle(
                                                    color: Color(0xff845bef)),
                                              ),
                                              color: Color(0xff845bef),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Failed",
                                                style: TextStyle(
                                                    color: ThemeColor
                                                        .contrastText))
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                "00",
                                                style: TextStyle(
                                                    color: Color(0xffd60000)),
                                              ),
                                              color: Color(0xffd60000),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Shipping",
                                                style: TextStyle(
                                                    color: ThemeColor
                                                        .contrastText))
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          color: ThemeColor.background2,
                          padding: EdgeInsets.only(bottom: 10, top: 15),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("promo_title"),
                            style: TextStyle(
                                fontSize: 17,
                                color: ThemeColor.contrastText,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: 200,
                          color: ThemeColor.background2,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.dashboard.promos.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => ShowPromo(
                                              id: state
                                                  .dashboard.promos[index].id,
                                              title: state.dashboard
                                                  .promos[index].title,
                                              content: state.dashboard
                                                  .promos[index].description,
                                              image: state.dashboard
                                                  .promos[index].image,
                                              author: state.dashboard
                                                  .promos[index].authorname)),
                                    );
                                  },
                                  child: promotion(
                                    context: context,
                                    id: state.dashboard.promos[index].id,
                                    title: state.dashboard.promos[index].title,
                                    description: state
                                        .dashboard.promos[index].description,
                                    image: state.dashboard.promos[index].image,
                                    profileimg: state
                                        .dashboard.promos[index].profileimg,
                                    author:
                                        state.dashboard.promos[index].author,
                                    authorname: state
                                        .dashboard.promos[index].authorname,
                                  ));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )));
      } else {
        return LoadingLogin(context);
      }
    }));
  }

  List<PieChartSectionData> showingReceivedSections(Datta d) {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 35 : 25;
      final double radius = isTouched ? 80 : 70;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: d.customerProcessingOrders.toDouble(),
            title: d.customerProcessingOrders > 0
                ? d.customerProcessingOrders.toString()
                : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: d.customerDeliveredgOrders.toDouble(),
            title: d.customerDeliveredgOrders > 0
                ? d.customerDeliveredgOrders.toString()
                : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: d.customerOnholdOrders.toDouble(),
            title: d.customerOnholdOrders > 0
                ? d.customerOnholdOrders.toString()
                : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: d.customerFailedOrders.toDouble(),
            title: d.customerFailedOrders > 0
                ? d.customerFailedOrders.toString()
                : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 4:
          return PieChartSectionData(
            color: const Color(0xffd60000),
            value: d.customerShippingOrders.toDouble(),
            title: d.customerShippingOrders > 0
                ? d.customerShippingOrders.toString()
                : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }

  List<PieChartSectionData> showingOrderedSections(Datta d) {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 35 : 25;
      final double radius = isTouched ? 80 : 70;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: d.myProcessingOrders.toDouble(),
            title:
                d.myProcessingOrders > 0 ? d.myProcessingOrders.toString() : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: d.myOndeliveredOrders.toDouble(),
            title: d.myOndeliveredOrders > 0
                ? d.myOndeliveredOrders.toString()
                : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: d.myOnholdOrders.toDouble(),
            title: d.myOnholdOrders > 0 ? d.myOnholdOrders.toString() : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: d.myFailedOrders.toDouble(),
            title: d.myFailedOrders > 0 ? d.myFailedOrders.toString() : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 4:
          return PieChartSectionData(
            color: const Color(0xffd60000),
            value: d.myShippingOrders.toDouble(),
            title: d.myShippingOrders > 0 ? d.myShippingOrders.toString() : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}
