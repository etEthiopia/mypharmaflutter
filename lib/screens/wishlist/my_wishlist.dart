import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/wishlist/bloc.dart';
import 'package:mypharma/blocs/wishlist/wishlist_bloc.dart';
import 'package:mypharma/blocs/wishlist/wishlist_event.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/empty.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/page_end.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/components/wishlist_product.dart';
import 'package:mypharma/screens/orders/order_detail.dart';
import 'package:mypharma/services/services.dart';
import 'package:mypharma/blocs/order/bloc.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:mypharma/theme/font.dart';
import 'package:mypharma/components/order.dart';

class MyWishlistPage extends StatefulWidget {
  @override
  _MyWishlistPageState createState() => _MyWishlistPageState();
}

class _MyWishlistPageState extends State<MyWishlistPage> {
  @override
  Widget build(BuildContext context) {
    final apiService = RepositoryProvider.of<APIService>(context);
    return Scaffold(
        appBar: simpleAppBar(
            title:
                AppLocalizations.of(context).translate("my_wishlist_title")),
        backgroundColor: ThemeColor.background,
        drawer: UserDrawer(),
        body: MyWishlistsList()

        // BlocProvider<WishlistBloc>(
        //     create: (context) => WishlistBloc(apiService),
        //     child: MyWishlistsList())
        );
  }
}

class MyWishlistsList extends StatefulWidget {
  @override
  _MyWishlistsListState createState() => _MyWishlistsListState();
}

class _MyWishlistsListState extends State<MyWishlistsList> {
  var _wishlistBloc;
  var selectedList = [];

  @override
  void initState() {
    _wishlistBloc = BlocProvider.of<WishlistBloc>(context);
    _wishlistBloc.add(WishlistFetched());
    super.initState();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeColor.background,
          title: Text('Confirmation',
              style: TextStyle(
                color: ThemeColor.contrastText,
              )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You\'re about to Delete the Selected Items',
                    style: TextStyle(
                      color: ThemeColor.contrastText,
                    )),
                Text('Are you Sure ?',
                    style: TextStyle(
                      color: ThemeColor.contrastText,
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: ThemeColor.background,
              child: Text(
                'CANCEL',
                style: TextStyle(color: ThemeColor.primaryText),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: ThemeColor.background,
              child: Text(
                'YES',
                style: TextStyle(color: ThemeColor.darkText),
              ),
              onPressed: () {
                final _wishlistBloc = BlocProvider.of<WishlistBloc>(context);
                for (var id in selectedList) {
                  _wishlistBloc.add(WishlistDelete(id: id));
                }
                Navigator.of(context).pop();
                print(selectedList);
                setState(() {
                  selectedList = [];
                });
                print(selectedList);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _wishlistBloc = BlocProvider.of<WishlistBloc>(context);

    return BlocListener<WishlistBloc, WishlistState>(
      listener: (context, state) {
        if (state is WishlistFailure) {
          showError(state.error, context);
        }
      },
      child: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading ||
              state is WishlistInital ||
              state is WishlistCounted) {
            return LoadingLogin(context);
          } else if (state is WishlistNothingReceived) {
            return empty(context, 'my_wishlist');
          } else if (state is WishlistFailure) {
            if (state.error == 'Not Authorized') {
              return LoggedOutLoading(context);
            } else {
              return ErrorMessage(context, 'my_wishlist', state.error);
            }
          } else if (state is WishlistLoaded) {
            return Scaffold(
              backgroundColor: ThemeColor.background1,
              body: SafeArea(
                child: Container(
                    color: ThemeColor.background2,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.wishlist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return WishlistProduct(
                                // state.receivedList[index].toString()
                                id: state.wishlist[index].id,
                                image: 'xx',
                                name: state.wishlist[index].name,
                                slug: state.wishlist[index].slug,
                                quantity: state.wishlist[index].quantity,
                                vendor: state.wishlist[index].vendorId,
                                postid: state.wishlist[index].postId,
                                context: this.context,
                                isSelected: (bool value) {
                                  setState(() {
                                    if (value) {
                                      selectedList
                                          .add(state.wishlist[index].id);
                                    } else {
                                      selectedList
                                          .remove(state.wishlist[index].id);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        selectedList.length > 0
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Row(
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
                                            onPressed: () {},
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Icon(
                                                  Icons.add_shopping_cart,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                Text(
                                                  "Add to Cart",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: defaultFont),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Material(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(15),
                                              bottomRight: Radius.circular(15)),
                                          child: FlatButton(
                                            onPressed: () {
                                              _showMyDialog();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                Text(
                                                  "Delete Selected",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: defaultFont),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 1,
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
