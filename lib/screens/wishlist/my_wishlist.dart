import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        appBar: simpleAppBar(title: "Wishlist"),
        drawer: UserDrawer(),
        body: BlocProvider<WishlistBloc>(
            create: (context) => WishlistBloc(apiService),
            child: MyWishlistsList()));
  }
}

class MyWishlistsList extends StatefulWidget {
  @override
  _MyWishlistsListState createState() => _MyWishlistsListState();
}

class _MyWishlistsListState extends State<MyWishlistsList> {
  var _wishlistBloc;

  @override
  void initState() {
    _wishlistBloc = BlocProvider.of<WishlistBloc>(context);
    _wishlistBloc.add(WishlistFetched());
    super.initState();
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
          if (state is WishlistLoading || state is WishlistInital) {
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
              backgroundColor: Colors.grey[300],
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    color: Colors.grey[100],
                    child: Container(
                      color: Colors.grey[150],
                      child: ListView.builder(
                        itemCount: state.wishlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              print("clicked");
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) =>
                              //             WishlistDetail(
                              //               postid: state
                              //                   .receivedList[index].postid,
                              //               id: state.receivedList[index].id,
                              //               selectedCategory: state
                              //                   .receivedList[index].status,
                              //             ))).then((value) {
                              //   _orderBloc =
                              //       BlocProvider.of<WishlistBloc>(context);
                              //   _orderBloc.add(WishlistReceivedFetched());
                              return true;
                            },
                            child: WishlistProduct(
                              // state.receivedList[index].toString()
                              id: state.wishlist[index].id,
                              image: 'xx',
                              name: state.wishlist[index].name,
                              slug: state.wishlist[index].slug,
                              quantity: state.wishlist[index].quantity,
                              vendor: state.wishlist[index].vendorId,
                              postid: state.wishlist[index].postId,
                            ),
                          );
                        },
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
