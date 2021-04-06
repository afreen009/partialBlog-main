import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
  );
  var _themeMode = ThemeMode.light;

  get getTheme => _themeMode;

  toggle() {
    var _newTheme =
        (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    setTheme(_newTheme);
  }

  setTheme(themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}
