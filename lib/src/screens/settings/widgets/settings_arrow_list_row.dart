import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';

class SettingsArrowListRow extends StatelessWidget {
  final VoidCallback onTaped;
  final String title;
  final _cakeArrowImage = Image.asset('assets/images/cake_arrow.png');

  SettingsArrowListRow({@required this.onTaped, this.title});

  @override
  Widget build(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = (_themeChanger.getTheme() == Themes.darkTheme);

    return Container(
      color: _isDarkTheme? PaletteDark.darkThemeMidGrey : Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
        title: Observer(
            builder: (_) => Text(
              settingsStore.itemHeaders[title],
              style: TextStyle(
                  fontSize: 16.0,
                  color: _isDarkTheme ? PaletteDark.darkThemeTitle
                      : Colors.black
              ),
            )),
        trailing: _cakeArrowImage,
        onTap: onTaped
      ),
    );
  }

}