import 'package:flutter/material.dart';
import 'package:cake_wallet/routes.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';

class WalletMenu {
  final List<String> items = [
    'Rescan',
    'Reconnect',
    'Accounts',
    'Wallets',
    'Show seed',
    'Show keys',
    'Address book'
  ];
  final BuildContext context;

  WalletMenu(this.context);

  void action(String item) {
    switch (item) {
      case 'Rescan':
        Navigator.of(context).pushNamed(Routes.rescan);
        break;
      case 'Reconnect':
        _presentReconnectAlert(context);
        break;
      case 'Accounts':
        Navigator.of(context)
            .pushNamed(Routes.accountList);
        break;
      case 'Wallets':
        Navigator.of(context)
            .pushNamed(Routes.walletList);
        break;
      case 'Show seed':
        Navigator.of(context).pushNamed(Routes.auth,
            arguments: (isAuthenticatedSuccessfully, auth) =>
            isAuthenticatedSuccessfully
                ? Navigator.of(auth.context)
                .popAndPushNamed(Routes.seed)
                : null);
        break;
      case 'Show keys':
        Navigator.of(context).pushNamed(Routes.auth,
            arguments: (isAuthenticatedSuccessfully, auth) =>
            isAuthenticatedSuccessfully
                ? Navigator.of(auth.context)
                .popAndPushNamed(Routes.showKeys)
                : null);
        break;
      case 'Address book':
        Navigator.of(context)
            .pushNamed(Routes.addressBook);
        break;
      default:
        break;
    }
  }

  Future _presentReconnectAlert(BuildContext context) async {
    final walletStore = Provider.of<WalletStore>(context);

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Reconnection',
              textAlign: TextAlign.center,
            ),
            content: Text('Are you sure to reconnect ?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    walletStore.reconnect();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }
}