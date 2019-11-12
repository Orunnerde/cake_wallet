import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/monero/monero_wallet.dart';
import 'package:cake_wallet/src/domain/monero/subaddress_list.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/stores/subaddress_creation/subaddress_creation_state.dart';
import 'package:cake_wallet/src/domain/monero/account.dart';

part 'subaddress_creation_store.g.dart';

class SubadrressCreationStore = SubadrressCreationStoreBase
    with _$SubadrressCreationStore;

abstract class SubadrressCreationStoreBase with Store {
  SubaddressCreationState state;

  SubaddressList _subaddressList;

  StreamSubscription<Wallet> _onWalletChangeSubscription;
  StreamSubscription<Account> _onAccountChangeSubscription;
  Account _account;

  @observable
  bool isValid;

  @observable
  String errorMessage;

  SubadrressCreationStoreBase({@required WalletService walletService}) {
    state = SubaddressCreationStateInitial();

    if (walletService.currentWallet != null) {
      _onWalletChanged(walletService.currentWallet);
    }

    _onWalletChangeSubscription =
        walletService.onWalletChange.listen(_onWalletChanged);
  }

  @override
  void dispose() {
    _onWalletChangeSubscription.cancel();

    if (_onAccountChangeSubscription != null) {
      _onAccountChangeSubscription.cancel();
    }

    super.dispose();
  }

  Future add({String label}) async {
    try {
      state = SubaddressIsCreating();
      await _subaddressList.addSubaddress(
          accountIndex: _account.id, label: label);
      state = SubaddressCreatedSuccessfully();
    } catch (e) {
      state = SubaddressCreationFailure(error: e.toString());
    }
  }

  Future _onWalletChanged(Wallet wallet) async {
    if (wallet is MoneroWallet) {
      _account = wallet.account;
      _subaddressList = wallet.getSubaddress();

      _onAccountChangeSubscription = wallet.onAccountChange.listen((account) async {
        _account = account;
        _subaddressList.update(accountIndex: account.id);
      });
      return;
    }

    print('Incorrect wallet type for this operation (SubaddressList)');
  }

  void validateSubaddressName(String value) {
    String p = '''^[^`,'"]{1,20}\$''';
    RegExp regExp = new RegExp(p);
    isValid = regExp.hasMatch(value);
    errorMessage = isValid ? null : '''Subaddress name can't contain ` , ' " '''
        'symbols\nand must be between 1 and 20 characters long';
  }
}
