import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/monero/monero_wallet.dart';
import 'package:cake_wallet/src/domain/monero/account.dart';
import 'package:cake_wallet/src/domain/monero/account_list.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';

part 'account_list_store.g.dart';

class AccountListStore = AcountListStoreBase with _$AccountListStore;

abstract class AcountListStoreBase with Store {
  @observable
  List<Account> accounts;

  @observable
  bool isValid;

  @observable
  String errorMessage;

  AccountList _accountList;
  StreamSubscription<Wallet> _onWalletChangeSubscription;

  AcountListStoreBase({@required WalletService walletService}) {
    accounts = [];

    if (walletService.currentWallet != null) {
      _onWalletChanged(walletService.currentWallet);
    }

    _onWalletChangeSubscription =
        walletService.onWalletChange.listen(_onWalletChanged);
  }

  @override
  void dispose() {
    _onWalletChangeSubscription.cancel();
    super.dispose();
  }

  Future updateAccountList() async {
    await _accountList.refresh();
    accounts = _accountList.getAll();
  }

  Future addAccount({String label}) async {
    await _accountList.addAccount(label: label);
    await updateAccountList();
  }

  Future renameAccount({int index, String label}) async {
    await _accountList.setLabelSubaddress(accountIndex: index, label: label);
    await updateAccountList();
  }

  Future _onWalletChanged(Wallet wallet) async {
    // if (_onSubaddressesChangeSubscription != null) {
    //   _onSubaddressesChangeSubscription.cancel();
    // }

    if (wallet is MoneroWallet) {
      _accountList = wallet.getAccountList();
      // _onSubaddressesChangeSubscription = _accountList.subaddresses
      //     .listen((subaddress) => subaddresses = subaddress);
      await updateAccountList();

      return;
    }

    print('Incorrect wallet type for this operation (AccountList)');
  }

  void validateAccountName(String value) {
    String p = '^[a-zA-Z0-9_]{1,15}\$';
    RegExp regExp = new RegExp(p);
    isValid = regExp.hasMatch(value);
    errorMessage = isValid
        ? null
        : 'Account name can only contain letters, '
            'numbers\nand must be between 1 and 15 characters long';
  }
}
