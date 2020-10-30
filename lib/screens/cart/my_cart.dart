import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/cart/bloc.dart';
import 'package:mypharma/blocs/cart/cart_bloc.dart';
import 'package:mypharma/blocs/cart/cart_event.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/cart_item.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/empty.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/page_end.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/screens/orders/order_detail.dart';
import 'package:mypharma/services/services.dart';
import 'package:mypharma/blocs/order/bloc.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';
import 'package:mypharma/components/order.dart';

class MyCartPage extends StatefulWidget {
  @override
  _MyCartPageState createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: simpleAppBar(
            title: AppLocalizations.of(context).translate("cart_title")),
        backgroundColor: ThemeColor.background,
        drawer: UserDrawer(),
        body: MyCartsList());
  }
}

class MyCartsList extends StatefulWidget {
  @override
  _MyCartsListState createState() => _MyCartsListState();
}

class _MyCartsListState extends State<MyCartsList> {
  var _cartBloc;
  var selectedList = [];

  @override
  void initState() {
    _cartBloc = BlocProvider.of<CartBloc>(context);
    _cartBloc.add(CartFetched());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartFailure) {
          showError(state.error, context);
        }
      },
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading ||
              state is CartInital ||
              state is CartCounted) {
            return LoadingLogin(context);
          } else if (state is CartNothingReceived) {
            return empty(context, 'my_cart');
          } else if (state is CartFailure) {
            if (state.error == 'Not Authorized') {
              return LoggedOutLoading(context);
            } else {
              return ErrorMessage(context, 'my_cart', state.error);
            }
          } else if (state is CartLoaded) {
            return Scaffold(
              backgroundColor: ThemeColor.background1,
              body: SafeArea(
                child: Container(
                    color: ThemeColor.background2,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.cartItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CartItem(
                                // state.receivedList[index].toString()
                                id: state.cartItems[index].id,

                                name: state.cartItems[index].name,
                                udate: state.cartItems[index].date,
                                amount: state.cartItems[index].quantity,
                                price: state.cartItems[index].price,
                                prodId: state.cartItems[index].postId,
                                context: this.context,
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(
                            children: [
                              Column(
                                children: <Widget>[
                                  Text("Your Total Calculated Amount",
                                      style: TextStyle(
                                          color: ThemeColor.lightText,
                                          fontSize: 15,
                                          fontFamily: defaultFont)),
                                  Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          border: Border.all(
                                              color: primary, width: 2)),
                                      child: Text(
                                        "${Cart.allTotal} ETB",
                                        style: TextStyle(
                                            color: primary,
                                            fontSize: 15,
                                            fontFamily: defaultFont),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Material(
                                        color: ThemeColor.darkBtn,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomLeft: Radius.circular(15)),
                                        child: FlatButton(
                                          onPressed: () {
                                            Navigator.pushReplacementNamed(
                                                context, '/browse_products');
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate(
                                                    "browse_product_title"),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: defaultFont),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Material(
                                        color: ThemeColor.primaryBtn,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            bottomRight: Radius.circular(15)),
                                        child: FlatButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Proceed to Checkout",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                fontFamily: defaultFont),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            );
          } else {
            return LoadingLogin(context);
          }
        },
      ),
    );
  }
}
