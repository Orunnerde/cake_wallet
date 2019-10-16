import 'package:cake_wallet/src/stores/wallet/wallet_keys_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class ShowKeysPage extends BasePage {

  bool get isModalBackButton => true;
  String get title => 'Wallet keys';

  @override
  Widget body(BuildContext context) {
    final walletKeysStore = Provider.of<WalletKeysStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Container(
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20, right: 20),
        child: Observer(
          builder: (_) {
            Map<String, String> keysMap = {
              'View key (public):': walletKeysStore.publicViewKey,
              'View key (private):': walletKeysStore.privateViewKey,
              'Spend key (public):': walletKeysStore.publicSpendKey,
              'Spend key (private):': walletKeysStore.privateViewKey
            };

            return ListView.builder(
                itemCount: keysMap.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                          title: Text(
                            keysMap.keys.elementAt(index),
                            style: TextStyle(fontSize: 16.0),
                          ),
                          subtitle: Container(
                            padding: EdgeInsets.only(
                              top: 5.0,
                            ),
                            child: Text(
                              keysMap.values.elementAt(index),
                              style: TextStyle(
                                  fontSize: 16.0, color: Palette.wildDarkBlue),
                            ),
                          )),
                      Container(
                        padding: EdgeInsets.only(left: 30.0, right: 20.0),
                        child: Divider(
                          color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                              : Palette.lightGrey,
                          height: 1.0,
                        ),
                      ),
                    ],
                  );
                });
          },
        ));
  }
}
