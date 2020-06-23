import 'package:flutter/material.dart';
import 'package:cake_wallet/routes.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/generated/i18n.dart';
import 'package:cake_wallet/src/stores/wallet_list/wallet_list_store.dart';
import 'package:cake_wallet/src/domain/common/wallet_description.dart';
import 'package:cake_wallet/src/screens/auth/auth_page.dart';
import 'package:cake_wallet/src/widgets/alert_with_two_actions.dart';

class WalletMenu {
  WalletMenu(this.context);

  final BuildContext context;

  final List<String> listItems = [
    S.current.wallet_list_load_wallet,
    S.current.show_seed,
    S.current.remove,
    S.current.rescan
  ];

  final List<Color> listColors = [
    Colors.blue,
    Colors.orange,
    Colors.red,
    Colors.green
  ];

  final List<Image> listImages = [
    Image.asset('assets/images/load.png', height: 32, width: 32, color: Colors.white),
    Image.asset('assets/images/eye_action.png', height: 32, width: 32, color: Colors.white),
    Image.asset('assets/images/trash.png', height: 32, width: 32, color: Colors.white),
    Image.asset('assets/images/scanner.png', height: 32, width: 32, color: Colors.white)
  ];

  List<String> generateItemsForWalletMenu(bool isCurrentWallet) {
    final items = List<String>();

    if (!isCurrentWallet) items.add(listItems[0]);
    if (isCurrentWallet) items.add(listItems[1]);
    if (!isCurrentWallet) items.add(listItems[2]);
    if (isCurrentWallet) items.add(listItems[3]);

    return items;
  }

  List<Color> generateColorsForWalletMenu(bool isCurrentWallet) {
    final colors = List<Color>();

    if (!isCurrentWallet) colors.add(listColors[0]);
    if (isCurrentWallet) colors.add(listColors[1]);
    if (!isCurrentWallet) colors.add(listColors[2]);
    if (isCurrentWallet) colors.add(listColors[3]);

    return colors;
  }

  List<Image> generateImagesForWalletMenu(bool isCurrentWallet) {
    final images = List<Image>();

    if (!isCurrentWallet) images.add(listImages[0]);
    if (isCurrentWallet) images.add(listImages[1]);
    if (!isCurrentWallet) images.add(listImages[2]);
    if (isCurrentWallet) images.add(listImages[3]);

    return images;
  }

  void action(int index, WalletDescription wallet) {
    final _walletListStore = Provider.of<WalletListStore>(context);

    switch (index) {
      case 0:
        showDialog<void>(
          context: context,
          builder: (dialogContext) {
            return AlertWithTwoActions(
              alertTitle: S.of(context).wallets,
              alertContent: S.of(context).confirm_change_wallet,
              leftButtonText: S.of(context).ok,
              rightButtonText: S.of(context).cancel,
              actionLeftButton: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pushNamed(Routes.auth, arguments:
                    (bool isAuthenticatedSuccessfully, AuthPageState auth) async {
                    if (!isAuthenticatedSuccessfully) {
                      return;
                    }

                    try {
                      auth.changeProcessText(
                          S.of(context).wallet_list_loading_wallet(wallet.name));
                      await _walletListStore.loadWallet(wallet);
                      auth.close();
                      Navigator.of(context).pop();
                    } catch (e) {
                      auth.changeProcessText(S
                          .of(context)
                          .wallet_list_failed_to_load(wallet.name, e.toString()));
                    }
                  });
                },
              actionRightButton: () => Navigator.of(dialogContext).pop()
            );
          }
        );
        break;
      case 1:
        Navigator.of(context).pushNamed(Routes.auth, arguments:
            (bool isAuthenticatedSuccessfully, AuthPageState auth) async {
          if (!isAuthenticatedSuccessfully) {
            return;
          }
          auth.close();
          await Navigator.of(context).pushNamed(Routes.seed);
        });
        break;
      case 2:
        Navigator.of(context).pushNamed(Routes.auth, arguments:
            (bool isAuthenticatedSuccessfully, AuthPageState auth) async {
          if (!isAuthenticatedSuccessfully) {
            return;
          }

          try {
            auth.changeProcessText(
                S.of(context).wallet_list_removing_wallet(wallet.name));
            await _walletListStore.remove(wallet);
            auth.close();
          } catch (e) {
            auth.changeProcessText(S
                .of(context)
                .wallet_list_failed_to_remove(wallet.name, e.toString()));
          }
        });
        break;
      case 3:
        Navigator.of(context).pushNamed(Routes.rescan);
        break;
      default:
        break;
    }
  }
}
