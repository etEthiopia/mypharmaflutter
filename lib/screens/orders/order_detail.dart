import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/blocs/order/bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/services/services.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class OrderDetail extends StatefulWidget {
  OrderDetail({Key key, this.postid, this.id, this.selectedCategory})
      : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
  final int postid;
  final int id;
  String selectedCategory;
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    final apiService = RepositoryProvider.of<APIService>(context);

    return Scaffold(
        appBar: simpleAppBar(title: "Order Detail"),
        drawer: UserDrawer(),
        body: BlocProvider<OrderBloc>(
            create: (context) => OrderBloc(apiService),

            //create: (context) => NewsBloc(_newsService),
            child: ShowOrder(
              selectedCategory: widget.selectedCategory,
              postid: widget.postid,
              id: widget.id,
            )));
  }
}

class ShowOrder extends StatefulWidget {
  final int postid;
  final int id;
  String selectedCategory;

  ShowOrder(
      {Key key,
      @required this.postid,
      @required this.selectedCategory,
      @required this.id})
      : super(key: key);
  @override
  _ShowOrderState createState() => _ShowOrderState();
}

class _ShowOrderState extends State<ShowOrder> {
  var _orderBloc;

  List<DropdownMenuItem<dynamic>> categories = [
    DropdownMenuItem(
      value: 'processing',
      child: Text(
        "processing",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'onhold',
      child: Text(
        "onhold",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'shipping',
      child: Text(
        "shipping",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'pending payment',
      child: Text(
        "pending payment",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'completed',
      child: Text(
        "completed",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'delivered',
      child: Text(
        "delivered",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'refunded',
      child: Text(
        "refunded",
        style: TextStyle(fontWeight: FontWeight.bold, color: darksecond),
      ),
    ),
    DropdownMenuItem(
      value: 'failed',
      child: Text(
        "failed",
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
              _orderBloc = BlocProvider.of<OrderBloc>(context);

              _orderBloc.add(OrderStatusChangeOrdered(
                  status: widget.selectedCategory, id: widget.id));
            },
            isExpanded: true,
          ),
        ],
      ),
    );
  }

  Widget _orderimage() {
    return Image.asset(
      'assets/images/figures/order.png',
    );
  }

  Widget _porname(String name, int postid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Product",
            style: TextStyle(
                color: extralight, fontSize: 10, fontFamily: defaultFont)),
        Text(name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 20,
                fontFamily: defaultFont)),
      ],
    );
  }

  Widget _fromname(String name, int userid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Order By",
            style: TextStyle(
                color: extralight, fontSize: 10, fontFamily: defaultFont)),
        Text(name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 15,
                fontFamily: defaultFont)),
      ],
    );
  }

  Widget _fromaddress(String address, String town) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(address,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontFamily: defaultFont)),
        Text(town,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontFamily: defaultFont)),
      ],
    );
  }

  Widget _quantity(String type, int amount) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Quantity",
              style: TextStyle(
                  color: primary, fontSize: 15, fontFamily: defaultFont)),
          Divider(
            color: extralight,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Amount",
                      style: TextStyle(
                          color: primary,
                          fontSize: 10,
                          fontFamily: defaultFont)),
                  Text(amount.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: darksecond,
                          fontSize: 20,
                          fontFamily: defaultFont)),
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Type",
                        style: TextStyle(
                            color: primary,
                            fontSize: 10,
                            fontFamily: defaultFont)),
                    Text(type,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: darksecond,
                            fontSize: 20,
                            fontFamily: defaultFont)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _price(double sub, double tax, double tot) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Price Details",
              style: TextStyle(
                  color: primary, fontSize: 15, fontFamily: defaultFont)),
          Divider(
            color: extralight,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text("Subtotal",
                        style: TextStyle(
                            color: primary,
                            fontSize: 15,
                            fontFamily: defaultFont)),
                  ),
                  Expanded(
                    child: Text("$sub ETB",
                        style: TextStyle(
                            color: darksecond,
                            fontSize: 15,
                            fontFamily: defaultFont)),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[300],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text("Tax",
                        style: TextStyle(
                            color: primary,
                            fontSize: 15,
                            fontFamily: defaultFont)),
                  ),
                  Expanded(
                    child: Text("0 %",
                        style: TextStyle(
                            color: darksecond,
                            fontSize: 15,
                            fontFamily: defaultFont)),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[300],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text("Total",
                        style: TextStyle(
                            color: primary,
                            fontSize: 15,
                            fontFamily: defaultFont)),
                  ),
                  Expanded(
                    child: Text("$tot ETB",
                        style: TextStyle(
                            color: darksecond,
                            fontSize: 15,
                            fontFamily: defaultFont)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sizedBox() {
    return SizedBox(
      height: 5,
    );
  }

  Widget _phone(String phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Phone",
            style: TextStyle(
                color: extralight, fontSize: 10, fontFamily: defaultFont)),
        Text(phone,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 15,
                fontFamily: defaultFont)),
      ],
    );
  }

  @override
  void initState() {
    _orderBloc = BlocProvider.of<OrderBloc>(context);

    _orderBloc.add(OrderShowReceived(postid: widget.postid, id: widget.id));

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
      child: BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
        if (state is OrderLoading || state is OrderInital) {
          return LoadingLogin(context);
        } else if (state is OrderFailure) {
          if (state.error == 'Not Authorized') {
            return LoggedOutLoading(context);
          } else if (state.error == 'Check Your Connection') {
            return NoInternet(context, 'order_received');
          } else {
            return ErrorMessage(context, 'order_received', state.error);
          }
        } else if (state is OrderStatusChanged) {
          Navigator.pop(context);
        } else if (state is OrderRShow) {
          return Scaffold(
            backgroundColor: Colors.grey[300],
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Material(
                  child: Container(
                    width: double.maxFinite,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            color: primary,
                            width: double.maxFinite,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Row(
                                children: <Widget>[
                                  _orderimage(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _porname(state.receivedOrder.name,
                                            state.receivedOrder.postid),
                                        _sizedBox(),
                                        _fromname(state.receivedOrder.sender,
                                            state.receivedOrder.postid),
                                        _sizedBox(),
                                        _fromaddress(
                                            state.receivedOrder.address,
                                            state.receivedOrder.town),
                                        _sizedBox(),
                                        _phone(state.receivedOrder.phone)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              child: ListView(
                                children: [
                                  _quantity(
                                      "Singles", state.receivedOrder.quantity),
                                  _price(
                                      state.receivedOrder.net,
                                      state.receivedOrder.tax,
                                      state.receivedOrder.price),
                                  _categoryPrompt(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
