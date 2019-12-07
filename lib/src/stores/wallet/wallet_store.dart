import 'dart:async';
import 'package:cake_wallet/src/domain/common/node.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/monero/account.dart';
import 'package:cake_wallet/src/domain/monero/monero_wallet.dart';
import 'package:cake_wallet/src/domain/monero/subaddress.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';

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

  @observable
  CryptoCurrency type;

  WalletService _walletService;
  SettingsStore _settingsStore;
  StreamSubscription<Wallet> _onWalletChangeSubscription;

  @observable
  bool isValid;

  @observable
  String errorMessage;

  WalletStoreBase({WalletService walletService, SettingsStore settingsStore}) {
    _walletService = walletService;
    _settingsStore = settingsStore;
    name = "Monero Wallet";
    type = CryptoCurrency.xmr;

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
      wallet.changeAccount(account);
    }
  }

  @action
  void setSubaddress(Subaddress subaddress) {
    final wallet = _walletService.currentWallet;

    if (wallet is MoneroWallet) {
      this.subaddress = subaddress;
      wallet.changeCurrentSubaddress(subaddress);
    }
  }

  @action
  Future reconnect() async =>
      await _walletService.connectToNode(node: _settingsStore.node);

  @action
  Future rescan({int restoreHeight}) async =>
      await _walletService.rescan(restoreHeight: restoreHeight);

  @action
  Future startSync() async => await _walletService.startSync();

  @action
  Future connectToNode({Node node}) async => await _walletService.connectToNode(node: node);

  Future _onWalletChanged(Wallet wallet) async {
    if (this == null) {
      return;
    }

    wallet.onNameChange.listen((name) => this.name = name);
    wallet.onAddressChange.listen((address) => this.address = address);

    if (wallet is MoneroWallet) {
      account = wallet.account;
      wallet.subaddress.listen((subaddress) => this.subaddress = subaddress);
    }
  }

  void validateAmount(String value) {
    String p = '^[0-9]+\$';
    RegExp regExp = new RegExp(p);
    isValid = regExp.hasMatch(value);
    errorMessage = isValid ? null : 'Amount can only contain numbers';
  }
}
