import 'package:flutter/material.dart';

class AppThemeNotifier extends ChangeNotifier {
  //
  bool isDarkModeOn = false;

  void updateTheme() {
    isDarkModeOn = !isDarkModeOn;
    notifyListeners();
  }
}
