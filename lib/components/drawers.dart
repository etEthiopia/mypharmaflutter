import 'package:mypharma/theme/colors.dart';
import 'package:flutter/material.dart';

Drawer anonDrawer() {
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("My Pharma"),
          accountEmail: Text("Stay Connected"),
          currentAccountPicture: GestureDetector(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/logo/logo50.png'),
            ),
          ),
          decoration: BoxDecoration(color: primary),
        ),
        InkWell(
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  Icons.rss_feed,
                  color: primary,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Feed",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  "New Products",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Drawer pharmacyDrawer() {
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("Solo-da Pharmacy"),
          accountEmail: Text("solodapharma@gmail.com"),
          currentAccountPicture: GestureDetector(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/page/question.jpg'),
            ),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  Icons.rss_feed,
                  color: primary,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Feed",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  "New Products",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  Icons.person,
                  color: primary,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Logout",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Drawer wholesellerDrawer() {
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("Solo-da Pharmacy"),
          accountEmail: Text("solodapharma@gmail.com"),
          currentAccountPicture: GestureDetector(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/page/question.jpg'),
            ),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  "Orders Received",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  Icons.rss_feed,
                  color: primary,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Feed",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  "New Products",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  Icons.person,
                  color: primary,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Logout",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Drawer importerDrawer() {
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("Solo-da Pharmacy"),
          accountEmail: Text("solodapharma@gmail.com"),
          currentAccountPicture: GestureDetector(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/page/question.jpg'),
            ),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  "Orders Received",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  Icons.rss_feed,
                  color: primary,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Feed",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  "New Products",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
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
                  Icons.person,
                  color: primary,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Logout",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darksecond),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
