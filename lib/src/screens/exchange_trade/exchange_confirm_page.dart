import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/domain/exchange/trade.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/generated/i18n.dart';

class ExchangeConfirmPage extends BasePage {
  String get title => S.current.copy_ID;

  final Trade trade;

  ExchangeConfirmPage({@required this.trade});

  @override
  Widget body(BuildContext context) {

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = _themeChanger.getTheme() == Themes.darkTheme;

    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 80.0, right: 80.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        S.of(context).exchange_result_write_down_trade_ID,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0,
                          color: _isDarkTheme ? Palette.wildDarkBlue : Colors.black
                        ),
                      ),
                      SizedBox(
                        height: 70.0,
                      ),
                      Text(
                        S.of(context).trade_ID(trade.id),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0,
                            color: _isDarkTheme ? Palette.wildDarkBlue : Colors.black
                        ),
                      ),
                      SizedBox(
                        height: 70.0,
                      ),
                      PrimaryButton(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: trade.id));
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                              S.of(context).copied_to_clipboard,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            backgroundColor: Colors.green,
                          ));
                        },
                        text: S.of(context).copy_ID,
                        color: _isDarkTheme ? PaletteDark.darkThemeBlueButton
                            : Palette.brightBlue,
                        borderColor: _isDarkTheme ? PaletteDark.darkThemeBlueButtonBorder
                            : Palette.cloudySky,
                      )
                    ],
                  ),
                ))),
        Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0),
          child: PrimaryButton(
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(Routes.exchangeTrade, arguments: trade),
              text: S.of(context).saved_the_trade_ID,
              color: _isDarkTheme ? PaletteDark.darkThemePurpleButton : Palette.purple,
              borderColor: _isDarkTheme ? PaletteDark.darkThemePurpleButtonBorder : Palette.deepPink,
          ),
        )
      ],
    );
  }
}
