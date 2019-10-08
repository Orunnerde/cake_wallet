import 'package:flutter/material.dart';
import 'palette.dart';

class Themes {

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Lato',
    brightness: Brightness.light,
    backgroundColor: Colors.white,
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Lato',
    brightness: Brightness.dark,
    backgroundColor: PaletteDark.darkThemeBackground,
  );

}