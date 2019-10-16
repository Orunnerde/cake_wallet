import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/src/domain/common/language.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/theme_changer.dart';

const Map<String,String> _languages = {
  'en' : 'English',
  'ru' : 'Русский (Russian)',
  'es' : 'Español (Spanish)',
  'ja' : '日本 (Japanese)',
  'ko' : '한국어 (Korean)',
  'hi' : 'हिंदी (Hindi)',
  'de' : 'Deutsch (German)',
  'zh' : '中文 (Chinese)',
  'pt' : 'Português (Portuguese)',
  'pl' : 'Polskie (Polish)',
  'nl' : 'Nederlands (Dutch)'
};

class ChangeLanguage extends BasePage{
  get title => 'Change language';

  @override
  Widget body(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);
    final currentLanguage = Provider.of<Language>(context);

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Container(
      padding: EdgeInsets.only(
          top: 10.0,
          bottom: 10.0
      ),
      child: ListView.builder(
        itemCount: _languages.values.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            margin: EdgeInsets.only(
                top: 10.0,
                bottom: 10.0
            ),
            color: _isDarkTheme ? PaletteDark.darkThemeMidGrey : Palette.lightGrey2,
            child: ListTile(
              title: Text(_languages.values.elementAt(index),
                style: TextStyle(
                    fontSize: 16.0,
                    color: _isDarkTheme ? PaletteDark.darkThemeTitle : Colors.black
                ),
              ),
              onTap: (){
                settingsStore.saveLanguageCode(languageCode: _languages.keys.elementAt(index));
                currentLanguage.setCurrentLanguage(_languages.keys.elementAt(index));
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}