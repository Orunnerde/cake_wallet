import 'dart:async';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/common/fetch_price.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/common/balance.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/domain/monero/monero_balance.dart';

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
  StreamSubscription<Balance> _onBalanceChangeSubscription;
  SettingsStore _settingsStore;

  BalanceStoreBase(
      {String fullBalance = '0.0',
      String unlockedBalance = '0.0',
      @required WalletService walletService,
      @required SettingsStore settingsStore}) {
    fullBalance = fullBalance;
    unlockedBalance = unlockedBalance;
    fiatFullBalance = '0.0';
    fiatUnlockedBalance = '0.0';
    isReversing = false;
    _walletService = walletService;
    _settingsStore = settingsStore;

    if (_walletService.currentWallet != null) {
      _onWalletChanged(_walletService.currentWallet);
    }

    _onWalletChangeSubscription = _walletService.onWalletChange
        .listen((wallet) => _onWalletChanged(wallet));
  }

  @override
  void dispose() {
    _onWalletChangeSubscription.cancel();

    if (_onBalanceChangeSubscription != null) {
      _onBalanceChangeSubscription.cancel();
    }

    super.dispose();
  }

  Future _onBalanceChange(Balance balance) async {
    final _balance = balance as MoneroBalance;

    if (this.fullBalance != _balance.fullBalance) {
      this.fullBalance = _balance.fullBalance;
    }

    if (this.unlockedBalance != _balance.unlockedBalance) {
      this.unlockedBalance = _balance.unlockedBalance;
    }
  }

  Future _onWalletChanged(Wallet wallet) async {
    if (_onBalanceChangeSubscription != null) {
      _onBalanceChangeSubscription.cancel();
    }

    _onBalanceChangeSubscription = _walletService.onBalanceChange
        .listen((balance) async => await _onBalanceChange(balance));

    await _updateBalances(wallet);
  }

  Future _updateBalances(Wallet wallet) async {
    if (wallet == null) {
      return;
    }

    fullBalance = await _walletService.getFullBalance();
    fiatFullBalance = await calculateAmount(
        crypto: CryptoCurrency.xmr,
        fiat: _settingsStore.fiatCurrency,
        amount: fullBalance);
    unlockedBalance = await _walletService.getUnlockedBalance();
    fiatUnlockedBalance = await calculateAmount(
        crypto: CryptoCurrency.xmr,
        fiat: _settingsStore.fiatCurrency,
        amount: unlockedBalance);
  }
}
