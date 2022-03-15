import 'package:flutter/material.dart';

final themeData = ThemeData(
  brightness: Brightness.dark,
  // inputDecorationTheme: InputDecorationTheme(
  //   border: OutlineInputBorder(),
  // ),
);

final iconTextButtonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(EdgeInsets.zero),
  minimumSize: MaterialStateProperty.all(Size(40, 40)),
  animationDuration: Duration(milliseconds: 100),
  elevation: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.pressed) ? 0.0 : 6.0),
  splashFactory: NoSplash.splashFactory,
  foregroundColor: MaterialStateProperty.all(Colors.white),
  backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
  overlayColor: MaterialStateProperty.all(Colors.transparent),
);
