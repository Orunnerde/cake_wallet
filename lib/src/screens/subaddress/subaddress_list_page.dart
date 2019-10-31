import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/stores/subaddress_list/subaddress_list_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class SubaddressListPage extends BasePage {
  bool get isModalBackButton => true;
  String get title => 'Subaddress list';

  SubaddressListPage();

  @override
  Widget body(BuildContext context) {
    final walletStore = Provider.of<WalletStore>(context);
    final subaddressListStore = Provider.of<SubaddressListStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    Color _currentColor, _notCurrentColor;
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) {
      _currentColor = PaletteDark.darkThemeViolet;
      _isDarkTheme = true;
    } else {
      _currentColor = Palette.purple;
      _isDarkTheme = false;
    }

    return Column(
      children: <Widget>[
        SizedBox(height: 10.0),
        Expanded(
            child: Stack(
          children: <Widget>[
            _isDarkTheme
                ? Container(
                    height: 10.0,
                  )
                : Container(
                    height: 10.0,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [Palette.lightGrey2, Colors.white],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.0, 1.0),
                    )),
                  ),
            Container(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Observer(
                  builder: (_) => ListView.separated(
                      separatorBuilder: (_, __) => Divider(
                            color: _isDarkTheme
                                ? PaletteDark.darkThemeGreyWithOpacity
                                : Palette.lightGrey,
                            height: 1.0,
                          ),
                      itemCount: subaddressListStore.subaddresses == null
                          ? 0
                          : subaddressListStore.subaddresses.length,
                      itemBuilder: (BuildContext context, int index) {
                        final subaddress =
                            subaddressListStore.subaddresses[index];
                        final isCurrent = walletStore.subaddress.address ==
                            subaddress.address;
                        final label = subaddress.label != null
                            ? subaddress.label
                            : subaddress.address;

                        return InkWell(
                          onTap: () => Navigator.of(context).pop(subaddress),
                          child: Container(
                            color: isCurrent ? _currentColor : _notCurrentColor,
                            child: Column(children: <Widget>[
                              ListTile(
                                title: Text(
                                  label,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: _isDarkTheme
                                          ? PaletteDark.darkThemeGrey
                                          : Colors.black),
                                ),
                              )
                            ]),
                          ),
                        );
                      }),
                ))
          ],
        ))
      ],
    );
  }
}
