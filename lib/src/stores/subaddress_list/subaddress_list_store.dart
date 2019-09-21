import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/monero/monero_wallet.dart';
import 'package:cake_wallet/src/domain/monero/subaddress.dart';
import 'package:cake_wallet/src/domain/monero/subaddress_list.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';

part 'subaddress_list_store.g.dart';

class SubaddressListStore = SubaddressListStoreBase with _$SubaddressListStore;

abstract class SubaddressListStoreBase with Store {
  @observable
  List<Subaddress> subaddresses;

  SubaddressList _subaddressList;
  StreamSubscription<Wallet> _onWalletChangeSubscription;
  StreamSubscription<List<Subaddress>> _onSubaddressesChangeSubscription;

  SubaddressListStoreBase({@required WalletService walletService}) {
    subaddresses = [];

    if (walletService.currentWallet != null) {
      _onWalletChanged(walletService.currentWallet);
    }

    _onWalletChangeSubscription =
        walletService.onWalletChange.listen(_onWalletChanged);
  }

  @override
  void dispose() {
    if (_onSubaddressesChangeSubscription != null) {
      _onSubaddressesChangeSubscription.cancel();
    }

    _onWalletChangeSubscription.cancel();
    super.dispose();
  }

  Future _updateSubaddressList() async {
    await _subaddressList.refresh(accountIndex: 0);
    subaddresses = await _subaddressList.getAll();
  }

  Future _onWalletChanged(Wallet wallet) async {
    if (_onSubaddressesChangeSubscription != null) {
      _onSubaddressesChangeSubscription.cancel();
    }

    if (wallet is MoneroWallet) {
      _subaddressList = wallet.getSubaddress();
      _onSubaddressesChangeSubscription = _subaddressList.subaddresses
          .listen((subaddress) => subaddresses = subaddress);
      await _updateSubaddressList();

      return;
    }

    print('Incorrect wallet type for this operation (SubaddressList)');
  }
}
