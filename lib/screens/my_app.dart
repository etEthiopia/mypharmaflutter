import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/auth/bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mypharma/blocs/wishlist/bloc.dart';
import 'package:mypharma/models/models.dart';
import 'package:mypharma/screens/auth/joinus.dart';
import 'package:mypharma/screens/auth/login.dart';
import 'package:mypharma/screens/auth/registerphy.dart';
import 'package:mypharma/screens/cart/my_cart.dart';
import 'package:mypharma/screens/front_splash.dart';
import 'package:mypharma/screens/orders/order_sent.dart';
import 'package:mypharma/screens/posts/feed.dart';
import 'package:mypharma/screens/products/browse_products.dart';
import 'package:mypharma/screens/products/meds_info.dart';
import 'package:mypharma/screens/products/show_med_info.dart';
import 'package:mypharma/screens/products/stock.dart';
import 'package:mypharma/screens/orders/order_received.dart';
import 'package:mypharma/screens/settings/settings.dart';
import 'package:mypharma/screens/wishlist/my_wishlist.dart';
import 'package:mypharma/theme/colors.dart';

import 'cart/checkout.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale locale;

  @override
  void initState() {
    AppLocalizations.getCurrentLangAndTheme().then((locale) => {
          setState(() {
            this.locale = locale;
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyPharma',
      locale: locale,
      supportedLocales: [Locale('en', 'US'), Locale('am', 'ET')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      routes: {
        '/login': (context) => Login(),
        '/joinus': (context) => JoinUs(),
        '/registerphy': (context) => RegisterPhy(),
        '/feed': (context) => Feed(),
        '/stock': (context) => Stock(),
        '/browse_products': (context) => BrowseProduct(isSearch: false),
        '/search_products': (context) => BrowseProduct(isSearch: true),
        '/meds_info': (context) => MedsInfo(),
        '/show_meds_info': (context) => ShowMedInfo(),
        '/order_received': (context) => ReceivedOrderPage(),
        '/order_sent': (context) => SentOrderPage(),
        '/my_wishlist': (context) => MyWishlistPage(),
        '/my_cart': (context) => MyCartPage(),
        '/settings': (context) => Settings(),
        '/checkout': (context) => CheckOutScreen()
      },
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (locale == null) {
            return FrontSplash();
          } else {
            if (state is AuthLoading) {
              return FrontSplash();
            }
            if (state is AuthAuthenticated) {
              // show home page
              if (state.user.role == Role.wholeseller) {
                final _wishlistBloc = BlocProvider.of<WishlistBloc>(context);
                _wishlistBloc.add(WishlistCount());
                return Stock();
              } else if (state.user.role == Role.importer) {
                return ReceivedOrderPage();
              } else {
                return Feed();
              }
            }
            // otherwise show login page
            return Feed();
          }
        },
      ),
    );

    // return FutureBuilder(
    //   future: AppLocalizations.getCurrentLang(),
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.none:
    //       case ConnectionState.waiting:
    //         // Return some loading widget
    //         return Center(child: CircularProgressIndicator());
    //       case ConnectionState.done:
    //         if (snapshot.hasError) {
    //           locale = Locale('en', 'US');
    //         } else {
    //           locale = snapshot.data;
    //         }
    //         return loadApp();
    //     }
    //   },
    // );

    // MaterialApp(
    //     locale: this.locale,
    //     localizationsDelegates: [
    //       MyLocalizationsDelegate(),
    //       GlobalMaterialLocalizations.delegate,
    //       GlobalWidgetsLocalizations.delegate,
    //     ],
    //     supportedLocales: [
    //       const Locale('en', 'US'), // English
    //       const Locale('ar', ''), // Arabic
    //     ],
    //     home: HomeScreen());
  }
}

// class MyApp extends StatelessWidget {
//   static Locale locale;

//   @override
//   Widget build(BuildContext context) {
//     Locale locale;

//     MaterialApp loadApp() {
//       print("VALUES ${locale.languageCode} : ${ThemeColor.isDark}");
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'MyPharma',
//         locale: locale,
//         supportedLocales: [Locale('en', 'US'), Locale('am', 'ET')],
//         localizationsDelegates: [
//           AppLocalizations.delegate,
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//         ],
//         localeResolutionCallback: (locale, supportedLocales) {
//           for (var supportedLocale in supportedLocales) {
//             if (supportedLocale.languageCode == locale.languageCode &&
//                 supportedLocale.countryCode == locale.countryCode) {
//               return supportedLocale;
//             }
//           }
//           return supportedLocales.first;
//         },
//         routes: {
//           '/login': (context) => Login(),
//           '/joinus': (context) => JoinUs(),
//           '/registerphy': (context) => RegisterPhy(),
//           '/feed': (context) => Feed(),
//           '/stock': (context) => Stock(),
//           '/browse_products': (context) => BrowseProduct(),
//           '/order_received': (context) => ReceivedOrderPage(),
//           '/order_sent': (context) => SentOrderPage(),
//           '/my_wishlist': (context) => MyWishlistPage(),
//           '/settings': (context) => Settings(),
//         },
//         home: BlocBuilder<AuthBloc, AuthState>(
//           builder: (context, state) {
//             if (state is AuthLoading) {
//               return FrontSplash();
//             }
//             if (state is AuthAuthenticated) {
//               // show home page
//               if (state.user.role == Role.wholeseller) {
//                 return Stock();
//               } else if (state.user.role == Role.importer) {
//                 return ReceivedOrderPage();
//               } else {
//                 return Feed();
//               }
//             }
//             // otherwise show login page
//             return Feed();
//           },
//         ),
//       );
//     }

//     return FutureBuilder(
//       future: AppLocalizations.getCurrentLang(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.none:
//           case ConnectionState.waiting:
//             // Return some loading widget
//             return Center(child: CircularProgressIndicator());
//           case ConnectionState.done:
//             if (snapshot.hasError) {
//               locale = Locale('en', 'US');
//             } else {
//               locale = snapshot.data;
//             }
//             return loadApp();
//         }
//       },
//     );
//   }
// }
