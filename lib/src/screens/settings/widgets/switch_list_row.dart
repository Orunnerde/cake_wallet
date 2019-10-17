import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/src/widgets/standart_switch.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';

class SwitchListRow extends StatelessWidget {
  final String title;

  SwitchListRow({@required this.title});

  Widget _getSwitch(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    if (title == 'Save recipient address') {
      return Observer(
          builder: (_) => StandartSwitch(
              value: settingsStore.shouldSaveRecipientAddress,
              onTaped: () {
                bool _currentValue = !settingsStore.shouldSaveRecipientAddress;
                settingsStore.setSaveRecipientAddress(shouldSaveRecipientAddress: _currentValue);
              }
          )
      );
    }

    if (title == 'Allow biometrical authentication') {
      return Observer(
          builder: (_) => StandartSwitch(
              value: settingsStore.shouldAllowBiometricalAuthentication,
              onTaped: () {
                bool _currentValue = !settingsStore.shouldAllowBiometricalAuthentication;
                settingsStore.setAllowBiometricalAuthentication(shouldAllowBiometricalAuthentication: _currentValue);
              }
          )
      );
    }

    if (title == 'Dark mode') {
      return Observer(
          builder: (_) => StandartSwitch(
              value: settingsStore.isDarkTheme,
              onTaped: () {
                bool _currentValue = !settingsStore.isDarkTheme;
                settingsStore.saveDarkTheme(isDarkTheme: _currentValue);
                if (_currentValue) {
                  _themeChanger.setTheme(Themes.darkTheme);
                } else {
                  _themeChanger.setTheme(Themes.lightTheme);
                }
              }
          )
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = (_themeChanger.getTheme() == Themes.darkTheme);

    return Container(
      color: _isDarkTheme? PaletteDark.darkThemeMidGrey : Colors.white,
      child: ListTile(
          contentPadding:
          EdgeInsets.only(left: 20.0, right: 20.0),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 16.0,
                color: _isDarkTheme ? PaletteDark.darkThemeTitle
                    : Colors.black
            ),
          ),
          trailing: _getSwitch(context)
      ),
    );
  }

}