import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:cake_wallet/src/domain/monero/account.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/common/transaction_info.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/domain/monero/monero_wallet.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/common/fetch_price.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';

part 'transaction_list_store.g.dart';

class TransactionListStore = TransactionListBase with _$TransactionListStore;

abstract class TransactionListBase with Store {
  @observable
  List<TransactionInfo> transactions;

  WalletService _walletService;
  TransactionHistory _history;
  SettingsStore _settingsStore;
  Account _account;
  StreamSubscription<Wallet> _onWalletChangeSubscription;
  StreamSubscription<List<TransactionInfo>> _onTransactionsChangeSubscription;
  StreamSubscription<Account> _onAccountChangeSubscription;
  double _price;

  TransactionListBase(
      {@required WalletService walletService,
      @required SettingsStore settingsStore}) {
    _walletService = walletService;
    _settingsStore = settingsStore;
    _price = 0;

    if (walletService.currentWallet != null) {
      _onWalletChanged(walletService.currentWallet);
    }

    _onWalletChangeSubscription =
        walletService.onWalletChange.listen(_onWalletChanged);

    fetchPriceFor(crypto: CryptoCurrency.xmr, fiat: _settingsStore.fiatCurrency)
        .then((price) => _price = price);
  }

  @override
  void dispose() {
    if (_onTransactionsChangeSubscription != null) {
      _onTransactionsChangeSubscription.cancel();
    }

    if (_onAccountChangeSubscription != null) {
      _onAccountChangeSubscription.cancel();
    }

    _onWalletChangeSubscription.cancel();
    super.dispose();
  }

  Future _updateTransactionsList() async {
    await _history.refresh();
    final _transactions = await _history.getAll();
    await _setTransactions(_transactions);
  }

  Future _onWalletChanged(Wallet wallet) async {
    if (_onTransactionsChangeSubscription != null) {
      _onTransactionsChangeSubscription.cancel();
    }

    if (_onAccountChangeSubscription != null) {
      _onAccountChangeSubscription.cancel();
    }

    _history = wallet.getHistory();
    _onTransactionsChangeSubscription = _history.transactions
        .listen((transactions) => _setTransactions(transactions));

    if (wallet is MoneroWallet) {
      _account = wallet.account;
      _onAccountChangeSubscription = wallet.onAccountChange.listen((account) {
        _account = account;
        _updateTransactionsList();
      });
    }

    await _updateTransactionsList();
  }

  Future _setTransactions(List<TransactionInfo> transactions) async {
    List<TransactionInfo> _transactions;

    final wallet = _walletService.currentWallet;

    if (wallet is MoneroWallet) {
      _transactions =
          transactions.where((tx) => tx.accountIndex == _account.id).toList();
    } else {
      _transactions = transactions;
    }

    this.transactions = _transactions.map((tx) {
      final amount = _price * tx.amountRaw();
      final fiatAmount =
          '${amount.toStringAsFixed(2)} ${_settingsStore.fiatCurrency}';
      tx.changeFiatAmount(fiatAmount);
      return tx;
    }).toList();
  }
}
