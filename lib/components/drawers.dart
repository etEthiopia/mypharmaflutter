import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/blocs/auth/bloc.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/main.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authBloc = BlocProvider.of<AuthBloc>(context);

    _logout() async {
      await _authBloc.add(UserLoggedOut());
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
      print('sup');
      Navigator.pushReplacementNamed(context, '/my_wishlist');
    }

    _orderrecevied() {
      Navigator.pushReplacementNamed(context, '/order_received');
    }

    _feed() {
      Navigator.pushReplacementNamed(context, '/feed');
    }

    Widget _error(BuildContext context, String url, dynamic error) {
      return CircleAvatar(
        backgroundColor: Colors.white,
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
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(profile),
              accountEmail: Text(email),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage('assets/images/logo/logo50.png'),
                  ),
                ),
              ),
              decoration: BoxDecoration(color: primary),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Log In",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Join as a Physician",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Feed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Browse Products",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      Icons.search,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Search",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      Icons.description,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "What is MyPharma",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(profile),
              accountEmail: Text(email),
              currentAccountPicture: GestureDetector(
                child: Container(child: loadimage(image)),
              ),
              decoration: BoxDecoration(color: primary),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Cart",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Wishlist",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      Icons.list,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Orders Sent",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      Icons.home,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Feed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Browse Products",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      Icons.search,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Search",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Logout",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(profile),
              accountEmail: Text(email),
              currentAccountPicture: GestureDetector(
                child: Container(child: loadimage(image)),
              ),
              decoration: BoxDecoration(color: primary),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Orders Sent",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Orders Received",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      Icons.shopping_cart,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Cart",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Wishlist",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      Icons.home,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Feed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Stock",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Browse Products",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      Icons.search,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Search",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Logout",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(profile),
              accountEmail: Text(email),
              currentAccountPicture: GestureDetector(
                child: Container(child: loadimage(image)),
              ),
              decoration: BoxDecoration(color: primary),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.list,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Orders Received",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      Icons.home,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Feed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Stock",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Browse Products",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      Icons.search,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Search",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Logout",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(profile),
              accountEmail: Text(email),
              currentAccountPicture: GestureDetector(
                child: Container(child: loadimage(image)),
              ),
              decoration: BoxDecoration(color: primary),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.home,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Feed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Browse Products",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      Icons.search,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Search",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
                      color: primary,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Logout",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darksecond),
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
        switch (state.user.role) {
          case Role.admin:
            drawer = anonDrawer(profile: "MyPharma", email: "Stay Connected");
            break;
          case Role.importer:
            drawer = importerDrawer(
                profile: state.user.name, email: state.user.email);
            break;
          case Role.wholeseller:
            drawer = wholesellerDrawer(
                profile: state.user.name, email: state.user.email);
            break;
          case Role.pharmacist:
            drawer = pharmacyDrawer(
                profile: state.user.name,
                email: state.user.email,
                image: state.user.profileimg);
            break;
          case Role.phyisican:
            drawer = physicianDrawer(
                profile: state.user.name, email: state.user.email);
            break;
          default:
            drawer = anonDrawer(profile: "MyPharma", email: "Stay Connected");
        }
        return Drawer(child: drawer);
      }
      return Drawer(
          child: anonDrawer(profile: "MyPharma", email: "Stay Connected"));
    }));
  }
}
