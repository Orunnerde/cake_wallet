import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class WelcomePage extends BasePage {
  static const _aspectRatioImage = 1.26;
  static const _baseWidth = 411.43;
  final _image = Image.asset('assets/images/welcomeImg.png');
  final _cakeLogo = Image.asset('assets/images/cake_logo.png');

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = (_themeChanger.getTheme() == Themes.darkTheme);

    return Scaffold(
        backgroundColor: _isDarkTheme ? Theme.of(context).backgroundColor
            : backgroundColor,
        resizeToAvoidBottomPadding: false,
        body: SafeArea(child: body(context)),
    );
  }

  @override
  Widget body(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = _screenWidth < _baseWidth ? 0.76 : 1.0;

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = (_themeChanger.getTheme() == Themes.darkTheme);

    return Column(children: <Widget>[
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AspectRatio(
              aspectRatio: _aspectRatioImage,
              child: FittedBox(child: _image, fit: BoxFit.fill)),
          Positioned(bottom: 0.0, child: _cakeLogo)
        ],
      ),
      Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'WELCOME\nTO CAKE WALLET',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: textScaleFactor,
                textAlign: TextAlign.center,
              ),
              Text(
                'Awesome wallet\nfor Monero',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Palette.lightBlue,
                ),
                textScaleFactor: textScaleFactor,
                textAlign: TextAlign.center,
              ),
              Text(
                'Please make selection below to\ncreate or recover your wallet.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Palette.lightBlue,
                ),
                textScaleFactor: textScaleFactor,
                textAlign: TextAlign.center,
              )
            ]),
      ),
      Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
              children: <Widget>[
                PrimaryButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.newWalletFromWelcome);
                  },
                  text: 'Create New',
                  color: _isDarkTheme ? PaletteDark.darkThemePurpleButton
                      : Palette.purple,
                  borderColor: _isDarkTheme ? PaletteDark.darkThemePurpleButtonBorder
                      : Palette.deepPink,
                ),
                SizedBox(height: 10),
                PrimaryButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.restoreOptions);
                  },
                  color: _isDarkTheme ? PaletteDark.darkThemeBlueButton
                      : Palette.brightBlue,
                  borderColor: _isDarkTheme ? PaletteDark.darkThemeBlueButtonBorder
                      : Palette.cloudySky,
                  text: 'Restore wallet',
                )
              ]))
    ]);
  }
}
