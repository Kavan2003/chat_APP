import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.blue,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
            fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.blue,
        textTheme: ButtonTextTheme.primary,
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: Colors.blueAccent)
          .copyWith(background: Colors.white),
    );
  }
}
