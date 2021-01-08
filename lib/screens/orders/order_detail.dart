import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/order/bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/services/services.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';
import 'package:url_launcher/url_launcher.dart';

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
        appBar: cleanAppBar(
            title: AppLocalizations.of(context)
                .translate("order_detail_screen_title")),
        backgroundColor: ThemeColor.background,
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
      padding: const EdgeInsets.only(
        top: 20,
        left: 10,
        right: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context).translate("order_status_text"),
              style: TextStyle(
                  color: ThemeColor.primaryText,
                  fontSize: 10,
                  fontFamily: defaultFont)),
          DropdownButtonFormField(
            dropdownColor: ThemeColor.background3,
            style:
                TextStyle(color: ThemeColor.darkText, fontFamily: defaultFont),
            items: categories,
            hint: Text("Status"),
            value: widget.selectedCategory,
            onChanged: (value) {
              setState(() {
                widget.selectedCategory = value;
              });
              _orderBloc
                  .add(OrderStatusChangeOrdered(status: value, id: widget.id));
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
                color: ThemeColor.extralightText,
                fontSize: 10,
                fontFamily: defaultFont)),
        Text(name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 16,
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
                color: ThemeColor.extralightText,
                fontSize: 10,
                fontFamily: defaultFont)),
        Text(name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 12,
                fontFamily: defaultFont)),
      ],
    );
  }

  Widget _fromaddress(String address, String town) {
    return Text(address + " : " + town,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.white, fontSize: 12, fontFamily: defaultFont));
  }

  Widget _invoice(String number, String date) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Invoice",
              style: TextStyle(
                  color: ThemeColor.primaryText,
                  fontSize: 12,
                  fontFamily: defaultFont)),
          Divider(
            color: ThemeColor.extralightText,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Invoice No.",
                      style: TextStyle(
                          color: ThemeColor.primaryText,
                          fontSize: 10,
                          fontFamily: defaultFont)),
                  Text(number,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: ThemeColor.darksecondText,
                          fontSize: 15,
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
                    Text("Invoice Date",
                        style: TextStyle(
                            color: ThemeColor.primaryText,
                            fontSize: 10,
                            fontFamily: defaultFont)),
                    Text(date,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ThemeColor.darksecondText,
                            fontSize: 15,
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

  Widget _quantity(String type, int amount) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Quantity",
              style: TextStyle(
                  color: ThemeColor.primaryText,
                  fontSize: 12,
                  fontFamily: defaultFont)),
          Divider(
            color: ThemeColor.extralightText,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Amount",
                      style: TextStyle(
                          color: ThemeColor.primaryText,
                          fontSize: 10,
                          fontFamily: defaultFont)),
                  Text(amount.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: ThemeColor.darksecondText,
                          fontSize: 16,
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
                            color: ThemeColor.primaryText,
                            fontSize: 10,
                            fontFamily: defaultFont)),
                    Text(type,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ThemeColor.darksecondText,
                            fontSize: 16,
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

  Widget _note(String note) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Note",
              style: TextStyle(
                  color: ThemeColor.primaryText,
                  fontSize: 12,
                  fontFamily: defaultFont)),
          SizedBox(
            height: 5,
          ),
          Text(note,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: ThemeColor.darksecondText,
                  fontSize: 15,
                  fontFamily: defaultFont)),
        ],
      ),
    );
  }

  Widget _price(double sub, int amount, double singleprice, double tax) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Price Details",
              style: TextStyle(
                  color: ThemeColor.primaryText,
                  fontSize: 12,
                  fontFamily: defaultFont)),
          Divider(
            color: ThemeColor.extralightText,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text("Subtotal",
                        style: TextStyle(
                            color: ThemeColor.primaryText,
                            fontSize: 12,
                            fontFamily: defaultFont)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                        "${sub.toStringAsFixed(2)}" +
                            AppLocalizations.of(context).translate("etb_text") +
                            " ($amount * ${singleprice.toStringAsFixed(2)})",
                        style: TextStyle(
                            color: ThemeColor.darksecondText,
                            fontSize: 12,
                            fontFamily: defaultFont)),
                  ),
                ],
              ),
              Divider(
                color: ThemeColor.background1,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text("Tax",
                        style: TextStyle(
                            color: ThemeColor.primaryText,
                            fontSize: 12,
                            fontFamily: defaultFont)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text("$tax %",
                        style: TextStyle(
                            color: ThemeColor.darksecondText,
                            fontSize: 12,
                            fontFamily: defaultFont)),
                  ),
                ],
              ),
              Divider(
                color: ThemeColor.background1,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text("Total",
                        style: TextStyle(
                            color: ThemeColor.primaryText,
                            fontSize: 12,
                            fontFamily: defaultFont)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                        "${(sub + (sub * tax)).toStringAsFixed(2)} " +
                            AppLocalizations.of(context).translate("etb_text"),
                        style: TextStyle(
                            color: ThemeColor.darksecondText,
                            fontSize: 12,
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
        Row(
          children: [
            Text(phone + "      ",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: defaultFont)),
            Expanded(
              child: InkWell(
                onTap: () {
                  launch("tel://$phone");
                },
                child: Text(
                  "CALL NOW",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontFamily: defaultFont),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Future<void> initState() {
    _orderBloc = BlocProvider.of<OrderBloc>(context);

    _orderBloc.add(OrderShowReceived(postid: widget.postid, id: widget.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderFailure) {
          showError(state.error, context);
        }
      },
      child: BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
        print("STATE: " + state.toString());
        if (state is OrderLoading || state is OrderInital) {
          return LoadingLogin(context);
        } else if (state is OrderFailure) {
          if (state.error == 'Not Authorized') {
            return LoggedOutLoading(context);
          } else {
            return ErrorMessage(context, 'order_received', state.error);
          }
        } else if (state is OrderStatusChanged) {
          return Container(
              padding:
                  EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Image.asset(
                      'assets/images/figures/done.png',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: ThemeColor.light,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context).translate("status_updated"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ThemeColor.darkText,
                        fontSize: 25,
                        fontFamily: defaultFont),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: ThemeColor.darkBtn,
                      borderRadius: BorderRadius.circular(15.0),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context, widget.selectedCategory);
                        },
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("continue_btn_text"),
                          style: TextStyle(
                              color: Colors.white, fontFamily: defaultFont),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        } else if (state is OrderRShow) {
          return Scaffold(
            backgroundColor: ThemeColor.background1,
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
                            color: ThemeColor.primaryBtn,
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
                              color: ThemeColor.background,
                              child: ListView(
                                children: [
                                  _categoryPrompt(),
                                  _quantity(
                                      "Singles", state.receivedOrder.quantity),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  _invoice(
                                      "MP-" +
                                          state.receivedOrder.id.toString() +
                                          "/" +
                                          state.receivedOrder.date
                                              .substring(0, 4),
                                      state.receivedOrder.date
                                          .substring(0, 10)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  _price(
                                    state.receivedOrder.net,
                                    state.receivedOrder.quantity,
                                    state.receivedOrder.price,
                                    state.receivedOrder.tax,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  _note(state.receivedOrder.note),
                                  SizedBox(
                                    height: 10,
                                  ),
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
