import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class SettingRawWidgetListRow extends StatelessWidget {
  final WidgetBuilder widgetBuilder;

  SettingRawWidgetListRow({@required this.widgetBuilder});

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = (_themeChanger.getTheme() == Themes.darkTheme);

    return Container(
      color: _isDarkTheme ? PaletteDark.darkThemeMidGrey : Colors.white,
      child: widgetBuilder(context) ?? Container(),
    );
  }
}
