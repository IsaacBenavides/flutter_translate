import 'package:flutter/material.dart';
import 'dart:io';

class LocaleProvider extends ChangeNotifier {
  Locale currentLocale = Locale(Platform.localeName.split("_").first);

  updateCurrentLocale(String locale) {
    currentLocale = Locale(locale, "");
    notifyListeners();
  }
}
