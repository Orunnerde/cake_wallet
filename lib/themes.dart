import 'package:flutter/material.dart';
import 'palette.dart';

class Themes {

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Lato',
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    hintColor: Palette.lightBlue,
    focusColor: Palette.lightGrey, // focused and enabled border color for text fields
    primaryTextTheme: TextTheme(
      title: TextStyle(
        color: Colors.black
      ),
      caption: TextStyle(
        color: Colors.black
      ),
      button: TextStyle(
        color: Colors.black,
        backgroundColor: Palette.purple, // button purple background color
        decorationColor: Palette.deepPink // button pink border color
      ),
      headline: TextStyle(
        color: Colors.black // account list tile, contact page
      ),
      subtitle: TextStyle(
        color: Palette.wildDarkBlue // filters
      ),
      subhead: TextStyle(
        color: Colors.black // transaction raw, trade raw
      )
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
      selectedColor: Palette.cakeGreen,
      disabledColor: Palette.wildDarkBlue,
      color: Palette.switchBackground,
      borderColor: Palette.switchBorder
    ),
    selectedRowColor: Palette.purple,
    dividerTheme: DividerThemeData(
      color: Palette.lightGrey
    ),
    accentTextTheme: TextTheme(
      caption: TextStyle(
        backgroundColor: Palette.brightBlue, // button blue background color
        decorationColor: Palette.cloudySky // button blue border color
      ),
      button: TextStyle(
        backgroundColor: Palette.indigo, // button indigo background color
        decorationColor: Palette.deepIndigo // button indigo border color
      )
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Lato',
    brightness: Brightness.dark,
    backgroundColor: PaletteDark.darkThemeBackgroundDark,
    hintColor: PaletteDark.darkThemeGrey,
    focusColor: PaletteDark.darkThemeGreyWithOpacity, // focused and enabled border color for text fields
    primaryTextTheme: TextTheme(
      title: TextStyle(
        color: PaletteDark.darkThemeTitle
      ),
      caption: TextStyle(
        color: Colors.white
      ),
      button: TextStyle(
        color: Palette.wildDarkBlue,
        backgroundColor: PaletteDark.darkThemePurpleButton, // button purple background color
        decorationColor: PaletteDark.darkThemePurpleButtonBorder // button pink border color
      ),
      headline: TextStyle(
        color: PaletteDark.darkThemeGrey // account list tile, contact page
      ),
      subtitle: TextStyle(
        color: PaletteDark.darkThemeGrey // filters
      ),
      subhead: TextStyle(
        color: Palette.blueGrey // transaction raw, trade raw
      )
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
      selectedColor: Palette.cakeGreen,
      disabledColor: Palette.wildDarkBlue,
      color: PaletteDark.switchBackground,
      borderColor: PaletteDark.darkThemeMidGrey
    ),
    selectedRowColor: PaletteDark.darkThemeViolet,
    dividerTheme: DividerThemeData(
      color: PaletteDark.darkThemeGreyWithOpacity
    ),
    accentTextTheme: TextTheme(
      caption: TextStyle(
        backgroundColor: PaletteDark.darkThemeBlueButton, // button blue background color
        decorationColor: PaletteDark.darkThemeBlueButtonBorder // button blue border color
      ),
      button: TextStyle(
        backgroundColor: PaletteDark.darkThemeIndigoButton, // button indigo background color
        decorationColor: PaletteDark.darkThemeIndigoButtonBorder // button indigo border color
      )
    ),
  );

}