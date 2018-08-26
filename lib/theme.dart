import 'package:flutter/material.dart';

/// Seven kinds of app theme
List<ThemeData> themeList = [
  /// System default theme
  ThemeData(),

  /// System default dark theme
  ThemeData.dark(),

  /// Red primary theme
  ThemeData(
    primaryColor: Colors.red,
    primaryColorLight: Colors.red,
    buttonColor: Colors.red,
  ),

  /// DeepPurpleAccent primary theme
  ThemeData(
    primaryColor: Colors.deepPurpleAccent,
    primaryColorLight: Colors.deepPurpleAccent,
    buttonColor: Colors.deepPurpleAccent,
  ),

  /// Green primary theme
  ThemeData(
    primaryColor: Colors.green,
    primaryColorLight: Colors.green,
    buttonColor: Colors.green,
  ),

  /// PinkAccent primary theme
  ThemeData(
    primaryColor: Colors.pinkAccent,
    primaryColorLight: Colors.pinkAccent,
    buttonColor: Colors.pinkAccent,
  ),

  /// Amber primary theme
  ThemeData(
    primaryColor: Colors.amber,
    primaryColorLight: Colors.amber,
    buttonColor: Colors.amber,
  ),
];
