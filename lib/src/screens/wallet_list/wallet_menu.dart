import 'package:cake_wallet/src/domain/common/wallet_description.dart';
import 'package:flutter/material.dart';
import 'package:cake_wallet/routes.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/src/stores/wallet_list/wallet_list_store.dart';

class WalletMenu {

  final BuildContext context;

  WalletMenu(this.context);

  List<String>generateItemsForWalletMenu(bool isCurrentWallet) {
    List<String> items = new List<String>();

    if (!isCurrentWallet) items.add('Load wallet');
    if (isCurrentWallet) items.add('Show seed');
    if (!isCurrentWallet) items.add('Remove');
    if (isCurrentWallet) items.add('Rescan');

    return items;
  }

  void action(String item, WalletDescription wallet, bool isCurrentWallet) {
    WalletListStore _walletListStore = Provider.of<WalletListStore>(context);

    switch (item) {
      case 'Load wallet':
        Navigator.of(context).pushNamed(Routes.auth,
            arguments: (isAuthenticatedSuccessfully, auth) async {
              if (!isAuthenticatedSuccessfully) {
                return;
              }

              try {
                auth.changeProcessText('Loading ${wallet.name} wallet');
                await _walletListStore.loadWallet(wallet);
                auth.close();
                Navigator.of(context).pop();
              } catch (e) {
                auth.changeProcessText(
                    'Failed to load ${wallet.name} wallet. ${e.toString()}');
              }
        });
        break;
      case 'Show seed':
        Navigator.of(context).pushNamed(Routes.auth,
            arguments: (isAuthenticatedSuccessfully, auth) async {
              if (!isAuthenticatedSuccessfully) {
                return;
              }
              auth.close();
              Navigator.of(context).pushNamed(Routes.seed);
        });
        break;
      case 'Remove':
        Navigator.of(context).pushNamed(Routes.auth,
            arguments: (isAuthenticatedSuccessfully, auth) async {
              if (!isAuthenticatedSuccessfully) {
                return;
              }

              try {
                auth.changeProcessText('Removing ${wallet.name} wallet');
                await _walletListStore.remove(wallet);
                auth.close();
              } catch (e) {
                auth.changeProcessText(
                    'Failed to remove ${wallet.name} wallet. ${e.toString()}');
              }
        });
        break;
      case 'Rescan':
        Navigator.of(context).pushNamed(Routes.rescan);
        break;
      default:
        break;
    }
  }

}