import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlobalSettings extends ChangeNotifier {
  // 全局主题
  ThemeData _brightnessTheme = ThemeData.dark();


  set brightnessTheme(ThemeData brightnessTheme) {
    if (brightnessTheme != _brightnessTheme) {
      _brightnessTheme = brightnessTheme;
      notifyListeners();
    }
  }
  ThemeData get brightnessTheme => _brightnessTheme;


}