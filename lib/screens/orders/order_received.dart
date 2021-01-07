import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/empty.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/page_end.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/screens/orders/order_detail.dart';
import 'package:mypharma/services/services.dart';
import 'package:mypharma/blocs/order/bloc.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';
import 'package:mypharma/components/order.dart';

class ReceivedOrderPage extends StatefulWidget {
  @override
  _ReceivedOrderPageState createState() => _ReceivedOrderPageState();
}

class _ReceivedOrderPageState extends State<ReceivedOrderPage> {
  @override
  Widget build(BuildContext context) {
    final apiService = RepositoryProvider.of<APIService>(context);
    return Scaffold(
        appBar: simpleAppBar(
            title: AppLocalizations.of(context)
                .translate("order_received_screen_title")),
        backgroundColor: ThemeColor.background,
        drawer: UserDrawer(),
        body: BlocProvider<OrderBloc>(
            create: (context) => OrderBloc(apiService),

            //create: (context) => NewsBloc(_newsService),
            child: ReceivedOrdersList()));
  }
}

class ReceivedOrdersList extends StatefulWidget {
  @override
  _ReceivedOrdersListState createState() => _ReceivedOrdersListState();

  String selectedCategory = 'all';
}

class _ReceivedOrdersListState extends State<ReceivedOrdersList> {
  ScrollController _controller;
  int page = 1;
  int last = 1;

  var _orderBloc;

  @override
  void initState() {
    _orderBloc = BlocProvider.of<OrderBloc>(context);
    _orderBloc.add(OrderReceivedFetched(page: page));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _orderBloc = BlocProvider.of<OrderBloc>(context);

    _scrollListener() {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() {
          page = page + 1;
        });
        print("reach the bottom");
        _orderBloc.add(OrderReceivedFetched(page: page));
        // if (page <= last) {
        //   _feedBloc.add(NewsFetched(page: page));
        // }
      }
      if (_controller.offset <= _controller.position.minScrollExtent &&
          !_controller.position.outOfRange) {
        print("reach the top");
      }
    }

    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderFailure) {
          showError(state.error, context);
        }
      },
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderAllLoaded) {
            return PageEnd(context, 'order_received');
          } else if (state is OrderLoading || state is OrderInital) {
            return LoadingLogin(context);
          } else if (state is OrderNothingSent) {
            return empty(context, 'order_received');
          } else if (state is OrderFailure) {
            if (state.error == 'Not Authorized') {
              return LoggedOutLoading(context);
            } else {
              return ErrorMessage(context, 'order_received', state.error);
            }
          } else if (state is OrderReceivedLoaded) {
            return Scaffold(
              backgroundColor: ThemeColor.background3,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Material(
                    color: ThemeColor.background2,
                    child: Container(
                      child: Column(
                        children: [
                          page > 1
                              ? Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        page = 1;
                                      });
                                      _orderBloc.add(
                                          OrderReceivedFetched(page: page));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.timer,
                                          color: dark,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Go back to the latest orders",
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              color: dark,
                                              fontSize: 20,
                                              fontFamily: defaultFont),
                                        ),
                                      ],
                                    ),
                                  ))
                              : SizedBox(
                                  height: 0,
                                ),
                          Expanded(
                            child: Container(
                              color: Colors.grey[150],
                              child: ListView.builder(
                                itemCount: state.receivedList.keys.length,
                                itemBuilder: (BuildContext context, int index) {
                                  last = state.last;
                                  return InkWell(
                                    // onTap: () {
                                    //   print("clicked");
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (BuildContext context) =>
                                    //               OrderDetail(
                                    //                 postid: state
                                    //                     .receivedList.keys
                                    //                     .toList()[index]
                                    //                     .postid,
                                    //                 id: state.receivedList.keys
                                    //                     .toList()[index]
                                    //                     .id,
                                    //                 selectedCategory: state
                                    //                     .receivedList.keys
                                    //                     .toList()[index]
                                    //                     .status,
                                    //               ))).then((value) {
                                    //     _orderBloc =
                                    //         BlocProvider.of<OrderBloc>(context);
                                    //     _orderBloc.add(
                                    //         OrderReceivedFetched(page: page));
                                    //     return true;
                                    //   });
                                    // },
                                    child: OrderCard(
                                      // state.receivedList[index].toString()
                                      o: state.receivedList.keys
                                          .toList()[index],
                                      received: true,
                                      orders: state.receivedList[state
                                          .receivedList.keys
                                          .toList()[index]],
                                      page: page,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
