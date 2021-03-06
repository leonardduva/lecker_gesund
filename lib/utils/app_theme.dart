import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white.withOpacity(0.85),
    primaryColor: Colors.white,
    accentColor: Color(0xff07c756),
    textTheme: TextTheme(
      headline5: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
      ),
      headline4: TextStyle(
        color: Colors.black,
        fontSize: 28.0,
        fontWeight: FontWeight.w500,
      ),
      subtitle2: TextStyle(
        color: Color(0xff696969),
        fontSize: 14.0,
      ),
    ),
  );

  //TODO: Set the right ThemeData
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.red,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
      subtitle2: TextStyle(
        color: Colors.white70,
        fontSize: 18.0,
      ),
    ),
  );
}
