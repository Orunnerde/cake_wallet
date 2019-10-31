import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/stores/wallet_seed/wallet_seed_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class SeedPage extends BasePage {
  bool get isModalBackButton => true;
  String get title => 'Seed';
  static final image = Image.asset('assets/images/seed_image.png');

  @override
  Widget body(BuildContext context) {
    final walletSeedStore = Provider.of<WalletSeedStore>(context);
    String _seed;

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme)
      _isDarkTheme = true;
    else
      _isDarkTheme = false;

    return Form(
        child: GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Center(
        child: Container(
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              image,
              Container(
                margin: EdgeInsets.only(
                    left: 30.0, top: 10.0, right: 30.0, bottom: 20.0),
                child: Observer(builder: (_) {
                  _seed = walletSeedStore.seed;
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: _isDarkTheme
                                            ? PaletteDark.darkThemeDarkGrey
                                            : Palette.lightGrey))),
                            padding: EdgeInsets.only(bottom: 20.0),
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              walletSeedStore.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: _isDarkTheme
                                      ? Palette.wildDarkBlue
                                      : Colors.black),
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        walletSeedStore.seed,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: _isDarkTheme
                                ? PaletteDark.darkThemeTitle
                                : Colors.black),
                      )
                    ],
                  );
                }),
              ),
              Container(
                margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: Column(
                  children: <Widget>[
                    /*Text(
                      'Please share, copy, or write down your seed. The seed '
                      'is used to recover your wallet. This is your PRIVATE '
                      'seed. DO NOT SHARE this seed with other people!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Palette.lightBlue,
                      ),
                    ),*/
                    Container(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                              child: Container(
                            padding: EdgeInsets.only(right: 8.0),
                            child: PrimaryButton(
                                onPressed: () => Share.text(
                                    'Share seed', _seed, 'text/plain'),
                                color: _isDarkTheme
                                    ? PaletteDark.darkThemePurpleButton
                                    : Palette.purple,
                                borderColor: _isDarkTheme
                                    ? PaletteDark.darkThemePurpleButtonBorder
                                    : Palette.deepPink,
                                text: 'Save'),
                          )),
                          Flexible(
                              child: Container(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Builder(
                                builder: (context) => PrimaryButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: _seed));
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Copied to Clipboard'),
                                        backgroundColor: Colors.green,
                                        duration: Duration(milliseconds: 1500),
                                      ),
                                    );
                                  },
                                  text: 'Copy',
                                  color: _isDarkTheme
                                      ? PaletteDark.darkThemeBlueButton
                                      : Palette.brightBlue,
                                  borderColor: _isDarkTheme
                                      ? PaletteDark.darkThemeBlueButtonBorder
                                      : Palette.cloudySky,
                                ),
                            )
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
