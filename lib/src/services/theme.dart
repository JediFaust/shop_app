import 'package:flutter/material.dart';

// ignore: public_member_api_docs
ThemeData myTheme() {
  return ThemeData(
    // All Theme Data used anywhere on app
    textTheme: const TextTheme(
      button: TextStyle(fontSize: 20, color: Colors.white),
      headline1: TextStyle(
          fontSize: 32, color: Colors.black, fontWeight: FontWeight.bold),
      headline2: TextStyle(
          fontSize: 16, color: Colors.amber, fontWeight: FontWeight.bold),
      headline3: TextStyle(fontSize: 14, color: Colors.amber),
      headline4: TextStyle(
        fontSize: 24,
        color: Colors.amber,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(fontSize: 22, color: Colors.grey),
      bodyText2: TextStyle(fontSize: 20, color: Colors.black45),
      subtitle1: TextStyle(fontSize: 14, color: Colors.black),
    ),
    splashColor: Colors.blue,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(380, 50), // Enter Media Query settings later
        padding: const EdgeInsets.symmetric(vertical: 12),
        primary: Colors.amber,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    ),
  );
}
