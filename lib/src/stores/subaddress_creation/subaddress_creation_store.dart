import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/monero/monero_wallet.dart';
import 'package:cake_wallet/src/domain/monero/subaddress_list.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/stores/subaddress_creation/subaddress_creation_state.dart';

part 'subaddress_creation_store.g.dart';

class SubadrressCreationStore = SubadrressCreationStoreBase
    with _$SubadrressCreationStore;

abstract class SubadrressCreationStoreBase with Store {
  SubaddressCreationState state;

  SubaddressList _subaddressList;

  StreamSubscription<Wallet> _onWalletChangeSubscription;

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
    super.dispose();
  }

  Future add({String label}) async {
    try {
      state = SubaddressIsCreating();
      await _subaddressList.addSubaddress(accountIndex: 0, label: label);
      state = SubaddressCreatedSuccessfully();
      _subaddressList.update();
    } catch (e) {
      state = SubaddressCreationFailure(error: e.toString());
    }
  }

  Future _onWalletChanged(Wallet wallet) async {
    if (wallet is MoneroWallet) {
      _subaddressList = wallet.getSubaddress();
      return;
    }

    print('Incorrect wallet type for this operation (SubaddressList)');
  }
}
