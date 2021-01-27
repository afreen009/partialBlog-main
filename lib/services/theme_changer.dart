import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
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

  final darkTheme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.black,
      fontFamily: 'Nunito',
      brightness: Brightness.dark,
      backgroundColor: const Color(0xFF212121),
      accentColor: Colors.white,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: AppTheme.primaryColor,
          backgroundColor: Colors.white),
      dividerColor: Colors.black12,
      inputDecorationTheme: InputDecorationTheme(
        // enabledBorder: new OutlineInputBorder(
        //   borderSide:  BorderSide(color: AppTheme.primaryColor ),
        // ),
        focusedBorder: new OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.transparent,
          centerTitle: true,
          textTheme: TextTheme(
              headline6: TextStyle(
            color: Colors.white,
            fontFamily: 'Nunito',
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ))));
}

class AppTheme {
  static const Color primaryColor = Color(0xff38b6ff);
}
