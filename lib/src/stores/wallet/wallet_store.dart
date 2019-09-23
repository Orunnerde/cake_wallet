import 'dart:async';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/monero/account.dart';
import 'package:cake_wallet/src/domain/monero/monero_wallet.dart';
import 'package:cake_wallet/src/domain/monero/subaddress.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:mobx/mobx.dart';

part 'wallet_store.g.dart';

class WalletStore = WalletStoreBase with _$WalletStore;

abstract class WalletStoreBase with Store {
  @observable
  String address;

  @observable
  String name;

  @observable
  Subaddress subaddress;

  @observable
  Account account;

  WalletService _walletService;
  StreamSubscription<Wallet> _onWalletChangeSubscription;

  WalletStoreBase({WalletService walletService}) {
    _walletService = walletService;
    name = "Monero Wallet";

    if (_walletService.currentWallet != null) {
      _onWalletChanged(_walletService.currentWallet)
          .then((_) => print('Data inited'));
    }

    _onWalletChangeSubscription = _walletService.onWalletChange
        .listen((wallet) async => await _onWalletChanged(wallet));
  }

  @override
  void dispose() {
    if (_onWalletChangeSubscription != null) {
      _onWalletChangeSubscription.cancel();
    }
    super.dispose();
  }

  @action
  void setAccount(Account account) {
    final wallet = _walletService.currentWallet;
    
    if (wallet is MoneroWallet) {
      this.account = account;
      wallet.account.value = account;
    }
  }

  Future _onWalletChanged(Wallet wallet) async {
    if (this == null) {
      return;
    }

    address = await wallet.getAddress();
    name = await _walletService.getName();

    if (wallet is MoneroWallet) {
      final _account = wallet.account.value;
      final subaddressList = wallet.getSubaddress();
      await subaddressList.refresh(accountIndex: _account.id);
      final subaddresses = await subaddressList.getAll();
      account = _account;
      subaddress = subaddresses[0];
    }
  }
}
