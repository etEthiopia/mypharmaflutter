import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/cart/bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/empty.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/components/show_success.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _selectedSpot = "Home";
  String _selectedPayment = "Cash On Delivery";
  bool _editable = false;
  var _cartBloc;

  @override
  void initState() {
    _cartBloc = BlocProvider.of<CartBloc>(context);
    _cartBloc.add(CartCheckout());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _addressText() {
      return Text(
        AppLocalizations.of(context).translate("address_text"),
        style: TextStyle(
            color: ThemeColor.darkText, fontSize: 20, fontFamily: defaultFont),
      );
    }

    Widget _calculatedAmount({Address address}) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Column(
              children: <Widget>[
                Text(
                    AppLocalizations.of(context)
                        .translate("total_calculated_amount"),
                    style: TextStyle(
                        color: ThemeColor.primaryText,
                        fontSize: 15,
                        fontFamily: defaultFont)),
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                            color: ThemeColor.primaryText, width: 2)),
                    child: Text(
                      "${Cart.allTotal.toStringAsFixed(2)} ${AppLocalizations.of(context).translate("etb_text")}",
                      style: TextStyle(
                          color: ThemeColor.primaryText,
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
                          Navigator.pushReplacementNamed(context, '/my_cart');
                        },
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("back_to_cart_btn_text"),
                          style: TextStyle(
                              color: Colors.white, fontFamily: defaultFont),
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
                          bottomRight: Radius.circular(15)), ////
                      child: FlatButton(
                        onPressed: () {
                          bool addressch = false;
                          if (_fullnameController.text.length > 2 &&
                              _phoneController.text.length > 9) {
                            if (_key.currentState.validate()) {
                              addressch = true;
                            } else {
                              addressch = false;
                              setState(() {
                                _autoValidate = true;
                              });
                            }
                          }
                          _cartBloc.add(CartOrder(
                              addressChange: addressch,
                              address: address,
                              note: _noteController.text,
                              landmark: _landmarkController.text,
                              city: _cityController.text,
                              phone: _phoneController.text,
                              payment: _selectedPayment));
                        },
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("submit_order_btn_text"),
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
      );
    }

    Widget _fullnamePrompt() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: ThemeColor.background.withOpacity(0.8),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: primary, width: 2, style: BorderStyle.solid)),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: TextFormField(
              enabled: this._editable,
              style: TextStyle(color: ThemeColor.contrastText),
              decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context).translate("full_name_text"),
                  hintStyle: TextStyle(color: ThemeColor.extralightText),
                  icon: Icon(
                    Icons.person,
                    color: dark,
                  ),
                  border: InputBorder.none,
                  isDense: true),
              keyboardType: TextInputType.name,
              controller: _fullnameController,
              validator: (value) {
                if (value.isEmpty) {
                  return "Full Name cannot be empty";
                } else if (value.length > 25) {
                  return "Full Name length must be < 25";
                } else if (value.length < 3) {
                  return "Full Name length must be > 2";
                }
                return null;
              },
            ),
          ),
        ),
      );
    }

    Widget _landmarkPrompt() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: ThemeColor.background.withOpacity(0.8),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: primary, width: 2, style: BorderStyle.solid)),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: TextFormField(
              enabled: this._editable,
              style: TextStyle(color: ThemeColor.contrastText),
              decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context).translate("landmark_text"),
                  hintStyle: TextStyle(color: ThemeColor.extralightText),
                  icon: Icon(
                    Icons.local_hospital,
                    color: dark,
                  ),
                  border: InputBorder.none,
                  isDense: true),
              keyboardType: TextInputType.name,
              controller: _landmarkController,
              validator: (value) {
                if (value.isEmpty) {
                  return "Land Mark cannot be empty";
                } else if (value.length > 50) {
                  return "Land Mark length must be < 50";
                } else if (value.length < 5) {
                  return "Land Mark length must be > 6";
                }
                return null;
              },
            ),
          ),
        ),
      );
    }

    Widget _phonePrompt() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: ThemeColor.background.withOpacity(0.8),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: primary, width: 2, style: BorderStyle.solid)),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: TextFormField(
              enabled: this._editable,
              style: TextStyle(color: ThemeColor.contrastText),
              decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context).translate("phone_text"),
                  hintStyle: TextStyle(color: ThemeColor.extralightText),
                  icon: Icon(
                    Icons.phone,
                    color: dark,
                  ),
                  border: InputBorder.none,
                  isDense: true),
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              validator: (value) {
                if (value.isEmpty) {
                  return "Phone cannot be empty";
                } else if (value.length > 13) {
                  return "Phone is not appropriate";
                } else if (value.length < 10) {
                  return "Phone is not appropriate";
                }
                return null;
              },
            ),
          ),
        ),
      );
    }

    Widget _cityPrompt() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: ThemeColor.background.withOpacity(0.8),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: primary, width: 2, style: BorderStyle.solid)),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: TextFormField(
              enabled: this._editable,
              style: TextStyle(color: ThemeColor.contrastText),
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).translate("city_text"),
                  hintStyle: TextStyle(color: ThemeColor.extralightText),
                  icon: Icon(
                    Icons.location_city,
                    color: dark,
                  ),
                  border: InputBorder.none,
                  isDense: true),
              keyboardType: TextInputType.name,
              controller: _cityController,
              validator: (value) {
                if (value.isEmpty) {
                  return "City cannot be empty";
                } else if (value.length > 30) {
                  return "City length must be < 30";
                } else if (value.length < 2) {
                  return "City length must be > 2";
                }
                return null;
              },
            ),
          ),
        ),
      );
    }

    Widget _statePrompt() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: ThemeColor.background.withOpacity(0.8),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: primary, width: 2, style: BorderStyle.solid)),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: TextFormField(
              enabled: this._editable,
              style: TextStyle(color: ThemeColor.contrastText),
              decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context).translate("state_text"),
                  hintStyle: TextStyle(color: ThemeColor.extralightText),
                  icon: Icon(
                    Icons.location_city,
                    color: dark,
                  ),
                  border: InputBorder.none,
                  isDense: true),
              keyboardType: TextInputType.name,
              controller: _stateController,
              validator: (value) {
                if (value.isEmpty) {
                  return "State cannot be empty";
                } else if (value.length > 30) {
                  return "State length must be < 30";
                } else if (value.length < 2) {
                  return "State  length must be > 1";
                }
                return null;
              },
            ),
          ),
        ),
      );
    }

    List<DropdownMenuItem<dynamic>> spots = [
      DropdownMenuItem(
        value: "Home",
        child: Text(
          "Home",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
        ),
      ),
      DropdownMenuItem(
        value: "Work",
        child: Text(
          "Work",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
        ),
      ),
    ];

    Widget _spotText() {
      return Text(
        AppLocalizations.of(context).translate("spot_text"),
        style: TextStyle(
            color: ThemeColor.darkText, fontSize: 10, fontFamily: defaultFont),
      );
    }

    Widget _spotPrompt() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _spotText(),
            DropdownButtonFormField(
              dropdownColor: ThemeColor.background3,
              style: TextStyle(color: dark, fontFamily: defaultFont),
              items: this._editable ? spots : null,
              hint: Text(
                AppLocalizations.of(context).translate("spot_text"),
              ),
              value: _selectedSpot,
              onChanged: (value) {
                setState(() {
                  _selectedSpot = value;
                });
              },
              isExpanded: true,
            ),
          ],
        ),
      );
    }

    List<DropdownMenuItem<dynamic>> payments = [
      DropdownMenuItem(
        value: "Cash On Delivery",
        child: Text(
          "Cash On Delivery",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
        ),
      ),
      DropdownMenuItem(
        value: "credit",
        child: Text(
          "Credit",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
        ),
      ),
      DropdownMenuItem(
        value: "consignment",
        child: Text(
          "Consignment",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ThemeColor.darksecondText),
        ),
      ),
    ];

    Widget _paymentText() {
      return Text(
        AppLocalizations.of(context).translate("spot_text"),
        style: TextStyle(
            color: ThemeColor.darkText, fontSize: 10, fontFamily: defaultFont),
      );
    }
    //

    Widget _paymentPrompt() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _spotText(),
            DropdownButtonFormField(
              dropdownColor: ThemeColor.background3,
              style: TextStyle(color: dark, fontFamily: defaultFont),
              items: payments,
              hint: Text(
                AppLocalizations.of(context).translate("spot_text"),
              ),
              value: _selectedPayment,
              onChanged: (value) {
                setState(() {
                  _selectedPayment = value;
                });
              },
              isExpanded: true,
            ),
          ],
        ),
      );
    }

    Widget _notePrompt() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: ThemeColor.background.withOpacity(0.8),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: primary, width: 2, style: BorderStyle.solid)),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: TextFormField(
              style: TextStyle(color: ThemeColor.contrastText),
              minLines: 2,
              maxLines: 5,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).translate("note_text"),
                  hintStyle: TextStyle(color: ThemeColor.extralightText),
                  icon: Icon(
                    Icons.note,
                    color: dark,
                  ),
                  border: InputBorder.none,
                  isDense: true),
              keyboardType: TextInputType.text,
              controller: _noteController,
              validator: (value) {
                return null;
              },
            ),
          ),
        ),
      );
    }

    Widget _smallSizedBox() {
      return SizedBox(
        height: 5,
      );
    }

    Widget _editmode() {
      return SwitchListTile(
        value: _editable,
        title: Text(
          AppLocalizations.of(context).translate("edit_address_text"),
          style: TextStyle(color: ThemeColor.contrastText),
        ),
        onChanged: (value) {
          ThemeColor.ChangeTheme(value);
          setState(() {
            _editable = value;
          });
        },
      );
    }

    Widget _layout(bool por) {
      if (por) {
        return Column(children: <Widget>[
          _smallSizedBox(),
          _editable
              ? _addressText()
              : SizedBox(
                  height: 0,
                ),
          _smallSizedBox(),
          _editable
              ? _fullnamePrompt()
              : SizedBox(
                  height: 0,
                ),
          _editable
              ? _smallSizedBox()
              : SizedBox(
                  height: 0,
                ),
          _editable
              ? _phonePrompt()
              : SizedBox(
                  height: 0,
                ),
          _editable
              ? _smallSizedBox()
              : SizedBox(
                  height: 0,
                ),
          _editable
              ? _landmarkPrompt()
              : SizedBox(
                  height: 0,
                ),
          _editable
              ? _smallSizedBox()
              : SizedBox(
                  height: 0,
                ),
          _editable
              ? _cityPrompt()
              : SizedBox(
                  height: 0,
                ),
          _editable
              ? _smallSizedBox()
              : SizedBox(
                  height: 0,
                ),
          _editable
              ? _statePrompt()
              : SizedBox(
                  height: 0,
                ),
          _editable
              ? _smallSizedBox()
              : SizedBox(
                  height: 0,
                ),
          _editable
              ? _spotPrompt()
              : SizedBox(
                  height: 0,
                ),
          _editable
              ? _smallSizedBox()
              : SizedBox(
                  height: 0,
                ),
          _editmode(),
          _smallSizedBox(),
          _paymentPrompt(),
          _notePrompt()
        ]);
      }
      return Column(children: <Widget>[
        _addressText(),
        _editable
            ? Row(
                children: <Widget>[
                  Expanded(child: _fullnamePrompt()),
                  Expanded(child: _phonePrompt()),
                ],
              )
            : SizedBox(height: 0),
        _editable
            ? Row(
                children: <Widget>[
                  Expanded(child: _landmarkPrompt()),
                  Expanded(child: _cityPrompt()),
                ],
              )
            : SizedBox(height: 0),
        _editable
            ? Row(
                children: <Widget>[
                  Expanded(child: _statePrompt()),
                  Expanded(child: _spotPrompt()),
                ],
              )
            : SizedBox(height: 10),
        _editmode(),
        _smallSizedBox(),
        _notePrompt()
      ]);
    }

    return Scaffold(
        appBar: cleanAppBar(
            title: AppLocalizations.of(context).translate("checkout_text")),
        drawer: UserDrawer(),
        backgroundColor: ThemeColor.background,
        //appBar: app,
        body: SafeArea(
            child: BlocListener<CartBloc, CartState>(
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
              } else if (state is CartDoneCheckout) {
                //showSucess("Order successfully submitted", context);
                return DoneMessage(
                    context, 'order_sent', "Order successfully submitted");
              } else if (state is CartNothingReceived) {
                return empty(context, '/my_cart');
              } else if (state is CartFailure) {
                if (state.error == 'Not Authorized') {
                  return LoggedOutLoading(context);
                } else {
                  return ErrorMessage(context, '/my_cart', state.error);
                }
              } else if (state is CartOnCheckout) {
                Orientation orientation = MediaQuery.of(context).orientation;
                bool por;
                if (orientation == Orientation.portrait) {
                  por = true;
                } else {
                  por = false;
                }

                return Container(
                    color: ThemeColor.background,
                    child: Column(
                      children: [
                        Expanded(
                            child: SingleChildScrollView(
                                child: Column(
                          children: <Widget>[
                            Form(key: _key, child: _layout(por)),
                          ],
                        ))),
                        _calculatedAmount(address: state.address)
                        // Container(
                        //   child : por?Column(children: [

                        //   ],)
                        // )
                        // _calculatedAmount()
                      ],
                    ));
              } else {
                return LoadingLogin(context);
              }
            },
          ),
        )));
  }
}
