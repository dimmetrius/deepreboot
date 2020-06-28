import 'package:flutter/material.dart';

final int _greenPrimary = 0xFF76FF03;
final int _yellowAccentColor = 0xFFFFFF04;
final Color greenPrimary = Color(_greenPrimary);
final Color yellowAccentColor = Color(_yellowAccentColor);
final MaterialColor materialColor = MaterialColor(
  _greenPrimary,
  <int, Color>{
    50: Color(_greenPrimary),
    100: Color(_greenPrimary),
    200: Color(_greenPrimary),
    300: Color(_greenPrimary),
    400: Color(_greenPrimary),
    500: Color(_greenPrimary),
    600: Color(_greenPrimary),
    700: Color(_greenPrimary),
    800: Color(_greenPrimary),
    900: Color(_greenPrimary),
  },
);

final ThemeData themeData = ThemeData(
  primarySwatch: materialColor,
  primaryColor: greenPrimary,
  accentColor: yellowAccentColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
