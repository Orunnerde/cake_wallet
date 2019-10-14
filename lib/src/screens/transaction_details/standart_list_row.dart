import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class StandartListRow extends StatelessWidget {
  final String title;
  final String value;

  StandartListRow({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title,
                style: TextStyle(
                    fontSize: 14,
                    color: _isDarkTheme ? PaletteDark.darkThemeGrey
                        : PaletteDark.darkThemeCloseButton),
                textAlign: TextAlign.left),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(value,
                  style: TextStyle(
                      fontSize: 14,
                      color: Palette.wildDarkBlue)),
            )
          ]),
    );
  }
}
