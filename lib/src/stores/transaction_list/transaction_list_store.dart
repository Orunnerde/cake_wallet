import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:cake_wallet/src/domain/monero/account.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/common/transaction_info.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/domain/monero/monero_wallet.dart';

part 'transaction_list_store.g.dart';

class TransactionListStore = TransactionListBase with _$TransactionListStore;

abstract class TransactionListBase with Store {
  @observable
  List<TransactionInfo> transactions;

  WalletService _walletService;
  TransactionHistory _history;
  Account _account;
  StreamSubscription<Wallet> _onWalletChangeSubscription;
  StreamSubscription<List<TransactionInfo>> _onTransactionsChangeSubscription;
  StreamSubscription<Account> _onAccountChangeSubscription;

  TransactionListBase({@required WalletService walletService}) {
    _walletService = walletService;

    if (walletService.currentWallet != null) {
      _onWalletChanged(walletService.currentWallet);
    }

    _onWalletChangeSubscription =
        walletService.onWalletChange.listen(_onWalletChanged);
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
    _setTransactions(_transactions);
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
      _account = wallet.account.value;
      _onAccountChangeSubscription = wallet.account.listen((account) {
        _account = account;
        _updateTransactionsList();
      });
    }

    await _updateTransactionsList();
  }

  void _setTransactions(List<TransactionInfo> transactions) {
    var _transactions;

    final wallet = _walletService.currentWallet;

    if (wallet is MoneroWallet) {
      _transactions =
          transactions.where((tx) => tx.accountIndex == _account.id).toList();
    } else {
      _transactions = transactions;
    }

    this.transactions = _transactions;
  }
}
