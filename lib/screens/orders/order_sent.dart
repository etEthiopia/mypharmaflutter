import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
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
        appBar: simpleAppBar(title: "Orders Received"),
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
}

class _SentOrdersListState extends State<SentOrdersList> {
  ScrollController _controller;

  int _selectedCategory = 0;

  List<DropdownMenuItem<dynamic>> categories = [
    DropdownMenuItem(
      value: 0,
      child: Text(
        "All",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text(
        "Order Pending",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 2,
      child: Text(
        "Order Seen",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 3,
      child: Text(
        "Order Accepted",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 4,
      child: Text(
        "Order Denied",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 5,
      child: Text(
        "On Delivery",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
  ];

  Widget _categoryPrompt() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: DropdownButtonFormField(
        style: TextStyle(color: dark, fontFamily: defaultFont),
        items: categories,
        hint: Text("Status"),
        value: _selectedCategory,
        onChanged: (value) {
          setState(() {
            _selectedCategory = value;
          });
        },
        isExpanded: true,
      ),
    );
  }

  var _orderBloc;

  @override
  void initState() {
    _orderBloc = BlocProvider.of<OrderBloc>(context);

    _orderBloc.add(OrderSentFetched());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _orderBloc = BlocProvider.of<OrderBloc>(context);

    // _scrollListener() {
    //   if (_controller.offset >= _controller.position.maxScrollExtent &&
    //       !_controller.position.outOfRange) {
    //     print("left the top");
    //     // _controller.[]
    //   }
    //   if (_controller.offset <= _controller.position.minScrollExtent &&
    //       !_controller.position.outOfRange) {
    //     print("reach the top");
    //   }
    // }

    // _controller = ScrollController();
    // _controller.addListener(_scrollListener);

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
          } else if (state is OrderFailure) {
            if (state.error == 'Not Authorized') {
              return LoggedOutLoading(context);
            } else {
              return NoInternet(context, 'order_sent');
            }
          } else if (state is OrderSentLoaded) {
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
                          _selectedCategory > 1
                              ? Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: InkWell(
                                    onTap: () {},
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
                                itemCount: state.sentList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  print(state.sentList[index].toString());
                                  return OrderCard(
                                    // state.receivedList[index].toString()
                                    id: state.sentList[index].id,
                                    quantity: state.sentList[index].quantity,
                                    price: state.sentList[index].price,
                                    status: state.sentList[index].status,
                                    date: state.sentList[index].date,
                                    vendor: state.sentList[index].receiver,
                                    name: state.sentList[index].name,
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
