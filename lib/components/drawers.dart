import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/auth/bloc.dart';
import 'package:mypharma/blocs/wishlist/bloc.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/main.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authBloc = BlocProvider.of<AuthBloc>(context);

    _logout() {
      _authBloc.add(UserLoggedOut());
      var route = ModalRoute.of(context);
      if (route != null) {
        if (route.settings.name.length != 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/', ModalRoute.withName('/'));
        } else {
          print("ROUTE SETTINGS: " + route.settings.name.length.toString());
        }
      }
    }

    _login() {
      Navigator.pushReplacementNamed(context, '/login');
    }

    _stock() {
      Navigator.pushReplacementNamed(context, '/stock');
    }

    _browseProduct() {
      Navigator.pushReplacementNamed(context, '/browse_products');
    }

    _ordersent() {
      Navigator.pushReplacementNamed(context, '/order_sent');
    }

    _wishlist() {
      Navigator.pushReplacementNamed(context, '/my_wishlist');
    }

    _cart() {
      Navigator.pushReplacementNamed(context, '/my_cart');
    }

    _orderrecevied() {
      Navigator.pushReplacementNamed(context, '/order_received');
    }

    _feed() {
      Navigator.pushReplacementNamed(context, '/feed');
    }

    _joinus() {
      Navigator.pushNamed(context, '/joinus');
    }

    _search() {
      Navigator.pushReplacementNamed(context, '/search_products');
    }

    _medsinfo() {
      Navigator.pushReplacementNamed(context, '/meds_info');
    }

    _dashboard() {
      Navigator.pushReplacementNamed(context, '/home');
    }

    _settings() {
      Navigator.pushReplacementNamed(context, '/settings');
    }

    Widget _error(BuildContext context, String url, dynamic error) {
      return CircleAvatar(
        backgroundColor: ThemeColor.background,
        backgroundImage: AssetImage('assets/images/logo/logo50.png'),
      );
    }

    Widget _progress(
        BuildContext context, String url, dynamic downloadProgress) {
      return Center(
          child: CircularProgressIndicator(value: downloadProgress.progress));
    }

    Widget loadimage(String image) {
      return CachedNetworkImage(
        imageUrl: '${SERVER_IP_FILE}news/$image',
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        progressIndicatorBuilder: _progress,
        errorWidget: _error,
      );
      // return CachedNetworkImage(
      //   imageUrl: '${SERVER_IP_FILE}news/$image',
      //   progressIndicatorBuilder: _progress,
      //   errorWidget: _error,
      // );
    }

    Widget anonDrawer({
      String profile,
      String email,
    }) {
      return Container(
        color: ThemeColor.background,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(profile),
              accountEmail: Text(email),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: ThemeColor.background,
                  child: CircleAvatar(
                    backgroundColor: ThemeColor.background,
                    backgroundImage:
                        AssetImage('assets/images/logo/logo50.png'),
                  ),
                ),
              ),
              decoration: BoxDecoration(color: ThemeColor.primaryBtn),
            ),
            InkWell(
              onTap: () {
                _login();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("drawer_login_text"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.local_pharmacy,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("drawer_join_text"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                _feed();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.rss_feed,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("feed_screen_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _browseProduct();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.new_releases,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("browse_product_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _search();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("search_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _joinus();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.description,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("drawer_whats_is_mypharma_text"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                _settings();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("settings_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget pharmacyDrawer({String profile, String email, String image}) {
      return Container(
        color: ThemeColor.background,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(profile),
              accountEmail: Text(email),
              currentAccountPicture: GestureDetector(
                child: Container(child: loadimage(image)),
              ),
              decoration: BoxDecoration(color: ThemeColor.primaryBtn),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("cart_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _wishlist();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                              .translate("my_wishlist_title") +
                          "   ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),

                    // wishlist == 0
                    //     ? Text(
                    //         AppLocalizations.of(context)
                    //             .translate("my_wishlist_title"),
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             color: ThemeColor.darksecondText),
                    //       )
                    //     : Badge(
                    //         badgeColor: dark,
                    //         badgeContent: Text(
                    //           wishlist.toString(),
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    //         child: Text(
                    //           AppLocalizations.of(context)
                    //                   .translate("my_wishlist_title") +
                    //               "   ",
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //               color: ThemeColor.darksecondText),
                    //         )),
                  ],
                ),
              ),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.list,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("order_sent_screen_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _dashboard();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.home,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("profile_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                _feed();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.rss_feed,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("feed_screen_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.new_releases,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("browse_product_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _search();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("search_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _medsinfo();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.info_outline,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("meds_info_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                _settings();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("settings_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () async {
                _logout();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("logout_text"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget wholesellerDrawer({String profile, String email, String image}) {
      return Container(
        color: ThemeColor.background,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(profile),
              accountEmail: Text(email),
              currentAccountPicture: GestureDetector(
                child: Container(child: loadimage(image)),
              ),
              decoration: BoxDecoration(color: ThemeColor.primaryBtn),
            ),
            InkWell(
              onTap: () {
                _ordersent();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.list,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("order_sent_screen_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _orderrecevied();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.list,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("order_received_screen_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _cart();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Cart.count == 0
                        ? Text(
                            AppLocalizations.of(context)
                                .translate("cart_title"),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ThemeColor.darksecondText),
                          )
                        : Badge(
                            badgeColor: dark,
                            badgeContent: Text(
                              Cart.count.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            child: Text(
                              AppLocalizations.of(context)
                                      .translate("cart_title") +
                                  "   ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ThemeColor.darksecondText),
                            )),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _wishlist();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),

                    Text(
                      AppLocalizations.of(context)
                              .translate("my_wishlist_title") +
                          "   ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                    // wishlist == 0
                    //     ? Text(
                    //         AppLocalizations.of(context)
                    //             .translate("my_wishlist_title"),
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             color: ThemeColor.darksecondText),
                    //       )
                    //     : Badge(
                    //         badgeColor: dark,
                    //         badgeContent: Text(
                    //           wishlist.toString(),
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    //         child: Text(
                    //           AppLocalizations.of(context)
                    //                   .translate("my_wishlist_title") +
                    //               "   ",
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //               color: ThemeColor.darksecondText),
                    //         )),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _dashboard();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.home,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("profile_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                _feed();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.rss_feed,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("feed_screen_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _stock();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.image_aspect_ratio,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("stock_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _browseProduct();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.new_releases,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("browse_product_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _search();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("search_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _medsinfo();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.info_outline,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("meds_info_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                _settings();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("settings_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () async {
                _logout();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("logout_text"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget importerDrawer({String profile, String email, String image}) {
      return Container(
        color: ThemeColor.background,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(profile),
              accountEmail: Text(email),
              currentAccountPicture: GestureDetector(
                child: Container(child: loadimage(image)),
              ),
              decoration: BoxDecoration(color: ThemeColor.primaryBtn),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.list,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("order_received_screen_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _dashboard();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.home,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("profile_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                _feed();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.rss_feed,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("feed_screen_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _stock();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.image_aspect_ratio,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("stock_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _browseProduct();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.new_releases,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("browse_product_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _search();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("search_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _medsinfo();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.info_outline,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("meds_info_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                _settings();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("settings_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () async {
                _logout();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("logout_text"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget physicianDrawer({String profile, String email, String image}) {
      return Container(
        color: ThemeColor.background,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(profile),
              accountEmail: Text(email),
              currentAccountPicture: GestureDetector(
                child: Container(child: loadimage(image)),
              ),
              decoration: BoxDecoration(color: ThemeColor.primaryBtn),
            ),
            InkWell(
              onTap: () {
                _dashboard();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.home,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("profile_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                _feed();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.rss_feed,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("feed_screen_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.new_releases,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate("browse_product_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _search();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("search_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _medsinfo();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.info_outline,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("meds_info_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                _settings();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("settings_title"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () async {
                _logout();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: ThemeColor.primaryText,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("logout_text"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.darksecondText),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return BlocListener<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthFailure) {
        showError(state.error, context);
      }
    }, child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) {
        Widget drawer;
        String uname = state.user.name;
        String email = state.user.email;
        String image = state.user.profileimg;
        switch (state.user.role) {
          case Role.admin:
            drawer = anonDrawer(profile: "MyPharma", email: "Stay Connected");
            break;
          case Role.importer:
            drawer = importerDrawer(profile: uname, email: email, image: image);
            break;
          case Role.wholeseller:
            drawer =
                wholesellerDrawer(profile: uname, email: email, image: image);

            break;
          case Role.pharmacist:
            drawer = pharmacyDrawer(profile: uname, email: email, image: image);
            break;
          case Role.phyisican:
            drawer =
                physicianDrawer(profile: uname, email: email, image: image);
            break;
          default:
            drawer = anonDrawer(
                profile: AppLocalizations.of(context)
                    .translate("drawer_app_name_text"),
                email: AppLocalizations.of(context)
                    .translate("drawer_slogan_text"));
        }
        return Drawer(child: drawer);
      }
      return Drawer(
          child: anonDrawer(
              profile: AppLocalizations.of(context)
                  .translate("drawer_app_name_text"),
              email: AppLocalizations.of(context)
                  .translate("drawer_slogan_text")));
    }));
  }
}
