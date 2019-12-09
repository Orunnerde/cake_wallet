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
import 'package:cake_wallet/generated/i18n.dart';

class AccountListPage extends BasePage {
  String get title => S.current.accounts;

  @override
  Widget trailing(BuildContext context) {
    final accountListStore = Provider.of<AccountListStore>(context);

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = _themeChanger.getTheme() == Themes.darkTheme;

    return Container(
        width: 28.0,
        height: 28.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isDarkTheme ? PaletteDark.darkThemeViolet : Palette.purple),
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
    } else {
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
                                color: _isDarkTheme
                                    ? PaletteDark.darkThemeGrey
                                    : Colors.black),
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
                          color: _isDarkTheme
                              ? PaletteDark.darkThemeGreyWithOpacity
                              : Palette.lightGrey,
                          height: 1.0,
                        )
                      ],
                    ),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: S.of(context).edit,
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () async {
                        await Navigator.of(context)
                            .pushNamed(Routes.accountCreation, arguments: account);
                        await accountListStore.updateAccountList().then((_) {
                          if (isCurrent) walletStore.setAccount(accountListStore.accounts[index]);
                        });
                      },
                    )
                  ],
                );
              });
            }),
      ),
    );
  }
}
