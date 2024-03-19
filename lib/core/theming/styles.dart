import 'package:flutter/material.dart';

abstract class Styles {
  static const titleLarge22 = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      decoration: TextDecoration.none);
  static const bodyLarge16 = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      decoration: TextDecoration.none);
  static const bodyMedium14 = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      decoration: TextDecoration.none);

  static const needHelpTextStyle = TextStyle(
    fontSize: 20,
    decoration: TextDecoration.underline,
    decorationColor: Colors.blue,
    decorationThickness: 2,
  );
}
