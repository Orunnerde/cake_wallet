import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/widgets/blockchain_height_widget.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/palette.dart';

class RescanPage extends BasePage {
  final blockchainKey = GlobalKey();
  @override
  String get title => 'Rescan';

  @override
  Widget body(BuildContext context) {
    final _themeChanger = Provider.of<ThemeChanger>(context);
    final _isDarkTheme = _themeChanger.getTheme() == Themes.darkTheme;

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        BlockchainHeightWidget(key: blockchainKey),
        PrimaryButton(
            text: 'Rescan',
            onPressed: () => null,
            color:
                _isDarkTheme ? PaletteDark.darkThemePurpleButton : Palette.purple,
            borderColor: _isDarkTheme
                ? PaletteDark.darkThemePurpleButtonBorder
                : Palette.deepPink)
      ]),
    );
  }
}
