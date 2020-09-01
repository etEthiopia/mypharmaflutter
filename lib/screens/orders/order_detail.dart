import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/blocs/order/bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/services/services.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key key, this.postid, this.id}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
  final int postid;
  final int id;
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
              postid: widget.postid,
              id: widget.id,
            )));
  }
}

class ShowOrder extends StatefulWidget {
  final int postid;
  final int id;

  const ShowOrder({Key key, @required this.postid, @required this.id})
      : super(key: key);
  @override
  _ShowOrderState createState() => _ShowOrderState();
}

class _ShowOrderState extends State<ShowOrder> {
  var _orderBloc;

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
          } else {
            return NoInternet(context, 'order_received');
          }
        } else if (state is OrderRShow) {
          return Scaffold(
            backgroundColor: Colors.grey[300],
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Material(
                  color: Colors.grey[100],
                  child: Container(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: primary,
                            width: double.maxFinite,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _porname(state.receivedOrder.name,
                                    state.receivedOrder.postid),
                                _sizedBox(),
                                _fromname(state.receivedOrder.sender,
                                    state.receivedOrder.postid),
                                _sizedBox(),
                                _fromaddress(state.receivedOrder.address,
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
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
