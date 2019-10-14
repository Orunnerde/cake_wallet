import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

const List<String> languagesList = const <String>[
  'English',
  'Русский (Russian)',
  'Español (Spanish)',
  '日本 (Japanese)',
  '한국어 (Korean)',
  'हिंदी (Hindi)',
  'Deutsch (German)',
  '中文 (Chinese)',
  'Português (Portuguese)',
  'Polskie (Polish)',
  'Nederlands (Dutch)'
];

class ChangeLanguage extends StatefulWidget{

  @override
  createState() => ChangeLanguageState();

}

class ChangeLanguageState extends State<ChangeLanguage>{

  final _backArrowImage = Image.asset('assets/images/back_arrow.png');
  final _backArrowImageDarkTheme = Image.asset('assets/images/back_arrow_dark_theme.png');

  @override
  Widget build(BuildContext context) {

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CupertinoNavigationBar(
        leading: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
            onPressed: (){Navigator.pop(context);},
            child: _isDarkTheme ? _backArrowImageDarkTheme : _backArrowImage
          ),
        ),
        middle: Text('Change language',
          style: TextStyle(
            fontSize: 16.0,
            color: _isDarkTheme ? PaletteDark.darkThemeTitle : Colors.black
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        border: null,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            top: 10.0,
            bottom: 10.0
          ),
          child: ListView.builder(
            itemCount: languagesList.length,
            itemBuilder: (BuildContext context, int index){
              return Container(
                margin: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0
                ),
                color: _isDarkTheme ? PaletteDark.darkThemeMidGrey : Palette.lightGrey2,
                child: ListTile(
                  title: Text(languagesList[index],
                    style: TextStyle(
                      fontSize: 16.0,
                      color: _isDarkTheme ? PaletteDark.darkThemeTitle : Colors.black
                    ),
                  ),
                ),
              );
            }
          ),
        )
      ),
    );
  }

}