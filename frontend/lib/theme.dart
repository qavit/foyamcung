import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.green,
  primaryColor: Colors.teal,
  fontFamily: 'JFOpenHuninn',
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.green,
  ).copyWith(
    secondary: Colors.greenAccent,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.teal,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.teal,
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.teal[700],
  ),
); 