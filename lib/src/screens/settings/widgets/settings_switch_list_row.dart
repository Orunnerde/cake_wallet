import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/src/widgets/standart_switch.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';

class SettingsSwitchListRow extends StatelessWidget {
  final String title;

  SettingsSwitchListRow({@required this.title});

  Widget _getSwitch(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    if (title == 'Save recipient address') {
      return Observer(
          builder: (_) => StandartSwitch(
              value: settingsStore.shouldSaveRecipientAddress,
              onTaped: () {
                bool _currentValue = !settingsStore.shouldSaveRecipientAddress;
                settingsStore.setSaveRecipientAddress(
                    shouldSaveRecipientAddress: _currentValue);
              }));
    }

    if (title == 'Allow biometrical authentication') {
      return Observer(
          builder: (_) => StandartSwitch(
              value: settingsStore.allowBiometricalAuthentication,
              onTaped: () {
                bool _currentValue =
                    !settingsStore.allowBiometricalAuthentication;
                settingsStore.setAllowBiometricalAuthentication(
                    allowBiometricalAuthentication: _currentValue);
              }));
    }

    if (title == 'Dark mode') {
      return Observer(
          builder: (_) => StandartSwitch(
              value: settingsStore.isDarkTheme,
              onTaped: () {
                bool _currentValue = !settingsStore.isDarkTheme;
                settingsStore.saveDarkTheme(isDarkTheme: _currentValue);
                _themeChanger.setTheme(
                    _currentValue ? Themes.darkTheme : Themes.lightTheme);
              }));
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = (_themeChanger.getTheme() == Themes.darkTheme);

    return Container(
      color: _isDarkTheme ? PaletteDark.darkThemeMidGrey : Colors.white,
      child: ListTile(
          contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 16.0,
                color:
                    _isDarkTheme ? PaletteDark.darkThemeTitle : Colors.black),
          ),
          trailing: _getSwitch(context)),
    );
  }
}
