import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/stores/account_list/account_list_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/theme_changer.dart';

class AccountListPage extends BasePage {
  String get title => 'Accounts';

  @override
  Widget trailing(BuildContext context) {
    final accountListStore = Provider.of<AccountListStore>(context);

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Container(
        width: 28.0,
        height: 28.0,
        decoration:
            BoxDecoration(
                shape: BoxShape.circle,
                color: _isDarkTheme ? PaletteDark.darkThemeViolet : Palette.purple
            ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Icon(Icons.add, color: Palette.violet, size: 22.0),
            ButtonTheme(
              minWidth: 28.0,
              height: 28.0,
              child: FlatButton(
                  shape: CircleBorder(),
                  onPressed: () async {
                    await Navigator.of(context)
                        .pushNamed(Routes.accountCreation);
                    await accountListStore.updateAccountList();
                  },
                  child: Offstage()),
            )
          ],
        ));
  }

  @override
  Widget body(BuildContext context) {
    final accountListStore = Provider.of<AccountListStore>(context);
    final walletStore = Provider.of<WalletStore>(context);

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    Color _currentColor, _notCurrentColor;
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) {
      _currentColor = PaletteDark.darkThemeViolet;
      _notCurrentColor = Theme.of(context).backgroundColor;
      _isDarkTheme = true;
    }
    else {
      _currentColor = Palette.purple;
      _notCurrentColor = Colors.white;
      _isDarkTheme = false;
    }

    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      child: Observer(
        builder: (_) => ListView.builder(
            itemCount: accountListStore.accounts == null
                ? 0
                : accountListStore.accounts.length,
            itemBuilder: (BuildContext context, int index) {
              final account = accountListStore.accounts[index];

              return Observer(builder: (_) {
                final isCurrent = walletStore.account.id == account.id;

                return Slidable(
                  key: Key(account.id.toString()),
                  actionPane: SlidableDrawerActionPane(),
                  child: Container(
                    color: isCurrent ? _currentColor : _notCurrentColor,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            account.label,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: _isDarkTheme ? PaletteDark.darkThemeGrey
                                  : Colors.black
                            ),
                          ),
                          trailing: Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Palette.green),
                          ),
                          onTap: () {
                            if (isCurrent) {
                              return;
                            }

                            walletStore.setAccount(account);
                            Navigator.of(context).pop();
                          },
                        ),
                        Divider(
                          color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                              : Palette.lightGrey,
                          height: 1.0,
                        )
                      ],
                    ),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () => null,
                    )
                  ],
                );
              });
            }),
      ),
    );
  }
}
