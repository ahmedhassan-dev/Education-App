import 'package:flutter/material.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
      disabledColor: Colors.white,
      // textTheme: Theme.of(context).textTheme.apply(
      //       bodyColor: Colors.white,
      //       displayColor: Colors.white,
      //     ),
      appBarTheme: const AppBarTheme(color: Color.fromRGBO(42, 42, 42, 1)),
      scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      primaryColor: const Color.fromRGBO(244, 67, 54, 1),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Colors.white),
        labelStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.white),
        floatingLabelStyle: const TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ));
}
