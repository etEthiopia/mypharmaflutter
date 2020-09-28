import 'package:flutter/material.dart';
import 'package:mypharma/main.dart';

// class AppTheme {
//   //
//   AppTheme._();

//   static final ThemeData lightTheme = ThemeData(
//     scaffoldBackgroundColor: dark,
//     appBarTheme: AppBarTheme(
//       color: primary,
//       iconTheme: IconThemeData(
//         color: Colors.white,
//       ),
//     ),
//     colorScheme: ColorScheme.light(
//       primary: primary,
//       onPrimary: dark,
//       onBackground: Colors.white,
//       primaryVariant: darksecond,
//       secondary: accent,
//     ),
//     cardTheme: CardTheme(
//       color: Colors.teal,
//     ),
//     iconTheme: IconThemeData(
//       color: Colors.white,
//     ),
//     textTheme: TextTheme(
//       headline6: TextStyle(
//         color: darksecond,
//       ),
//       headline5: TextStyle(
//         color: dark,
//       ),
//       headline4: TextStyle(
//         color: primary,
//       ),
//       headline3: TextStyle(
//         color: accent,
//       ),
//       headline2: TextStyle(
//         color: Colors.white,
//       ),
//     ),
//   );

//   static final ThemeData darkTheme = ThemeData(
//     scaffoldBackgroundColor: darksecond,
//     appBarTheme: AppBarTheme(
//       color: Colors.black,
//       iconTheme: IconThemeData(
//         color: Colors.white,
//       ),
//     ),
//     colorScheme: ColorScheme.light(
//       primary: primary,
//       onPrimary: dark,
//       primaryVariant: darksecond,
//       secondary: accent,
//     ),
//     cardTheme: CardTheme(
//       color: Colors.teal,
//     ),
//     iconTheme: IconThemeData(
//       color: Colors.black,
//     ),
//     textTheme: TextTheme(
//       headline6: TextStyle(
//         color: darksecond,
//       ),
//       headline5: TextStyle(
//         color: dark,
//       ),
//       headline4: TextStyle(
//         color: primary,
//       ),
//       headline3: TextStyle(
//         color: accent,
//       ),
//       headline2: TextStyle(
//         color: Colors.white,
//       ),
//     ),
//   );
// }

class ThemeColor {
  static bool isDark;

  static Color dark;
  static Color darksecond;
  static Color primary;
  static Color light;
  static Color extralight;
  static Color accent = Color(0XFF4BCCD1);
  static Color gold = Color(0XFFFED501);
  static Color background;
  static Color card;
  static Color background1;
  static Color background2;
  static Color background3;
  static Color appBar;
  static Color darksecondText;
  static Color darkText;
  static Color primaryText;
  static Color lightText;
  static Color extralightText;
  static Color contrastText;
  static Color darksecondBtn;
  static Color darkBtn;
  static Color primaryBtn;
  static Color lightBtn;
  static Color extralightBtn;

  ThemeColor({bool isDark}) {
    ThemeColor.isDark = isDark;

    if (ThemeColor.isDark) {
      dark = ddark;
      darksecond = ddarksecond;
      primary = dprimary;
      light = dlight;
      card = dbackground3;
      extralight = dextralight;
      background = dbackground;
      background1 = dbackground1;
      background2 = dbackground2;
      background3 = dbackground3;
      accent = dbackground3;
      darksecondText = Colors.white;
      appBar = dbackground3;
      darkText = Colors.grey[100];
      primaryText = Colors.grey[200];
      lightText = dark;
      extralightText = darksecond;
      contrastText = Colors.white;
      darksecondBtn = Color(0xFF343434); //343434
      darkBtn = Color(0xFF292929); //292929
      primaryBtn = Color(0xFF242424); //242424
      lightBtn = Color(0xFF191919); //191919
      extralightBtn = Color(0xFF141414); //141414
    } else {
      dark = ldark;
      darksecond = ldarksecond;
      primary = lprimary;
      light = llight;
      extralight = lextralight;
      background = lbackground;
      background1 = lbackground1;
      background2 = lbackground2;
      background3 = lbackground3;
      card = lbackground;
      appBar = primary;
      darksecondText = darksecond;
      darkText = dark;
      primaryText = primary;
      lightText = light;
      extralightText = extralight;
      contrastText = Colors.black;
      darksecondBtn = darksecond;
      darkBtn = dark;
      primaryBtn = primary;
      lightBtn = light;
      extralightBtn = extralight;
    }
  }

  //Light Colors

  Color ldark = Color(0XFF005F7F);

  Color ldarksecond = Color(0xFF013450);

  Color lprimary = Color(0XFF0191C5);

  Color llight = Color(0XFF7BA4B2);

  Color lextralight = Color(0XFFB4D0E8);

  Color lbackground = Colors.white;

  Color lbackground1 = Colors.grey[300];

  Color lbackground2 = Colors.grey[100];

  Color lbackground3 = Colors.grey[50];

  //Dark Colors

  Color ddark = Color(0XFF7BA4B2);

  Color ddarksecond = Color(0XFFB4D0E8);

  Color dprimary = Color(0XFF0191C5);

  Color dlight = Color(0XFF005F7F);

  Color dextralight = Color(0xFF013450);

  Color dbackground = Colors.black;

  Color dbackground1 = Colors.grey[700];

  Color dbackground2 = Colors.grey[800];

  Color dbackground3 = Colors.grey[900];

  static ChangeTheme(bool value) async {
    await storage.write(key: "theme", value: value.toString());
  }

  static Future<bool> getTheme() async {
    bool theme;
    try {
      String current = await storage.read(key: "theme");
      if (current == "true") {
        theme = true;
      } else {
        theme = false;
      }
      return theme;
    } catch (e) {
      return false;
    }
  }
}

Color dark = Color(0XFF005F7F);

Color darksecond = Color(0xFF013450);

Color primary = Color(0XFF0191C5);

Color light = Color(0XFF7BA4B2);

Color extralight = Color(0XFFB4D0E8);

Color accent = Color(0XFF4BCCD1);

Color gold = Color(0XFFFED501);
