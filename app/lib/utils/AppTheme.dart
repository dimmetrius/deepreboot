import 'package:flutter/material.dart';

final int _greenPrimaryValue = 0xFF76FF03;
final int _yellowAccentColor = 0xFFFFFF04;
final MaterialColor materialColor = MaterialColor(
  _greenPrimaryValue,
  <int, Color>{
    50: Color(_greenPrimaryValue),
    100: Color(_greenPrimaryValue),
    200: Color(_greenPrimaryValue),
    300: Color(_greenPrimaryValue),
    400: Color(_greenPrimaryValue),
    500: Color(_greenPrimaryValue),
    600: Color(_greenPrimaryValue),
    700: Color(_greenPrimaryValue),
    800: Color(_greenPrimaryValue),
    900: Color(_greenPrimaryValue),
  },
);

final ThemeData themeData = ThemeData(
  primarySwatch: materialColor,
  primaryColor: Color(_greenPrimaryValue),
  accentColor: Color(_yellowAccentColor),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
