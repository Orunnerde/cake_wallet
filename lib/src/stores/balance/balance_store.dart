import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';

part 'balance_store.g.dart';

class BalanceStore = BalanceStoreBase with _$BalanceStore;

abstract class BalanceStoreBase with Store {
  @observable
  String fullBalance;

  @observable
  String unlockedBalance;

  @observable
  String fiatFullBalance;

  @observable
  String fiatUnlockedBalance;

  @observable
  bool isReversing;

  WalletService _walletService;
  StreamSubscription<Wallet> _onWalletChangeSubscription;
  StreamSubscription<Wallet> _onBalanceChangeSubscription;

  BalanceStoreBase(
      {String fullBalance = '0.0',
      String unlockedBalance = '0.0',
      @required WalletService walletService}) {
    fullBalance = fullBalance;
    unlockedBalance = unlockedBalance;
    fiatFullBalance = '0.0';
    fiatUnlockedBalance = '0.0';
    isReversing = false;
    _walletService = walletService;

    if (_walletService.currentWallet != null) {
      _onWalletChanged(_walletService.currentWallet);
    }

    _onWalletChangeSubscription = _walletService.onWalletChange
        .listen((wallet) => _onBalanceChange(wallet));
  }

  @override
  void dispose() {
    _onWalletChangeSubscription.cancel();

    if (_onBalanceChangeSubscription != null) {
      _onBalanceChangeSubscription.cancel();
    }

    super.dispose();
  }

  Future _onBalanceChange(Wallet wallet) async {
    final fullBalance = await wallet.getFullBalance();
    final unlockedBalance = await wallet.getUnlockedBalance();

    if (this.fullBalance != fullBalance) {
      this.fullBalance = fullBalance;
    }

    if (this.unlockedBalance != unlockedBalance) {
      this.unlockedBalance = unlockedBalance;
    }
  }

  Future _onWalletChanged(Wallet wallet) async {
    if (_onBalanceChangeSubscription != null) {
      _onBalanceChangeSubscription.cancel();
    }

    _onBalanceChangeSubscription = _walletService.onBalanceChange
        .listen((wallet) async => await _onBalanceChange(wallet));

    await _updateBalances(wallet);
  }

  Future _updateBalances(Wallet wallet) async {
    if (wallet == null) {
      return;
    }

    fullBalance = await _walletService.getFullBalance();
    unlockedBalance = await _walletService.getUnlockedBalance();
  }
}
