import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/generated/i18n.dart';
import 'package:cake_wallet/src/stores/account_list/account_list_store.dart';
import 'package:cake_wallet/src/screens/accounts/widgets/account_tile.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/src/widgets/alert_background.dart';

class AccountListPage extends StatefulWidget {
  AccountListPage({@required this.accountListStore});

  final AccountListStore accountListStore;

  @override
  AccountListPageForm createState() => AccountListPageForm(accountListStore);
}

class AccountListPageForm extends State<AccountListPage> {
  AccountListPageForm(this.accountListStore);

  final AccountListStore accountListStore;
  final closeButton = Image.asset('assets/images/close.png');

  ScrollController controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletStore = Provider.of<WalletStore>(context);

    return AlertBackground(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Text(
                  S.of(context).choose_account,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      color: Colors.white
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                child: GestureDetector(
                  onTap: () => null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    child: Container(
                      height: 296,
                      color: Theme.of(context).accentTextTheme.title.backgroundColor,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              child: Observer(
                                  builder: (_) {
                                    final accounts = accountListStore.accounts;

                                    return CupertinoScrollbar(
                                      controller: controller,
                                      child: ListView.separated(
                                        controller: controller,
                                        separatorBuilder: (context, index) => Divider(
                                          color: Theme.of(context).dividerColor,
                                          height: 1,
                                        ),
                                        itemCount: accounts == null ? 0 : accounts.length,
                                        itemBuilder: (context, index) {
                                          final account = accounts[index];

                                          return Observer(
                                              builder: (_) {
                                                final isCurrent = walletStore.account.id == account.id;

                                                return AccountTile(
                                                    isCurrent: isCurrent,
                                                    accountName: account.label,
                                                    onTap: () {
                                                      if (isCurrent) {
                                                        return;
                                                      }

                                                      walletStore.setAccount(account);
                                                      Navigator.of(context).pop();
                                                    }
                                                );
                                              }
                                          );
                                        },
                                      )
                                    );
                                  }
                              )
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.of(context)
                                  .pushNamed(Routes.accountCreation);
                              accountListStore.updateAccountList();
                            },
                            child: Container(
                              height: 62,
                              color: Colors.white,
                              padding: EdgeInsets.only(left: 24, right: 24),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.add,
                                      color: PaletteDark.darkNightBlue,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        S.of(context).create_new_account,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: PaletteDark.darkNightBlue,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Positioned(
              bottom: 50,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                  ),
                  child: Center(
                    child: closeButton,
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}
