import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        appBar: simpleAppBar(title: "Orders Received"),
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

  List<DropdownMenuItem<dynamic>> categories = [
    DropdownMenuItem(
      value: 'all',
      child: Text(
        "All",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'processing',
      child: Text(
        "Processing",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'onhold',
      child: Text(
        "Onhold",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'shipping',
      child: Text(
        "Shipping",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'pending payment',
      child: Text(
        "Pending Payment",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'completed',
      child: Text(
        "Completed",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'delivered',
      child: Text(
        "Delivered",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'refunded',
      child: Text(
        "Refunded",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'failed',
      child: Text(
        "Failed",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
  ];

  Widget _categoryPrompt() {
    return Container(
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
                  color: primary, fontSize: 10, fontFamily: defaultFont)),
          DropdownButtonFormField(
            style: TextStyle(color: dark, fontFamily: defaultFont),
            items: categories,
            hint: Text("Status"),
            value: widget.selectedCategory,
            onChanged: (value) {
              setState(() {
                widget.selectedCategory = value;
              });
              // _orderBloc = BlocProvider.of<OrderBloc>(context);

              // _orderBloc.add(OrderStatusChangeOrdered(
              //     status: widget.selectedCategory, id: widget.id));
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
    _orderBloc.add(OrderReceivedFetched());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _orderBloc = BlocProvider.of<OrderBloc>(context);

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
              return NoInternet(context, 'order_received');
            }
          } else if (state is OrderReceivedLoaded) {
            return Scaffold(
              backgroundColor: Colors.grey[300],
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    color: Colors.grey[100],
                    child: Container(
                      child: Column(
                        children: [
                          _categoryPrompt(),
                          widget.selectedCategory != 'all'
                              ? Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: InkWell(
                                    onTap: () {
                                      print("Selected: " +
                                          state.receivedList[0].selected
                                              .toString());
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
                                itemCount: state.receivedList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  print("Selected or naa! " +
                                      state.receivedList[index].selected
                                          .toString());
                                  return InkWell(
                                    onTap: () {
                                      print("clicked");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  OrderDetail(
                                                    postid: state
                                                        .receivedList[index]
                                                        .postid,
                                                    id: state
                                                        .receivedList[index].id,
                                                    selectedCategory: state
                                                        .receivedList[index]
                                                        .status,
                                                  ))).then((value) {
                                        _orderBloc =
                                            BlocProvider.of<OrderBloc>(context);
                                        _orderBloc.add(OrderReceivedFetched());
                                        return true;
                                      });
                                    },
                                    child: OrderCard(
                                      // state.receivedList[index].toString()
                                      o: state.receivedList[index],
                                      received: true,
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
