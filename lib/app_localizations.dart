import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypharma/main.dart';
import 'package:mypharma/theme/colors.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key];
  }

  static Future<Locale> getCurrentLangAndTheme() async {
    var str = await storage.read(key: "lang");
    Locale locale;
    final theme = await ThemeColor.getTheme();
    if (theme) {
      ThemeColor(isDark: true);
    } else {
      ThemeColor(isDark: false);
    }

    if (str != null) {
      if (str.length == 5) {
        locale = Locale(str.substring(0, 2), str.substring((3)));
        return locale;
      }
    }
    locale = Locale('en', 'US');
    return locale;
  }

  static Future<bool> storelang(Locale l) async {
    if (l.languageCode == 'en' && l.countryCode == 'US') {
      await storage.delete(key: 'lang');
      return true;
    } else {
      await storage.write(
          key: 'lang', value: '${l.languageCode}-${l.countryCode}');
      return true;
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'am'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
