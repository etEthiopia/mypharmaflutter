import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/empty.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/page_end.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/services/services.dart';
import 'package:mypharma/blocs/order/bloc.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';
import 'package:mypharma/components/order.dart';

class SentOrderPage extends StatefulWidget {
  @override
  _SentOrderPageState createState() => _SentOrderPageState();
}

class _SentOrderPageState extends State<SentOrderPage> {
  @override
  Widget build(BuildContext context) {
    final apiService = RepositoryProvider.of<APIService>(context);
    return Scaffold(
        appBar: simpleAppBar(title: "Orders Sent"),
        backgroundColor: ThemeColor.background,
        drawer: UserDrawer(),
        body: BlocProvider<OrderBloc>(
            create: (context) => OrderBloc(apiService),

            //create: (context) => NewsBloc(_newsService),
            child: SentOrdersList()));
  }
}

class SentOrdersList extends StatefulWidget {
  @override
  _SentOrdersListState createState() => _SentOrdersListState();

  String selectedCategory = 'all';
}

class _SentOrdersListState extends State<SentOrdersList> {
  ScrollController _controller;
  int page = 1;
  int last = 1;

  List<DropdownMenuItem<dynamic>> categories = [
    DropdownMenuItem(
      value: 'all',
      child: Text(
        "All",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
      ),
    ),
    DropdownMenuItem(
      value: 'processing',
      child: Text(
        "Processing",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
      ),
    ),
    DropdownMenuItem(
      value: 'onhold',
      child: Text(
        "Onhold",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
      ),
    ),
    DropdownMenuItem(
      value: 'shipping',
      child: Text(
        "Shipping",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
      ),
    ),
    DropdownMenuItem(
      value: 'pending payment',
      child: Text(
        "Pending Payment",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
      ),
    ),
    DropdownMenuItem(
      value: 'completed',
      child: Text(
        "Completed",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
      ),
    ),
    DropdownMenuItem(
      value: 'delivered',
      child: Text(
        "Delivered",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
      ),
    ),
    DropdownMenuItem(
      value: 'refunded',
      child: Text(
        "Refunded",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
      ),
    ),
    DropdownMenuItem(
      value: 'failed',
      child: Text(
        "Failed",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
      ),
    ),
  ];

  Widget _categoryPrompt() {
    return Container(
      color: ThemeColor.background2,
      padding: const EdgeInsets.only(
        top: 20,
        left: 10,
        right: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Status",
              style: TextStyle(
                  color: ThemeColor.primaryText,
                  fontSize: 10,
                  fontFamily: defaultFont)),
          DropdownButtonFormField(
            dropdownColor: ThemeColor.background,
            style:
                TextStyle(color: ThemeColor.darkText, fontFamily: defaultFont),
            items: categories,
            hint: Text("Status"),
            value: widget.selectedCategory,
            onChanged: (value) {
              setState(() {
                widget.selectedCategory = value;
              });
            },
            isExpanded: true,
          ),
        ],
      ),
    );
  }

  var _orderBloc;

  @override
  void initState() {
    _orderBloc = BlocProvider.of<OrderBloc>(context);

    _orderBloc.add(OrderSentFetched(page: page));

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
        _orderBloc.add(OrderSentFetched(page: page));
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
            return PageEnd(context, 'order_sent');
          } else if (state is OrderLoading || state is OrderInital) {
            return LoadingLogin(context);
          } else if (state is OrderNothingSent) {
            return empty(context, 'order_sent');
          } else if (state is OrderFailure) {
            if (state.error == 'Not Authorized') {
              return LoggedOutLoading(context);
            } else {
              return ErrorMessage(context, 'order_sent', state.error);
            }
          } else if (state is OrderSentLoaded) {
            return Scaffold(
              backgroundColor: ThemeColor.background3,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    color: ThemeColor.background2,
                    child: Container(
                      child: Column(
                        children: [
                          _categoryPrompt(),
                          page > 1
                              ? Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        page = 1;
                                      });
                                      _orderBloc
                                          .add(OrderSentFetched(page: page));
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
                                controller: _controller,
                                itemCount: state.sentList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  print(state.sentList[index].toString());
                                  last = state.last;
                                  return OrderCard(
                                    o: state.sentList[index],
                                    received: false,
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
